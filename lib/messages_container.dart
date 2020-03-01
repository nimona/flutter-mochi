import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversationitem.dart';

import 'model/messageitem.dart';

class MessagesContainer extends StatelessWidget {
  MessagesContainer({
    this.isInTabletLayout,
    this.item,
  });

  final bool isInTabletLayout;
  final ConversationItem item;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var stream;
    if (item == null) {
      stream = Stream<MessageItem>.empty();
    } else {
      stream = Repository.get().getMessagesForConversation(item.id).stream;
    }

    final Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
            builder:
                (BuildContext context, AsyncSnapshot<MessageItem> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  'Select conversation',
                  style: textTheme.headline6,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return Column(
                  children: [
                    Text('${snapshot.data.conversationId}'),
                    Text('${snapshot.data.user}'),
                    Text('${snapshot.data.content}'),
                  ]);
            },
            stream: stream)
      ],
    );

    if (isInTabletLayout) {
      return Center(child: content);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(item.title),
        ),
        body: Center(child: content),
      );
    }
  }
}
