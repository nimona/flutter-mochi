import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

class MessagesContainer extends StatefulWidget {
  MessagesContainer({
    this.isInTabletLayout,
    this.item,
  });

  final bool isInTabletLayout;
  Conversation item;

  final _MessagesContainer state = new _MessagesContainer();

  void updateConversation(Conversation item) {
    this.item = item;
    state.updateConversation(item);
  }

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _MessagesContainer extends State<MessagesContainer> {
  Conversation currentConversation;

  @override
  void initState() {
    super.initState();
    setState(() {
//       For the mobile-case where screen is initialised by the constructor
      currentConversation = widget.item;
    });
  }

  void updateConversation(Conversation conversation) {
    setState(() {
      currentConversation = conversation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Widget content = StreamBuilder(
        stream: Repository.get()
            .getMessagesForConversation(currentConversation?.hash)
            .stream,
        initialData: List<Message>(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          print(
              "${currentConversation?.name} : ${snapshot.hasData.toString()} | ${snapshot.connectionState}");

          if (currentConversation == null) {
            return Text(
              'Select conversation',
              style: textTheme.headline6,
            );
          }

          if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              "No messages yet",
              style: textTheme.headline6,
            );
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return Scrollbar(
              child: ListView(
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
                }).toList(),
              ),
            );
          }

          return Container();
        });

    if (widget.isInTabletLayout) {
      return Scaffold(
        // TODO remove FAB, it's just for testing
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Repository.get().createMessage(currentConversation?.hash, "");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        body: Center(child: content),
      );
    } else {
      return Scaffold(
        // TODO remove FAB, it's just for testing
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Repository.get().createMessage(currentConversation?.hash, "");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        appBar: AppBar(
          title: Text(widget.item?.name),
        ),
        body: Center(child: content),
      );
    }
  }
}
