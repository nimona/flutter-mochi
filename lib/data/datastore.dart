import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/model/own_profile.dart';

abstract class DataStore {
  void createContact(String identityKey, String alias);

  Stream<Contact> getContacts();

  void createMessage(String conversationHash, String body);

  Stream<List<Message>> getMessagesForConversation(String conversationId);

  void startConversation(String name, String topic);

  void joinConversation(String hash);

  Stream<Conversation> getConversations();

  Stream<OwnProfile> getOwnProfile();

  void updateOwnProfile(String nameFirst, nameLast);
}
