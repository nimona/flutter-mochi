import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversationitem.dart';

class ConversationListContainer extends StatefulWidget {
  ConversationListContainer({
    this.itemSelectedCallback,
    this.selectedItem,
  });

  ValueChanged<ConversationItem> itemSelectedCallback;
  ConversationItem selectedItem;

  @override
  _ConversationListContainer createState() =>
      _ConversationListContainer(itemSelectedCallback, selectedItem);
}

class _ConversationListContainer extends State<ConversationListContainer> {
  _ConversationListContainer(this.itemSelectedCallback, this.selectedItem);

  ValueChanged<ConversationItem> itemSelectedCallback;
  ConversationItem selectedItem;

  List<ConversationItem> _conversationItems = <ConversationItem>[];
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    var conversationsStream = Repository.get().getConversations().stream;
    _streamSubscription = conversationsStream.listen((conversation) {
      if (mounted) {
        setState(() {
          _conversationItems.add(conversation);
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
    return ListView(
      children: _conversationItems.map((item) {
        return ListTile(
          title: Text(item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(item.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          onTap: () => itemSelectedCallback(item),
          selected: widget.selectedItem == item,
          dense: true,
        );
      }).toList(),
    );
  }
}
