import 'package:flutterapp/model/conversationitem.dart';
import 'package:flutterapp/model/messageitem.dart';

abstract class DataStore {
  Stream<MessageItem> getMessagesForConversation(String conversationId);

  Stream<ConversationItem> getConversations();
}
