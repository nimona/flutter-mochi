import 'dart:async';

import 'package:mochi/data/datastore.dart';
import 'package:mochi/data/nimonadatastore.dart';
import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/nimona_connection_info.dart';
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

  StreamController<NimonaTyped> getConversations(
    int limit,
    int offset,
  ) {
    StreamController<NimonaTyped> sc = new StreamController();
    sc.addStream(_dataStore.getConversations(
      limit,
      offset,
    ));
    return sc;
  }

  StreamController<NimonaTyped> subscribeToConversations() {
    StreamController<NimonaTyped> sc = new StreamController();
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

  Future<StreamController<NimonaTyped>> subscribeToMessages(  ) async {
    return await _dataStore.subscribeToMessages();
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

  Future<void> updateNickname(String conversationHash, String nickname) {
    return _dataStore.updateNickname(conversationHash, nickname);
  }

  Future<void> updateTopic(String conversationHash, String topic) {
    return _dataStore.updateTopic(conversationHash, topic);
  }

  Future<ConnectionInfo> getConnectionInfo() {
    return _dataStore.getConnectionInfo();
  }
}
