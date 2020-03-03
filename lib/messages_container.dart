import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

class MessagesContainer extends StatelessWidget {
  MessagesContainer({
    this.isInTabletLayout,
    this.item,
  });

  final bool isInTabletLayout;
  final Conversation item;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var stream;
    if (item == null) {
      stream = Stream<List<Message>>.empty();
    } else {
      stream = Repository.get().getMessagesForConversation(item.hash).stream;
    }

    final Widget content = StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              'Select conversation',
              style: textTheme.headline6,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
              reverse: true,
              children: snapshot.data.reversed.map((item) {
                return ListTile(
                  title: Text(
                    item.sender.nameFirst + " (" + item.hash + ")",
                    maxLines: 1,
                    style: textTheme.caption,
                  ),
                  subtitle: Text(
                    item.body,
                    style: textTheme.bodyText2,
                  ),
                );
              }).toList());
        },
        stream: stream);

    if (isInTabletLayout) {
      return Center(child: content);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: Center(child: content),
      );
    }
  }
}
