import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/fake.dart';
import 'package:flutterapp/model/message.dart';

class MockDataStore implements DataStore {
  static List<Message> messageList = [];

  @override
  Stream<List<Message>> getMessagesForConversation(
    String conversationId,
  ) async* {
    var oldMessages = Random().nextInt(500);
    for (var i = 0; i < oldMessages; i++) {
      messageList.add(Fake.get().getMessage());
    }

    while (true) {
      await Future.delayed(
        Duration(
          milliseconds: Random().nextInt(5000) + 1000,
        ),
      );
      messageList.add(Fake.get().getMessage());
      yield messageList;
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
    messageList.add(message);
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
