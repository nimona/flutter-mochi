import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mochi/data/datastore.dart';
import 'package:mochi/data/ws_model/contact_add_request.dart';
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
import 'package:mochi/model/own_profile.dart';
import 'package:web_socket_channel/io.dart';

const daemonChannel = const MethodChannel('mochi.io/daemon');
const daemonPeerPort = 10800;
const daemonApiPort = 10100;
const daemonApiUrl = 'ws://localhost:';

class WsDataStore implements DataStore {
  WsDataStore() {
    startDaemon();
    // sleep(const Duration(seconds: 5));
  }

  @override
  void createContact(String identityKey, String alias) {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
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
  Stream<Contact> getContacts() async* {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
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
      daemonApiUrl + daemonApiPort.toString(),
    );
    ws.sink.add(
      json.encode(MessageCreateRequest(
        conversationHash: conversationHash,
        body: body,
      )),
    );
    ws.sink.close();
  }

  @override
  Stream<List<Message>> getMessagesForConversation(
      String conversationId) async* {
    List<Message> list = [];
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
    );
    ws.sink.add(
      json.encode(MessagesGetRequest(
        conversationHash: conversationId,
      )),
    );
    await for (final dynamic message in ws.stream) {
      var msg = Message.fromJson(json.decode(message));
      if (list.length == 0) {
        list.insert(0, msg);
        yield list;
      } else if (list.length == 1) {
        if (list[0].sent.isBefore(msg.sent)) {
          list.insert(1, msg);
        } else {
          list.insert(0, msg);
        }
      } else {
        var previousMsgIndex = list.length - 1;
        for (var i = 1; i < list.length; i++) {
          var currentMsg = list[i];
          if (currentMsg.sent.isAfter(msg.sent)) {
            previousMsgIndex = i - 1;
            break;
          }
        }
        var previousMsg = list[previousMsgIndex];
        if (previousMsg.participant.key == msg.participant.key) {
          if (previousMsg.sent.difference(msg.sent).inSeconds.abs() < 6*60*60) {
            msg = Message(
              hash: msg.hash,
              body: msg.body,
              sent: msg.sent,
              participant: msg.participant,
              isDense: true,
            );
            list.insert(previousMsgIndex+1, msg);
          } else {
            list.insert(previousMsgIndex+1, msg);
          }
        } else {
          list.insert(previousMsgIndex + 1, msg);
        }
      }
      yield list;
    }
  }

  @override
  void startConversation(String name, String topic) {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
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
      daemonApiUrl + daemonApiPort.toString(),
    );
    ws.sink.add(
      json.encode(ConversationJoinRequest(
        hash: hash,
      )),
    );
    ws.sink.close();
  }

  @override
  void updateConversation(String hash, name, topic) {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
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
  Stream<Conversation> getConversations() async* {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
    );
    ws.sink.add(
      json.encode(ConversationsGetRequest()),
    );
    await for (final dynamic message in ws.stream) {
      yield Conversation.fromJson(json.decode(message));
    }
  }

  @override
  void updateOwnProfile(String nameFirst, nameLast) {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
    );
    ws.sink.add(
      json.encode(OwnProfileUpdateRequest(
        nameFirst: nameFirst,
        nameLast: nameLast,
      )),
    );
    ws.sink.close();
  }

  @override
  Stream<OwnProfile> getOwnProfile() async* {
    final ws = IOWebSocketChannel.connect(
      daemonApiUrl + daemonApiPort.toString(),
    );
    ws.sink.add(
      json.encode(OwnProfileGetRequest()),
    );
    await for (final dynamic message in ws.stream) {
      yield OwnProfile.fromJson(json.decode(message));
    }
  }
}
