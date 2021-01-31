import 'package:mochi/blocs/messages/messages_bloc.dart';
import 'package:mochi/blocs/messages/messages_state.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/flutter_messages_keys.dart';
import 'package:mochi/widgets/convesation_landing.dart';
import 'package:mochi/widgets/loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
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
      child: Column(
        children: <Widget>[
          BlocBuilder<MessagesBloc, MessagesState>(
            builder: (context, state) {
              if (state is MessagesLoaded) {
                return Container(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      state.conversation?.name,
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
                  '',
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
        Repository.get().createMessage(conversationHash, text);
      }
    }

    return Card(
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
            hintText: 'Send a message...',
            contentPadding: EdgeInsets.all(10),
            isDense: true,
            border: InputBorder.none,
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
      title: () {
        if (message.senderNickname.isEmpty) {
          return Row(
            children: [
              Text(
                '[',
                style: textTheme.caption,
                maxLines: 1,
              ),
              ParticipantPublicKey(
                message: message,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              Text(
                '] · ',
                style: textTheme.caption,
                maxLines: 1,
              ),
              Text(
                message.sent ?? '',
                style: textTheme.caption,
                maxLines: 1,
              ),
            ],
          );
        }
        return Row(
          children: [
            Text(
              message.senderNickname ?? '',
              style: textTheme.bodyText1,
              maxLines: 1,
            ),
            Text(
              ' · [',
              style: textTheme.caption,
              maxLines: 1,
            ),
            ParticipantPublicKey(
              message: message,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            Text(
              '] · ',
              style: textTheme.caption,
              maxLines: 1,
            ),
            Text(
              message.sent ?? '',
              style: textTheme.caption,
              maxLines: 1,
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
