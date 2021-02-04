import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/blocs/conversations/conversations_bloc.dart';
import 'package:mochi/blocs/conversations/conversations_event.dart';
import 'package:mochi/blocs/conversations/conversations_state.dart';
import 'package:mochi/blocs/messages/messages_bloc.dart';
import 'package:mochi/blocs/messages/messages_event.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/event/nimona_connection_info.dart';
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
  ConnectionInfo _connectionInfo;

  @override
  void initState() {
    super.initState();
    _messagesBloc = BlocProvider.of(context);
    _conversationsBloc = BlocProvider.of(context);
    Repository.get().getConnectionInfo().then((value) {
      _connectionInfo = value;
    });
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

    final key = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: key,
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 30,
                      top: 20,
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
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
                  Container(
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 20,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Peer Key',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Tooltip(
                            waitDuration: Duration(
                              milliseconds: 500,
                            ),
                            message: 'Your public key',
                            verticalOffset: 10,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '@ ',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: state.publicKey
                                        .replaceFirst('ed25519.', ''),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                        ),
                        Ink(
                          child: IconButton(
                            enableFeedback: false,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.pink,
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: state.publicKey,
                                ),
                              );
                              key.currentState.showSnackBar(
                                new SnackBar(
                                  content:
                                      Text('Copied public key to clipboard'),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              color: Colors.grey.shade600,
                            ),
                            iconSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 20,
                      right: 20,
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
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '# ',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: conversation.topic ??
                                          conversation.hash,
                                      style: TextStyle(
                                        color: () {
                                          final count = state.unreadCount[
                                                  conversation.hash] ??
                                              0;
                                          if (state.selected == null) {
                                            if (count == 0) {
                                              return Colors.grey.shade700;
                                            }
                                            return Colors.black;
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
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            () {
                              final count =
                                  state.unreadCount[conversation.hash] ?? 0;
                              if (count == 0) {
                                return Container();
                              }
                              return SizedBox(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: Text(
                                      count.toString(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.pink[50],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            }()
                          ],
                        ),
                        onTap: () {
                          _conversationsBloc
                              .add(SelectConversation(conversation));
                          _messagesBloc.add(
                            LoadMessagesForConversation(
                              conversation,
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.only(
                          left: 30,
                          bottom: 0,
                          top: 0,
                          right: 20,
                        ),
                        selectedTileColor: Colors.grey.shade100,
                        focusColor: Colors.grey.shade100,
                        hoverColor: Colors.grey.shade100,
                        selected: () {
                          if (state.selected == null) {
                            return false;
                          }
                          return state.selected.hash == conversation.hash;
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
