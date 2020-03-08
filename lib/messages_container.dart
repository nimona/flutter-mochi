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
    if (widget.isInTabletLayout) {
      return Scaffold(
        body: Center(child: _buildMessagesListContainer()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(currentConversation?.name),
        ),
        body: Center(child: _buildMessagesListContainer()),
      );
    }
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
            return new Container(
              child: new Column(children: <Widget>[
                _buildConversationHeader(),
                new Flexible(
                  child: new Center(
                      child: Text(
                    "No messages yet",
                    style: textTheme.headline6,
                  )),
                ),
              ]),
            );
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return new Container(
              child: new Column(children: <Widget>[
                _buildConversationHeader(),
                new Divider(height: 1.0),
                new Flexible(child: _buildMessagesList(snapshot)),
                new Divider(height: 1.0),
                _buildTextComposer(),
              ]),
            );
          }

          return Container();
        });
  }

  Container _buildConversationHeader() {
    return new Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: FlutterLogo(size: 56.0),
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          currentConversation?.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(currentConversation?.topic),
        trailing: Icon(Icons.settings),
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
