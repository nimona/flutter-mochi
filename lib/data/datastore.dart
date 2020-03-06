import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

abstract class DataStore {
  void createContact(String identityKey, String alias);

  Stream<Contact> getContacts();

  void createMessage(String conversationHash, String body);

  Stream<List<Message>> getMessagesForConversation(String conversationId);

  void startConversation(String name, String topic);

  Stream<Conversation> getConversations();
}
