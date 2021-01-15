import 'dart:async';

import 'package:flutter/material.dart';
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
          Divider(height: 1.0),
          _buildTextComposer(),
        ]),
      ),
    );
  }

  Widget _buildMessagesListContainer() {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
    return new Container(
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

    return Scrollbar(
      child: ListView(
        reverse: true,
        children: snapshot.data.reversed.map((item) {
          return ListTile(
            title: Text(
              item.sender.nameFirst + " (" + item.hash + ")",
              maxLines: 1,
              style: textTheme.caption,
            ),
            subtitle: Text(
              item.body,
              style: textTheme.bodyText2,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextComposer() {
    final TextEditingController _textController = new TextEditingController();

    void _handleSubmitted(String text) {
      _textController.clear();
      if (text.isNotEmpty) {
        Repository.get().createMessage(currentConversation.hash, text);
      }
    }

    return new Container(
      margin: EdgeInsets.only(left: 8.0),
      color: Theme.of(context).cardColor,
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                onEditingComplete: () {
                  var text = _textController.text;
                  _handleSubmitted(text);
                },
                decoration: new InputDecoration.collapsed(
                    hintText: "Send a message..."),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  color: Theme.of(context).accentColor,
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }
}
