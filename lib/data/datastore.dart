import 'package:mochi/data/ws_model/daemon_info_response.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message_block.dart';
import 'package:mochi/model/own_profile.dart';

abstract class DataStore {
  void createContact(String identityKey, String alias);

  void updateContact(String identityKey, String alias);

  Stream<Contact> getContacts();

  void createMessage(String conversationHash, String body);

  Stream<List<MessageBlock>> getMessagesForConversation(String conversationId);

  void startConversation(String name, String topic);

  void joinConversation(String hash);

  void conversationMarkRead(String hash);

  void updateConversation(String hash, name, topic);

  void updateConversationDisplayPicture(String hash, diplayPicture);

  Stream<Conversation> getConversations();

  Stream<OwnProfile> getOwnProfile();

  void updateOwnProfile(String nameFirst, nameLast, displayPicture);

  Future<DaemonInfoResponse> daemonInfoGet();

  void identityCreate(String nameFirst, nameLast, displayPicture);

  void identityLoad(String mnemonic);
}
