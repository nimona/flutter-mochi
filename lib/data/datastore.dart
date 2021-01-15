import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

abstract class DataStore {
  Stream<List<Message>> getMessagesForConversation(String conversationId);

  Stream<Conversation> getConversations();

  void createMessage(String conversationHash, String body);
}
