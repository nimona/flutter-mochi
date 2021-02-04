import 'package:intl/intl.dart';
import 'package:mochi/app_localizations.dart';
import 'package:mochi/blocs/messages/messages_bloc.dart';
import 'package:mochi/blocs/messages/messages_state.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/date_formatter.dart';
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
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          bottom: 20,
          right: 10,
        ),
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
                      isAlwaysShown: true,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: state.messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final pos = state.messages.length - 1 - index;
                          final message = state.messages[pos];
                          var sameSender = false;
                          var sameDay = false;
                          var sameHour = false;
                          var sameMinute = false;
                          if (pos > 0 && pos <= state.messages.length) {
                            final previousMessage = state.messages[pos - 1];
                            if (previousMessage != null) {
                              sameSender = message.senderHash ==
                                  previousMessage.senderHash;
                              var dt =
                                  DateTime.tryParse(message.sent).toLocal();
                              var pdt = DateTime.tryParse(previousMessage.sent)
                                  .toLocal();
                              sameDay =
                                  roundDown(dt, delta: Duration(days: 1)) ==
                                      roundDown(pdt, delta: Duration(days: 1));
                              sameHour =
                                  roundDown(dt, delta: Duration(hours: 1)) ==
                                      roundDown(pdt, delta: Duration(hours: 1));
                              sameMinute = roundDown(dt,
                                      delta: Duration(minutes: 1)) ==
                                  roundDown(pdt, delta: Duration(minutes: 1));
                            }
                          }
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: SingleMessage(
                              sameSender: sameSender,
                              sameDay: sameDay,
                              sameHour: sameHour,
                              sameMinute: sameMinute,
                              textTheme: textTheme,
                              colorScheme: colorScheme,
                              message: message,
                            ),
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
        top: 30,
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
    this.sameSender,
    this.sameDay,
    this.sameHour,
    this.sameMinute,
  }) : super(key: key);

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final Message message;

  final bool sameSender;
  final bool sameDay;
  final bool sameHour;
  final bool sameMinute;

  @override
  Widget build(BuildContext context) {
    var showDateTime = () {
      var dt = DateTime.tryParse(message.sent).toLocal();
      if (sameMinute) {
        return Container();
      }
      if (sameDay) {
        return Text(
          DateFormat('HH:mm').format(dt),
          textAlign: TextAlign.right,
          style: TextStyle(
            color: textTheme.caption.color,
            fontSize: textTheme.caption.fontSize,
          ),
          maxLines: 1,
        );
      }
      return Text(
        DateFormatter(
          AppLocalizations.of(context),
        ).getVerboseDateTimeRepresentation(dt),
        textAlign: TextAlign.right,
        style: TextStyle(
          color: textTheme.caption.color,
          fontSize: textTheme.caption.fontSize,
        ),
        maxLines: 1,
      );
    };
    return Column(
      children: [
        () {
          if (sameSender) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
              right: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: () {
                    if (message.senderNickname.isEmpty) {
                      return RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
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
                          ],
                        ),
                        maxLines: 1,
                      );
                    }
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: message.senderNickname ?? '',
                            style: textTheme.bodyText1.copyWith(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
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
                        ],
                      ),
                      maxLines: 1,
                    );
                  }(),
                ),
                Container(
                  child: showDateTime(),
                ),
              ],
            ),
          );
        }(),
        Padding(
          padding: EdgeInsets.only(
            top: 5,
            right: 25,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message.body,
                  textAlign: TextAlign.left,
                  style: textTheme.bodyText2.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              () {
                if (sameSender) {
                  return Container(
                    child: showDateTime(),
                  );
                }
                return Container();
              }(),
            ],
          ),
        ),
      ],
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

DateTime roundDown(DateTime dt,
    {Duration delta = const Duration(seconds: 15)}) {
  return DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch -
      dt.millisecondsSinceEpoch % delta.inMilliseconds);
}
