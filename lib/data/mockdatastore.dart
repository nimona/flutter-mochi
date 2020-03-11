import 'dart:async';
import 'dart:math';

import 'package:mochi/data/datastore.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/fake.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/model/own_profile.dart';

class MockDataStore implements DataStore {
  @override
  void createContact(String identityKey, String alias) {
    return;
  }

  @override
  Stream<Contact> getContacts() async* {
    return;
  }

  @override
  void createMessage(String conversationHash, String body) {
    return;
  }

  @override
  Stream<List<Message>> getMessagesForConversation(
      String conversationId) async* {
    List<Message> list = [];

    var oldMessages = Random().nextInt(500);
    for (var i = 0; i < oldMessages; i++) {
      list.add(Fake.get().getMessage());
    }

    while (true) {
      await Future.delayed(Duration(milliseconds: Random().nextInt(2500)));
      list.add(Fake.get().getMessage());
      yield list;
    }
  }

  @override
  void startConversation(String name, String topic) {
    return;
  }

  @override
  void joinConversation(String hash) {
    return;
  }

  @override
  void updateConversation(String hash, name, topic) {
    return;
  }

  @override
  Stream<Conversation> getConversations() async* {
    for (var i = 0; i < 16; i++) {
      await Future.delayed(Duration(milliseconds: Random().nextInt(2500)));
      yield Fake.get().getConversation();
    }
  }

  @override
  void updateOwnProfile(String nameFirst, nameLast) {
    return;
  }

  @override
  Stream<OwnProfile> getOwnProfile() async* {
    yield OwnProfile(
      key: "0xf00",
      alias: "me",
      nameFirst: "John",
      nameLast: "Doe",
    );
  }
}
