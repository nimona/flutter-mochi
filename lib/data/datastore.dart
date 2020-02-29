import 'package:flutterapp/viewmodel/conversationitem.dart';

abstract class DataStore {
  Stream<int> getMessagesForConversation(int conversationId);

  Stream<ConversationItem> getConversations();
}
