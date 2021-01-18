import 'package:flutterapp/blocs/conversations/conversations_bloc.dart';
import 'package:flutterapp/flutter_todos_keys.dart';
import 'package:flutterapp/widgets/loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutterapp/blocs/conversations/conversations_event.dart';
import 'package:flutterapp/blocs/conversations/conversations_state.dart';

import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/message.dart';

class MessagesContainer extends StatefulWidget {
  MessagesContainer({
    this.isInTabletLayout,
    this.item,
  });

  final bool isInTabletLayout;
  Conversation item;

  final _MessagesContainer state = new _MessagesContainer();

  void updateConversation(Conversation item) {
    this.item = item;
    state.updateConversation(item);
  }

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _MessagesContainer extends State<MessagesContainer> {
  Conversation currentConversation;

  @override
  void initState() {
    super.initState();
    setState(() {
      // For the mobile-case where screen is initialised by the constructor
      currentConversation = widget.item;
    });
  }

  void updateConversation(Conversation conversation) {
    setState(() {
      currentConversation = conversation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: <Widget>[
          _buildConversationHeader(),
          Flexible(child: _buildMessagesListContainer()),
          // Divider(height: 1.0),
          _buildTextComposer(),
        ]),
      ),
    );
  }

  Widget _buildMessagesListContainer() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder(
        stream: Repository.get()
            .getMessagesForConversation(currentConversation?.hash)
            .stream,
        initialData: List<Message>(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (currentConversation == null) {
            return Center(
                child: Text(
              'Select conversation',
              style: textTheme.headline6,
            ));
          }

          if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "No messages yet",
                style: textTheme.headline6,
              ),
            );
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return _buildMessagesList(snapshot);
          }

          return Container();
        });
  }

  Container _buildConversationHeader() {
    if (currentConversation == null) {
      return Container();
    }
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          currentConversation?.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(currentConversation?.topic),
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

  Widget _buildTextComposer() {
    if (currentConversation == null) {
      return Container();
    }

    final TextEditingController _textController = new TextEditingController();

    void _handleSubmitted(String text) {
      _textController.clear();
      if (text.isNotEmpty) {
        Repository.get().createMessage(currentConversation.hash, text);
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
              hintText: "Send a message...",
              contentPadding: EdgeInsets.all(10),
              isDense: true,
              border: InputBorder.none,
            ),
          ),
        ));
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
      title: Row(
        children: [
          Text(
            message.sender.nameFirst,
            style: textTheme.bodyText1,
            maxLines: 1,
          ),
          Text(
            " · ",
            style: textTheme.bodyText1,
            maxLines: 1,
          ),
          Text(
            message.sender.key,
            style: TextStyle(
              fontFamily: textTheme.caption.fontFamily,
              fontSize: textTheme.caption.fontSize,
              color: colorScheme.primaryVariant,
            ),
            maxLines: 1,
          ),
          Text(
            " · ",
            style: textTheme.bodyText1,
            maxLines: 1,
          ),
          Text(
            timeago.format(message.sent),
            style: textTheme.caption,
            maxLines: 1,
          ),
        ],
      ),
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
