import 'package:flutter/material.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/conversation.dart';

import 'conversation_list_container.dart';
import 'messages_container.dart';

class MasterDetailLayout extends StatefulWidget {
  @override
  _MasterDetailLayoutState createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  static const int kTabletBreakpoint = 600;
  Conversation selectedConversation;

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
        Repository.get().conversationMarkRead(item.hash);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Material(
                child: MessagesContainer(
                  isInTabletLayout: false,
                  conversation: item,
                ),
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
      conversation: selectedConversation,
    );
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Material(
            // elevation: 4.0,
            child: ConversationListContainer(
              itemSelectedCallback: (conversation) {
                // mark both old and new conversation as read
                // we do this as the backend is not clever enough to know
                // that we had the conversation open until now
                if (selectedConversation != null) {
                  Repository.get().conversationMarkRead(
                    selectedConversation.hash,
                  );
                }
                if (conversation != null) {
                  Repository.get().conversationMarkRead(
                    conversation.hash,
                  );
                }
                setState(() {
                  // reset the focus of everything, this is because of 221
                  FocusScope.of(context).requestFocus(new FocusNode());
                  selectedConversation = conversation;
                  messagesContainer.updateConversation(conversation);
                });
              },
            ),
          ),
        ),
        Flexible(
          flex: 7,
          child: Material(
            // elevation: 1.0,
            child: messagesContainer,
          ),
        ),
      ],
    );
  }
}
