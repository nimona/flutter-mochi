import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/view/add_conversation.dart';
import 'package:mochi/view/dialog_update_conversation.dart';
import 'package:intl/intl.dart';

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
    if (currentConversation == null) {
      final nameController = TextEditingController();
      final topicController = TextEditingController();
      final hashController = TextEditingController();
      return Scaffold(
        body: Container(
          child: AddConversationWidget(
            nameController: nameController,
            topicController: topicController,
            hashController: hashController,
          ),
        ),
      );
    }
    if (widget.isInTabletLayout) {
      return Scaffold(
        body: Container(
          child: _buildMessagesListContainer(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(currentConversation?.name),
        ),
        body: Container(
          child: _buildMessagesListContainer(),
        ),
      );
    }
  }

  Widget _buildMessagesListContainer() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var sb = StreamBuilder(
        stream: Repository.get()
            .getMessagesForConversation(currentConversation?.hash)
            .stream,
        initialData: List<Message>(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: Text(
                "No messages yet",
                style: textTheme.headline6,
              ),
            );
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return new Flexible(
              child: _buildMessagesList(snapshot),
            );
          }

          return Container();
        });

    return new Container(
        child: new Column(children: <Widget>[
      _buildConversationHeader(),
      new Divider(height: 1.0),
      sb,
      new Divider(height: 1.0),
      _buildTextComposer(),
    ]));
  }

  Container _buildConversationHeader() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return new Container(
      color: Theme.of(context).cardColor,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                "http://localhost:10100/displayPictures/" +
                    currentConversation.hash,
                height: 56,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Text(
                            currentConversation.name,
                            textAlign: TextAlign.left,
                            style: textTheme.headline6,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.mode_edit,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 20,
                          ),
                        ],
                      ),
                      onTap: () {
                        _showUpdateConversationDialog(
                          currentConversation.hash,
                          currentConversation.name,
                          currentConversation.topic,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: currentConversation.hash,
                          ),
                        );
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Conversation hash copied'),
                            duration: Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.content_copy,
                            size: 13,
                          ),
                          SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              currentConversation?.hash,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(AsyncSnapshot<List<Message>> snapshot) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final dateFormatFull = new DateFormat('hh:mm');
    final dateFormatSmall = new DateFormat('hh:mm');

    return Scrollbar(
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        child: ListView(
          reverse: true,
          children: snapshot.data.reversed.map((message) {
            return () {
              if (message.isDense == true) {
                return Container(
                    margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 40,
                            height: 18,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                dateFormatSmall.format(message.sent),
                                style: TextStyle(
                                  color: textTheme.caption.color,
                                  fontSize: textTheme.caption.fontSize - 2,
                                ),
                                // textAlign: TextAlign.,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          message.body,
                          style: textTheme.bodyText2,
                        ),
                      ],
                    ));
              }
              return Container(
                margin: EdgeInsets.fromLTRB(10, 18, 10, 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.network(
                          "http://localhost:10100/displayPictures/" +
                              message.participant?.key,
                          height: 40,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.participant?.profile?.nameFirst.toString() +
                              " " +
                              message.participant?.profile?.nameLast
                                  .toString() +
                              " (" +
                              dateFormatFull.format(message.sent) +
                              ")",
                          style: textTheme.caption,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            message.body,
                            style: textTheme.bodyText2,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }();
          }).toList(),
        ),
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
      color: Theme.of(context).cardColor,
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                autofocus: true,
                onEditingComplete: () {
                  var text = _textController.text;
                  _handleSubmitted(text);
                },
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message...",
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  _handleSubmitted(_textController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateConversationDialog(String hash, name, topic) {
    final nameController = TextEditingController(
      text: name,
    );
    final topicController = TextEditingController(
      text: topic,
    );

    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return UpdateConversationDialog(
            nameController: nameController,
            topicController: topicController,
          );
        }).then<void>((bool userClickedCreate) {
      if (userClickedCreate == true) {
        Repository.get().updateConversation(
          hash,
          nameController.text,
          topicController.text,
        );
      }
    });
  }
}
