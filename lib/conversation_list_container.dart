import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversation.dart';

class ConversationListContainer extends StatefulWidget {
  ConversationListContainer({
    this.itemSelectedCallback,
    this.selectedItem,
  });

  ValueChanged<Conversation> itemSelectedCallback;
  Conversation selectedItem;

  @override
  _ConversationListContainer createState() =>
      _ConversationListContainer(itemSelectedCallback, selectedItem);
}

class _ConversationListContainer extends State<ConversationListContainer> {
  _ConversationListContainer(this.itemSelectedCallback, this.selectedItem);

  ValueChanged<Conversation> itemSelectedCallback;
  Conversation selectedItem;

  Map<String, Conversation> _conversationItems = {};
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    var conversationsStream = Repository.get().getConversations().stream;
    _streamSubscription = conversationsStream.listen((conversation) {
      if (mounted) {
        setState(() {
          _conversationItems[conversation.hash] = conversation;
        });
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Repository.get().startConversation("", "");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: _conversationItems.keys.map((i) {
          var conversation = _conversationItems[i];
          return ListTile(
            title: Text(
              conversation.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: Text(
              conversation.unreadMessagesCount.toString(),
            ),
            subtitle: Text(
              conversation.topic,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => itemSelectedCallback(conversation),
            selected: widget.selectedItem == conversation,
            dense: true,
          );
        }).toList(),
      ),
    );
  }
}
