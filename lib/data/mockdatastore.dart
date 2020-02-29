import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/viewmodel/conversationitem.dart';

class MockDataStore implements DataStore {
  @override
  Stream<int> getMessagesForConversation(int conversationId) async* {
    var random = Random();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextInt(2000);
    }
  }

  @override
  Stream<ConversationItem> getConversations() async* {
    var random = Random();

    // emit upto 3 conversation items after a random delay
    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: random.nextInt(3000)));
      yield ConversationItem(
          id: "some-id-$i", title: "name $i", subtitle: "subtitle $i");
    }
  }
}
