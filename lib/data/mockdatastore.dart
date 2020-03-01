import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/model/conversationitem.dart';
import 'package:flutterapp/model/messageitem.dart';

class MockDataStore implements DataStore {
  List<String> titles = [
    "Where did you grow up?",
    "Do you know what your your name means?",
    "What type of phone do you have?",
    "What is the first thing you do when you wake up?",
    "What was the last thing you purchased?",
    "What is your favorite meal of the day?"
  ];

  @override
  Stream<MessageItem> getMessagesForConversation(String conversationId) async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield MessageItem(
          id: Random().nextInt(1000).toString(),
          conversationId: conversationId,
          user: "User${Random().nextInt(1000).toString()}",
          content: "Message ${Random().nextInt(1000).toString()}");
    }
  }

  @override
  Stream<ConversationItem> getConversations() async* {
    titles.shuffle();

    for (var i = 0; i < 6; i++) {
      // Wait a random amount of time (up to 500ms)
      await Future.delayed(Duration(milliseconds: Random().nextInt(500)));

      var randomConversation = titles[i % titles.length];
      yield ConversationItem(
          id: "some-id-$i", title: randomConversation, subtitle: "subtitle $i");
    }
  }
}
