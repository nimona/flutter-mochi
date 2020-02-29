import 'dart:async';
import 'dart:math';

class Repository {
  static final Repository _repo = new Repository._internal();

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    // init
  }

  StreamController<int> getMessagesForConversation(int conversationId) {
    StreamController<int> sc = new StreamController();
    final duration = Duration(seconds: 1);
    Timer.periodic(duration, (timer) {
      sc.add(Random().nextInt(2000));
    });

    return sc;
  }
}
