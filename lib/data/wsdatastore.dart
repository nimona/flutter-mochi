import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:mochi/data/datastore.dart';
import 'package:mochi/data/ws_model/contact_add_request.dart';
import 'package:mochi/data/ws_model/contact_update_request.dart';
import 'package:mochi/data/ws_model/contacts_get_request.dart';
import 'package:mochi/data/ws_model/conversation_join_request.dart';
import 'package:mochi/data/ws_model/conversation_start_request.dart';
import 'package:mochi/data/ws_model/conversation_update_request.dart';
import 'package:mochi/data/ws_model/conversations_get_request.dart';
import 'package:mochi/data/ws_model/message_create_request.dart';
import 'package:mochi/data/ws_model/messages_get_request.dart';
import 'package:mochi/data/ws_model/own_profile_get_request.dart';
import 'package:mochi/data/ws_model/own_profile_update_request.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/model/message_block.dart';
import 'package:mochi/model/own_profile.dart';
import 'package:mochi_mobile/mochi_mobile.dart';
import 'package:web_socket_channel/io.dart';

const daemonChannel = const MethodChannel('mochi.io/daemon');
const daemonPeerPort = 10800;
const daemonApiPort = 10100;
const daemonApiWsUrl = 'ws://localhost:';
const daemonApiHttpUrl = 'http://localhost:';

class WsDataStore implements DataStore {
  WsDataStore();

  @override
  void createContact(String identityKey, String alias) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ContactAddRequest(
        identityKey: identityKey,
        alias: alias,
      )),
    );
    ws.sink.close();
  }

  @override
  void updateContact(String identityKey, String alias) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ContactUpdateRequest(
        identityKey: identityKey,
        alias: alias,
      )),
    );
    ws.sink.close();
  }

  @override
  Stream<Contact> getContacts() async* {
    print("started daemon, resp=" + await MochiMobile.startDaemon());
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ContactsGetRequest()),
    );
    await for (final dynamic message in ws.stream) {
      yield Contact.fromJson(json.decode(message));
    }
  }

  static Future<dynamic> startDaemon() async {
    var args = <String, dynamic>{
      "apiPort": daemonApiPort,
      "tcpPort": daemonPeerPort,
    };
    final dynamic res = await daemonChannel.invokeMethod('startDaemon', args);
    return res;
  }

  @override
  void createMessage(String conversationHash, String body) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(MessageCreateRequest(
        conversationHash: conversationHash,
        body: body,
      )),
    );
    ws.sink.close();
  }

  MessageBlock _messageToBlock(Message msg) {
    return MessageBlock(
      alias: msg.alias,
      initialMessage: _messageToBlockItem(msg),
      nameFirst: msg.nameFirst,
      nameLast: msg.nameLast,
      profileKey: msg.profileKey,
      profileUpdated: msg.profileUpdated,
      extraMessages: [],
    );
  }

  MessageItem _messageToBlockItem(Message msg) {
    return MessageItem(
      body: msg.body,
      hash: msg.hash,
      sent: msg.sent,
      isEdited: msg.isEdited,
    );
  }

  @override
  Stream<List<MessageBlock>> getMessagesForConversation(
    String conversationId,
  ) async* {
    print("started daemon, resp=" + await MochiMobile.startDaemon());
    List<MessageBlock> list = [];
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(MessagesGetRequest(
        conversationHash: conversationId,
      )),
    );
    await for (final dynamic message in ws.stream) {
      Message msg;
      try {
        msg = Message.fromJson(json.decode(message));
      } catch (e) {
        print("error parsing json, msg=" + message.toString());
        continue;
      }
      if (list.length == 0) {
        list.insert(0, _messageToBlock(msg));
        yield list;
      } else if (list.length == 1) {
        if (list[0].initialMessage.sent.isBefore(msg.sent)) {
          list.insert(1, _messageToBlock(msg));
        } else {
          list.insert(0, _messageToBlock(msg));
        }
      } else {
        var previousMsgIndex = list.length - 1;
        for (var i = 1; i < list.length; i++) {
          var currentMsg = list[i];
          if (currentMsg.initialMessage.sent.isAfter(msg.sent)) {
            previousMsgIndex = i - 1;
            break;
          }
        }
        var previousMsg = list[previousMsgIndex];
        if (previousMsg.profileKey == msg.profileKey) {
          if (previousMsg.initialMessage.sent
                  .difference(msg.sent)
                  .inSeconds
                  .abs() <
              6 * 60 * 60) {
            var newMsg = _messageToBlockItem(msg);
            var lastItem = previousMsg.initialMessage;
            if (previousMsg.extraMessages.length > 0) {
              lastItem = previousMsg.extraMessages.last;
            }
            newMsg.isAtSameMinute = roundDown(
              lastItem.sent,
              Duration(seconds: 60),
            ).isAtSameMomentAs(
              roundDown(
                msg.sent,
                Duration(seconds: 60),
              ),
            );
            previousMsg.extraMessages.add(newMsg);
            list.removeAt(previousMsgIndex);
            list.insert(previousMsgIndex, previousMsg);
          } else {
            list.insert(previousMsgIndex + 1, _messageToBlock(msg));
          }
        } else {
          list.insert(previousMsgIndex + 1, _messageToBlock(msg));
        }
      }
      yield list;
    }
  }

  @override
  void startConversation(String name, String topic) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ConversationStartRequest(
        name: name,
        topic: topic,
      )),
    );
    ws.sink.close();
  }

  @override
  void joinConversation(String hash) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ConversationJoinRequest(
        hash: hash,
      )),
    );
    ws.sink.close();
  }

  @override
  void conversationMarkRead(String hash) {
    http.get("$daemonApiHttpUrl$daemonApiPort/conversations/$hash/mark=read");
  }

  @override
  void updateConversation(String hash, name, topic) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ConversationUpdateRequest(
        hash: hash,
        name: name,
        topic: topic,
      )),
    );
    ws.sink.close();
  }

  @override
  void updateConversationDisplayPicture(String hash, diplayPicture) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ConversationUpdateRequest(
        hash: hash,
        displayPicture: diplayPicture,
      )),
    );
    ws.sink.close();
  }

  @override
  Stream<Conversation> getConversations() async* {
    print("started daemon, resp=" + await MochiMobile.startDaemon());
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(ConversationsGetRequest()),
    );
    await for (final dynamic message in ws.stream) {
      yield Conversation.fromJson(json.decode(message));
    }
  }

  @override
  void updateOwnProfile(String nameFirst, nameLast, displayPicture) {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(OwnProfileUpdateRequest(
        nameFirst: nameFirst,
        nameLast: nameLast,
        displayPicture: displayPicture,
      )),
    );
    ws.sink.close();
  }

  @override
  Stream<OwnProfile> getOwnProfile() async* {
    final ws = IOWebSocketChannel.connect(
      "$daemonApiWsUrl$daemonApiPort",
    );
    ws.sink.add(
      json.encode(OwnProfileGetRequest()),
    );
    await for (final dynamic message in ws.stream) {
      yield OwnProfile.fromJson(json.decode(message));
    }
  }
}

DateTime roundDown(DateTime dt, Duration delta) {
  return DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch -
      dt.millisecondsSinceEpoch % delta.inMilliseconds);
}
