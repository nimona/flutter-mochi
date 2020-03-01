import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/data/mockdatastore.dart';
import 'package:flutterapp/model/conversationitem.dart';
import 'package:flutterapp/model/messageitem.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  DataStore _dataStore = new MockDataStore();

  Repository._internal() {
    // init
  }

  StreamController<List<MessageItem>> getMessagesForConversation(String conversationId) {
    StreamController<List<MessageItem>> sc = new StreamController();
    sc.addStream(_dataStore.getMessagesForConversation(conversationId));
    return sc;
  }

  StreamController<ConversationItem> getConversations() {
    StreamController<ConversationItem> sc = new StreamController();
    sc.addStream(_dataStore.getConversations());
    return sc;
  }
}
