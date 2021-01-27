import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/event/nimona_typed.dart';

abstract class DataStore {
  Stream<ConversationCreated> getConversations(int limit, int offset);
  Stream<ConversationCreated> subscribeToConversations();
  Future<void> createConversation(String name, String topic);

  Stream<NimonaTyped> getMessagesForConversation(String conversationId, int limit, int offset);
  Stream<NimonaTyped> subscribeToMessagesForConversation(String conversationId);
  Future<void> createMessage(String conversationHash, String body);
}
