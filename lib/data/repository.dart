import 'dart:async';

import 'package:mochi/data/datastore.dart';
import 'package:mochi/data/nimonadatastore.dart';
import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/nimona_typed.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  // DataStore _dataStore = new MockDataStore();
  DataStore _dataStore = new NimonaDataStore();

  Repository._internal() {
    _dataStore.init();
  }

  Future<void> refreshConversation(
    String conversationRootHash,
  ) async {
    return _dataStore.refreshConversation(conversationRootHash);
  }

  Future<void> joinConversation(
    String conversationRootHash,
  ) async {
    return _dataStore.joinConversation(conversationRootHash);
  }

  StreamController<ConversationCreated> getConversations(
    int limit,
    int offset,
  ) {
    StreamController<ConversationCreated> sc = new StreamController();
    sc.addStream(_dataStore.getConversations(
      limit,
      offset,
    ));
    return sc;
  }

  StreamController<ConversationCreated> subscribeToConversations() {
    StreamController<ConversationCreated> sc = new StreamController();
    sc.addStream(_dataStore.subscribeToConversations());
    return sc;
  }

  Future<void> createConversation(String name, String topic) async {
    return _dataStore.createConversation(name, topic);
  }

  Future<StreamController<NimonaTyped>> subscribeToMessagesForConversation(
    String conversationId,
  ) async {
    return await _dataStore.subscribeToMessagesForConversation(conversationId);
  }

  Future<StreamController<NimonaTyped>> getMessagesForConversation(
    String conversationId,
    int limit,
    int offset,
  ) async {
    return await _dataStore.getMessagesForConversation(
      conversationId,
      limit,
      offset,
    );
  }

  Future<void> createMessage(String conversationHash, String body) {
    return _dataStore.createMessage(conversationHash, body);
  }
}
