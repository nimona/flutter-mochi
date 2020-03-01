import 'package:flutterapp/model/conversationitem.dart';
import 'package:flutterapp/model/messageitem.dart';

abstract class DataStore {
  Stream<List<MessageItem>> getMessagesForConversation(String conversationId);

  Stream<ConversationItem> getConversations();
}
