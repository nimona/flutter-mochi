import 'package:flutterapp/model/conversationitem.dart';

abstract class DataStore {
  Stream<int> getMessagesForConversation(String conversationId);

  Stream<ConversationItem> getConversations();
}
