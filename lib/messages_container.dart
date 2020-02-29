import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/model/conversationitem.dart';

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
          style: textTheme.headline5,
        ),
        Text(
          item?.subtitle ?? 'Please select one on the left.',
          style: textTheme.subtitle1,
        ),
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
