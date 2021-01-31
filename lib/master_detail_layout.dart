import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/blocs/messages/messages_bloc.dart';
import 'package:mochi/blocs/messages/messages_event.dart';
import 'package:mochi/model/conversation.dart';

import 'conversation_list_container.dart';
import 'messages_container.dart';

class MasterDetailLayout extends StatefulWidget {
  @override
  _MasterDetailLayoutState createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  // TODO bump breakpoint to 600 and fix mobile layout
  static const int kTabletBreakpoint = 0; 

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
    return ConversationListContainer();
  }

  Widget _buildTabletLayout() {
    var messagesContainer = MessagesContainer(
      isInTabletLayout: true,
    );
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Material(
            elevation: 4.0,
            child: ConversationListContainer(),
          ),
        ),
        Flexible(
          flex: 7,
          child: Scaffold(
            body: messagesContainer,
          ),
        ),
      ],
    );
  }
}
