import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/data/ws_model/conversation_get_request.dart';
import 'package:flutterapp/data/ws_model/conversation_start_request.dart';
import 'package:flutterapp/data/ws_model/conversations_get_request.dart';
import 'package:flutterapp/data/ws_model/message_create_request.dart';
import 'package:flutterapp/data/ws_model/messages_get_request.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';
import 'package:web_socket_channel/io.dart';

const daemonChannel = const MethodChannel('mochi.io/daemon');
const daemonPeerPort = 10200;
const daemonApiPort = 10100;
const daemonApiUrl = 'ws://localhost:';

class WsDataStore implements DataStore {
  WsDataStore() {
    startDaemon();
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
      list.add(Message.fromJson(json.decode(message)));
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
}