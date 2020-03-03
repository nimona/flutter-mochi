import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/fake.dart';
import 'package:flutterapp/model/message.dart';

class MockDataStore implements DataStore {
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
  Stream<Conversation> getConversations() async* {
    for (var i = 0; i < 16; i++) {
      await Future.delayed(Duration(milliseconds: Random().nextInt(2500)));
      yield Fake.get().getConversation();
    }
  }
}
