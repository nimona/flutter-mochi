import 'dart:async';

import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/nimona_connection_info.dart';
import 'package:mochi/event/nimona_typed.dart';

abstract class DataStore {
  Future<void> init();
  Future<ConnectionInfo> getConnectionInfo();

  Future<void> joinConversation(String conversationRootHash);
  Future<void> refreshConversation(String conversationRootHash);
  Stream<ConversationCreated> getConversations(int limit, int offset);
  Stream<ConversationCreated> subscribeToConversations();
  Future<void> createConversation(String name, String topic);

  Future<StreamController<NimonaTyped>> getMessagesForConversation(String conversationId, int limit, int offset);
  Future<StreamController<NimonaTyped>> subscribeToMessagesForConversation(String conversationId);
  Future<void> createMessage(String conversationHash, String body);
  Future<StreamController<ConversationMessageAdded>> subscribeToMessages();
}
