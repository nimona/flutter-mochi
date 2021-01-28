import 'dart:async';

import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/event/nimona_typed.dart';

abstract class DataStore {
  Future<void> init();

  Stream<ConversationCreated> getConversations(int limit, int offset);
  Stream<ConversationCreated> subscribeToConversations();
  Future<void> createConversation(String name, String topic);

  Future<StreamController<NimonaTyped>> getMessagesForConversation(String conversationId, int limit, int offset);
  Future<StreamController<NimonaTyped>> subscribeToMessagesForConversation(String conversationId);
  Future<void> createMessage(String conversationHash, String body);
}
