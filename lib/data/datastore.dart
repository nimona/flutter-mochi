import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

abstract class DataStore {
  void createMessage(String conversationHash, String body);

  Stream<List<Message>> getMessagesForConversation(String conversationId);

  void startConversation(String name, String topic);

  Stream<Conversation> getConversations();
}
