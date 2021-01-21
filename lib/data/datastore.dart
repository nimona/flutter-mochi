import 'package:flutterapp/event/nimona_typed.dart';
import 'package:flutterapp/model/conversation.dart';

abstract class DataStore {
  Stream<NimonaTyped> getMessagesForConversation(String conversationId);

  Stream<Conversation> getConversations();

  void createMessage(String conversationHash, String body);
}
