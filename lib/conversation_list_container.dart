import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/blocs/conversations/conversations_bloc.dart';
import 'package:mochi/blocs/conversations/conversations_event.dart';
import 'package:mochi/blocs/conversations/conversations_state.dart';
import 'package:mochi/blocs/messages/messages_bloc.dart';
import 'package:mochi/blocs/messages/messages_event.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/flutter_conversations_keys.dart';
import 'package:mochi/widgets/loading_indicator.dart';

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
    final TextEditingController _textController = new TextEditingController();

    void _handleSubmitted(String text) {
      _textController.clear();
      if (text.isNotEmpty) {
        Repository.get().joinConversation(text);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Repository.get().createConversation('name', 'topic');
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    child: new Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        onEditingComplete: () {
                          var text = _textController.text;
                          _handleSubmitted(text);
                        },
                        decoration: new InputDecoration(
                          hintText: 'Join conversation...',
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                          _conversationsBloc
                              .add(SelectConversation(conversation));
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
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
