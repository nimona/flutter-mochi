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
      backgroundColor: Colors.grey.shade100,
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
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Mochi',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Container(
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                color: Colors.pink,
                                size: 14,
                              ),
                              label: Container(
                                child: Text(
                                  'New',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.pink,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                  bottom: 2,
                                  right: 2,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: 8,
                                  bottom: 8,
                                ),
                                backgroundColor: Colors.pink[50],
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.pink,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                Repository.get()
                                    .createConversation('name', 'topic');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      onEditingComplete: () {
                        var text = _textController.text;
                        _handleSubmitted(text);
                      },
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 35,
                          minHeight: 35,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        isDense: true,
                        hintText: 'Join conversation...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.plus_one,
                          color: Colors.grey.shade400,
                          size: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.none,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(
                      top: 16,
                      bottom: 8,
                      left: 16,
                      right: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Conversations',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // InkWell(
                        //   hoverColor: Colors.pink[50],
                        //   customBorder: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Center(
                        //     child: Container(
                        //       padding: EdgeInsets.only(
                        //         top: 4,
                        //         bottom: 4,
                        //         left: 8,
                        //         right: 8,
                        //       ),
                        //       child: Icon(
                        //         Icons.add,
                        //         size: 16,
                        //         color: Colors.pink,
                        //       ),
                        //     ),
                        //   ),
                        //   onTap: () {
                        //     Repository.get()
                        //         .createConversation('name', 'topic');
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.conversations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final conversation = state.conversations[index];
                      return ListTile(
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '# ',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              TextSpan(
                                text: conversation.name ?? conversation.hash,
                                style: TextStyle(
                                  color: () {
                                    if (state.selected == null) {
                                      return Colors.grey.shade700;
                                    }
                                    if (state.selected.hash ==
                                        conversation.hash) {
                                      return Colors.pink;
                                    }
                                    return Colors.grey.shade700;
                                  }(),
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          _conversationsBloc
                              .add(SelectConversation(conversation));
                          _messagesBloc
                              .add(LoadMessagesForConversation(conversation));
                        },
                        contentPadding: EdgeInsets.only(
                          left: 32,
                          bottom: 0,
                          top: 0,
                        ),
                        selectedTileColor: Colors.grey.shade100,
                        focusColor: Colors.grey.shade100,
                        hoverColor: Colors.grey.shade100,
                        selected: () {
                          if (state.selected == null) {
                            return false;
                          }
                          // FIX: better to check th .hash
                          return state.selected.hashCode ==
                              conversation.hashCode;
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
