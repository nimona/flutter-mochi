import 'dart:async';
import 'dart:math';

import 'package:flutterapp/data/datastore.dart';

class MockDataStore implements DataStore {
  @override
  Stream<int> getMessagesForConversation(int conversationId) async* {
    var random = Random();
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextInt(2000);
    }
  }
}
