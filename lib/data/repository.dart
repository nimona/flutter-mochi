import 'dart:async';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/data/mockdatastore.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  DataStore _dataStore = new MockDataStore();

  Repository._internal() {}

  StreamController<Message> getMessagesForConversation(
    String conversationId,
  ) {
    StreamController<Message> sc = new StreamController();
    sc.addStream(_dataStore.getMessagesForConversation(conversationId));
    return sc;
  }

  StreamController<Conversation> getConversations() {
    StreamController<Conversation> sc = new StreamController();
    sc.addStream(_dataStore.getConversations());
    return sc;
  }

  void createMessage(String conversationHash, String body) {
    _dataStore.createMessage(conversationHash, body);
  }
}
