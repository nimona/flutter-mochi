import 'package:flutter/material.dart';
import 'package:flutterapp/model/conversation.dart';

import 'conversation_list_container.dart';
import 'messages_container.dart';

class MasterDetailLayout extends StatefulWidget {
  @override
  _MasterDetailLayoutState createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  static const int kTabletBreakpoint = 600;
  Conversation _selectedItem;

  @override
  Widget build(BuildContext context) {
    Widget content;
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    if (shortestSide < kTabletBreakpoint) {
      content = _buildMobileLayout();
    } else {
      content = _buildTabletLayout();
    }

    return Scaffold(
      body: content,
    );
  }

  Widget _buildMobileLayout() {
    return ConversationListContainer(
      itemSelectedCallback: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MessagesContainer(
                isInTabletLayout: false,
                item: item,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    var messagesContainer = MessagesContainer(
      isInTabletLayout: true,
      item: _selectedItem,
    );
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Material(
            elevation: 4.0,
            child: ConversationListContainer(
              itemSelectedCallback: (item) {
                setState(() {
                  _selectedItem = item;
                  messagesContainer.updateConversation(item);
                });
              },
              selectedItem: _selectedItem,
            ),
          ),
        ),
        Flexible(
          flex: 7,
          child: Material(
            elevation: 1.0,
            child: messagesContainer,
          ),
        ),
      ],
    );
  }
}
