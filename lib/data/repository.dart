import 'dart:async';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/data/mockdatastore.dart';
import 'package:flutterapp/data/nimonadatastore.dart';
import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/event/nimona_typed.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  // DataStore _dataStore = new MockDataStore();
  DataStore _dataStore = new NimonaDataStore();

  Repository._internal() {}

  StreamController<ConversationCreated> getConversations() {
    StreamController<ConversationCreated> sc = new StreamController();
    sc.addStream(_dataStore.getConversations());
    return sc;
  }

  Future<void> createConversation(String name, String topic) async {
    return _dataStore.createConversation(name, topic);
  }

  StreamController<NimonaTyped> getMessagesForConversation(
    String conversationId,
  ) {
    StreamController<NimonaTyped> sc = new StreamController();
    sc.addStream(_dataStore.getMessagesForConversation(conversationId));
    return sc;
  }

  Future<void> createMessage(String conversationHash, String body) {
    return _dataStore.createMessage(conversationHash, body);
  }
}
