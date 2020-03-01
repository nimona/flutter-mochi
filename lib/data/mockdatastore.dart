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

  List<String> messages = [
    "Lorem ipsum dolor sit amet consectetur adipiscing elit nascetur dapibus",
    "morbi mattis tempus felis velit congue vivamus pulvinar tristique senectus",
    "scelerisque primis sem euismod lacinia viverra purus odio",
    "Tempus turpis taciti luctus nunc penatibus porttitor dapibus velit",
    "ornare urna a iaculis tellus venenatis porta sodales",
    "potenti imperdiet augue elementum quam pellentesque enim",
    "Faucibus est egestas suspendisse hendrerit nam mattis pellentesque mauris",
    "elit adipiscing pulvinar lacus erat lectus.",
    "Eu aliquet magna condimentum semper sagittis risus, primis odio quisque ridiculus rhoncus netus",
    "amet accumsan per tempor blandit. Cum porta accumsan congue ad sed",
    "nascetur ac pulvinar adipiscing nam pharetra, magnis inceptos eu quisque.",
    "Orci lacus urna volutpat commodo ac facilisi feugiat augue, nostra pulvinar himenaeos dolor neque hac dictumst",
    "massa magnis malesuada etiam pellentesque ante molestie. Aliquet netus quisque orci tortor justo diam porta posuere, quam vel torquent luctus adipiscing risus metus auctor",
    "etiam nullam sapien arcu morbi sodales habitasse. In rhoncus donec sem molestie senectus nascetur sagittis quis, ipsum aliquet accumsan fusce elementum taciti primis",
    "adipiscing platea proin aenean nostra ornare dolor. Ipsum nibh aptent risus laoreet fames dictum varius eget nec feugiat ornare",
    "eu suspendisse dui lorem id leo turpis et rhoncus cras magnis",
  ];

  @override
  Stream<List<MessageItem>> getMessagesForConversation(
      String conversationId) async* {
    List<MessageItem> list = [];

    var i = 0;

    while (true) {
      await Future.delayed(Duration(seconds: 1));
      i++;
      list.add(MessageItem(
          id: i.toString(),
          conversationId: conversationId,
          user: "User${Random().nextInt(1000).toString()}",
          content: messages[Random().nextInt(messages.length)]));
      yield list;
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
