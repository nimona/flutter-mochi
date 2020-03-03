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
      appBar: AppBar(
        title: Text('Master-detail flow sample'),
      ),
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
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Material(
            elevation: 4.0,
            child: ConversationListContainer(
              itemSelectedCallback: (item) {
                setState(() {
                  _selectedItem = item;
                });
              },
              selectedItem: _selectedItem,
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: MessagesContainer(
            isInTabletLayout: true,
            item: _selectedItem,
          ),
        ),
      ],
    );
  }
}
