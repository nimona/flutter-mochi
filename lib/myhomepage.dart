import 'dart:async';

import 'package:flutter/material.dart';

import 'data/repository.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  StreamController<int> _messageStream;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    getMessagesForConversation();
    super.initState();
  }

  void getMessagesForConversation() {
    _messageStream = Repository.get().getMessagesForConversation(100);
    _messageStream.stream.listen((event) {
      setState(() {
        _counter = event.round();
      });
    });
  }

  @override
  void dispose() {
    _messageStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Random number',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}