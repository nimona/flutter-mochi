import 'dart:async';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/data/wsdatastore.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  DataStore _dataStore = new WsDataStore();

  Repository._internal() {
    // init
  }

  void createMessage(String conversationHash, String body) {
    _dataStore.createMessage(conversationHash, body);
  }

  StreamController<List<Message>> getMessagesForConversation(
      String conversationId) {
    StreamController<List<Message>> sc = new StreamController();
    sc.addStream(_dataStore.getMessagesForConversation(conversationId));
    return sc;
  }

  void startConversation(String name, String topic) {
    _dataStore.startConversation(name, topic);
  }

  StreamController<Conversation> getConversations() {
    StreamController<Conversation> sc = new StreamController();
    sc.addStream(_dataStore.getConversations());
    return sc;
  }
}
