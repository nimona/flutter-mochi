import 'dart:async';
import 'dart:math';

class Repository {
  static final Repository _repo = new Repository._internal();

  StreamController<int> streamController = new StreamController();

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
//    startSomething();
  }

//  Stream<int> getRandomValues() async* {
//    var random = Random(2000);
//    while (true) {
//      await Future.delayed(Duration(seconds: 1));
//      yield random.nextInt(2000);
//    }
//  }

  StreamController<int> getMessagesForConversation(int conversationId) {
    StreamController<int> sc = new StreamController();
    final duration = Duration(seconds: 60);
    Timer.periodic(duration, (timer) {
      sc.add(Random().nextInt(2000));
    });

    return sc;
  }

//  getMessagesForConversation() {
//    startSomething();
//  }

  startSomething() async* {
    var random = Random(2000);
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      streamController.add(random.nextInt(2000));
    }
  }
}
