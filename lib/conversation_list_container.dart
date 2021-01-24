import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/blocs/conversations/conversations_bloc.dart';
import 'package:flutterapp/blocs/conversations/conversations_event.dart';
import 'package:flutterapp/blocs/conversations/conversations_state.dart';
import 'package:flutterapp/blocs/messages/messages_bloc.dart';
import 'package:flutterapp/blocs/messages/messages_event.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/flutter_conversations_keys.dart';
import 'package:flutterapp/widgets/loading_indicator.dart';

class ConversationListContainer extends StatefulWidget {
  ConversationListContainer();

  @override
  _ConversationListContainer createState() => _ConversationListContainer();
}

class _ConversationListContainer extends State<ConversationListContainer> {
  _ConversationListContainer();

  MessagesBloc _messagesBloc;
  ConversationsBloc _conversationsBloc;

  @override
  void initState() {
    super.initState();
    _messagesBloc = BlocProvider.of(context);
    _conversationsBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Repository.get().createConversation("name", "topic");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
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
                    conversation.name ?? conversation.hash.substring(0, 8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    conversation.hash?.substring(0, 8) ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    _conversationsBloc.add(SelectConversation(conversation));
                    _messagesBloc
                        .add(LoadMessagesForConversation(conversation));
                  },
                  selected: () {
                    if (state.selected == null) {
                      return false;
                    }
                    // FIX: better to check th .hash
                    return state.selected.hashCode == conversation.hashCode;
                  }(),
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
