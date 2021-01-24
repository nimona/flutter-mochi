import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/event/nimona_typed.dart';

abstract class DataStore {
  Stream<ConversationCreated> getConversations();
  Future<void> createConversation(String name, String topic);

  Stream<NimonaTyped> getMessagesForConversation(String conversationId);
  Future<void> createMessage(String conversationHash, String body);
}
