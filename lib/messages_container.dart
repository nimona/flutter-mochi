import 'package:intl/intl.dart';
import 'package:mochi/blocs/messages/messages_bloc.dart';
import 'package:mochi/blocs/messages/messages_state.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/flutter_messages_keys.dart';
import 'package:mochi/widgets/convesation_landing.dart';
import 'package:mochi/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/model/message.dart';

class MessagesContainer extends StatefulWidget {
  MessagesContainer({
    this.isInTabletLayout,
  });

  final bool isInTabletLayout;

  final _MessagesContainer state = new _MessagesContainer();

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _MessagesContainer extends State<MessagesContainer> {
  MessagesBloc _messagesBloc;

  @override
  void initState() {
    super.initState();
    _messagesBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                if (state is MessagesLoaded) {
                  return Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        state.conversation?.topic,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: SelectableText(
                        state.conversation?.hash ?? '',
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          selectAll: true,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                if (state is MessagesInitial) {
                  return ConversationLanding(
                    'Select a conversation',
                    '/topic <new conversation topic>\n' +
                        '/nick <new conversation nick>',
                  );
                }
                if (state is MessagesNotLoaded) {
                  return ConversationLanding(
                    'There was an error loading the selected conversation',
                    '',
                  );
                }
                if (state is MessagesLoading) {
                  return LoadingIndicator(
                    key: FlutterMessagesKeys.progressIndicator,
                  );
                }
                if (state is MessagesLoaded) {
                  return Flexible(
                    child: Scrollbar(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: state.messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final pos = state.messages.length - 1 - index;
                          final message = state.messages[pos];
                          return SingleMessage(
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                            message: message,
                          );
                        },
                      ),
                    ),
                  );
                }
                return Text('ha, unknown state');
              },
            ),
            BlocBuilder<MessagesBloc, MessagesState>(
              buildWhen: (MessagesState previous, MessagesState current) {
                if (previous is MessagesLoaded) {
                  if (current is MessagesLoaded) {
                    return previous.conversation != current.conversation;
                  }
                }
                return true;
              },
              builder: (context, state) {
                if (state is MessagesLoaded) {
                  return _buildTextComposer(state.conversation.hash);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(AsyncSnapshot<List<Message>> snapshot) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scrollbar(
      child: ListView(
        reverse: true,
        children: snapshot.data.reversed.map((item) {
          return SingleMessage(
            textTheme: textTheme,
            colorScheme: colorScheme,
            message: item,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextComposer(String conversationHash) {
    final TextEditingController _textController = new TextEditingController();

    void _handleSubmitted(String text) {
      _textController.clear();
      if (text.isNotEmpty) {
        if (text.startsWith('/nick ')) {
          final nickname = text.replaceFirst('/nick ', '').trim();
          if (nickname.length == 0) {
            return;
          }
          Repository.get().updateNickname(conversationHash, nickname);
          return;
        }
        if (text.startsWith('/topic ')) {
          final topic = text.replaceFirst('/topic ', '').trim();
          if (topic.length == 0) {
            return;
          }
          Repository.get().updateTopic(conversationHash, topic);
          return;
        }
        Repository.get().createMessage(conversationHash, text);
      }
    }

    return Container(
      padding: EdgeInsets.only(
        top: 20,
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
          hoverColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          isDense: true,
          hintText: 'Send message...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          prefixIcon: Icon(
            Icons.send,
            color: Colors.grey.shade400,
            size: 14,
          ),
          filled: false,
          contentPadding: EdgeInsets.all(4),
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
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}

class SingleMessage extends StatelessWidget {
  const SingleMessage({
    Key key,
    @required this.textTheme,
    @required this.colorScheme,
    @required this.message,
  }) : super(key: key);

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: () {
                if (message.senderNickname.isEmpty) {
                  return RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '[',
                        style: textTheme.caption,
                      ),
                      TextSpan(
                        text: message.senderHash
                            .substring(message.senderHash.length - 8),
                        style: textTheme.caption,
                      ),
                      TextSpan(
                        text: ']',
                        style: textTheme.caption,
                      ),
                    ]),
                    maxLines: 1,
                  );
                }
                return RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: message.senderNickname ?? '',
                      style: textTheme.bodyText1,
                    ),
                    TextSpan(
                      text: ' · [',
                      style: textTheme.caption,
                    ),
                    TextSpan(
                      text: message.senderHash
                          .substring(message.senderHash.length - 8),
                      style: textTheme.caption,
                    ),
                    TextSpan(
                      text: ']',
                      style: textTheme.caption,
                    ),
                  ]),
                  maxLines: 1,
                );
              }(),
            ),
            Container(
              child: Text(
                () {
                  var dt = DateTime.tryParse(message.sent);
                  return DateFormat('dd/MM/yyyy kk:mm').format(dt);
                }(),
                style: textTheme.caption,
                maxLines: 1,
              ),
            ),
          ],
        );
      }(),
      subtitle: Padding(
        padding: EdgeInsets.only(
          top: 5,
        ),
        child: Text(
          message.body,
          style: textTheme.bodyText2,
        ),
      ),
    );
  }
}

class ParticipantPublicKey extends StatelessWidget {
  const ParticipantPublicKey({
    Key key,
    @required this.message,
    @required this.textTheme,
    @required this.colorScheme,
  }) : super(key: key);

  final Message message;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final publicKey =
        message.senderHash.substring(message.senderHash.length - 8);
    return Text(
      publicKey,
      style: textTheme.caption.copyWith(
        color: colorScheme.primaryVariant,
      ),
      maxLines: 1,
    );
  }
}
