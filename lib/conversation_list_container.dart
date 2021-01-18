import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/blocs/conversations/conversations_bloc.dart';
import 'package:flutterapp/blocs/conversations/conversations_state.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/flutter_todos_keys.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/widgets/loading_indicator.dart';

class ConversationListContainer extends StatefulWidget {
  ConversationListContainer({
    this.conversationSelectedCallback,
    this.selectedItem,
  });

  ValueChanged<Conversation> conversationSelectedCallback;
  Conversation selectedItem;

  @override
  _ConversationListContainer createState() =>
      _ConversationListContainer(conversationSelectedCallback, selectedItem);
}

class _ConversationListContainer extends State<ConversationListContainer> {
  _ConversationListContainer(
      this.conversationSelectedCallback, this.selectedItem);

  ValueChanged<Conversation> conversationSelectedCallback;
  Conversation selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          if (state is ConversationsLoading) {
            return LoadingIndicator(
              key: FlutterConversationsKeys.progressIndicator,
            );
          }
          if (state is ConversationsLoaded) {
            return ListView.builder(
               itemCount: state.conversations.length,
              itemBuilder: (BuildContext context, int index) {
                final conversation = state.conversations[index];
                return ListTile(
                  title: Text(
                    conversation.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    conversation.topic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => conversationSelectedCallback(conversation),
                  selected: widget.selectedItem == conversation,
                  dense: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
