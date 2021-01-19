import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/fake.dart';
import 'package:flutterapp/model/message.dart';

class MockDataStore implements DataStore {
  @override
  Stream<Message> getMessagesForConversation(
    String conversationId,
  ) async* {
    for (var i = 0; i < 5; i++) {
      yield Fake.get().getMessage();
    }
    while (true) {
      await Future.delayed(
        Duration(
          milliseconds: Random().nextInt(5000) + 1000,
        ),
      );
      yield Fake.get().getMessage();
    }
  }

  @override
  void createMessage(String conversationHash, String body) {
    Message fakeMessage = Fake.get().getMessage();
    Message message = Message(
      body: body,
      sender: fakeMessage.sender,
      hash: fakeMessage.hash,
      sent: fakeMessage.sent,
      isEdited: fakeMessage.isEdited,
    );
    return;
  }

  @override
  Stream<Conversation> getConversations() async* {
    for (var i = 0; i < 5; i++) {
      await Future.delayed(Duration(milliseconds: Random().nextInt(2500)));
      yield Fake.get().getConversation();
    }
  }
}
