import 'package:flutter/material.dart';
import 'package:flutterapp/viewmodel/conversationitem.dart';

class ConversationListContainer extends StatelessWidget {
  ConversationListContainer({
    this.itemSelectedCallback,
    this.selectedItem,
  });

  ValueChanged<ConversationItem> itemSelectedCallback;
  ConversationItem selectedItem;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items.map((item) {
        return ListTile(
          title: Text(item.title),
          onTap: () => itemSelectedCallback(item),
          selected: selectedItem == item,
        );
      }).toList(),
    );
  }
}
