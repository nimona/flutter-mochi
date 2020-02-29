import 'package:flutter/material.dart';
import 'package:flutterapp/viewmodel/conversationitem.dart';

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
    final Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item?.title ?? 'No item selected!',
          style: textTheme.headline,
        ),
        Text(
          item?.subtitle ?? 'Please select one on the left.',
          style: textTheme.subhead,
        ),
      ],
    );

    if (isInTabletLayout) {
      return Center(child: content);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Center(child: content),
    );
  }
}
