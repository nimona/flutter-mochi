import 'dart:async';

import 'package:mochi/data/datastore.dart';
import 'package:mochi/data/wsdatastore.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/model/own_profile.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  DataStore _dataStore = new WsDataStore();

  Repository._internal() {
    // init
  }

  void createContact(String identityKey, String alias) {
    _dataStore.createContact(identityKey, alias);
  }

  StreamController<Contact> getContacts() {
    StreamController<Contact> sc = new StreamController();
    sc.addStream(_dataStore.getContacts());
    return sc;
  }

  void createMessage(String conversationHash, String body) {
    _dataStore.createMessage(conversationHash, body);
  }

  StreamController<List<Message>> getMessagesForConversation(
      String conversationId) {
    StreamController<List<Message>> sc = new StreamController();
    sc.addStream(_dataStore.getMessagesForConversation(conversationId));
    return sc;
  }

  void joinConversation(String hash) {
    _dataStore.joinConversation(hash);
  }

  void createConversation(String name, String topic) {
    _dataStore.startConversation(name, topic);
  }

  void updateOwnProfile(String nameFirst, nameLast) {
    _dataStore.updateOwnProfile(nameFirst, nameLast);
  }

  StreamController<OwnProfile> getOwnProfile() {
    StreamController<OwnProfile> sc = new StreamController();
    sc.addStream(_dataStore.getOwnProfile());
    return sc;
  }

  StreamController<Conversation> getConversations() {
    StreamController<Conversation> sc = new StreamController();
    sc.addStream(_dataStore.getConversations());
    return sc;
  }
}
