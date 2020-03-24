import 'package:adhara_markdown/mdviewer.dart';
import 'package:adhara_markdown/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/conversation_details_container.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/view/add_conversation.dart';
import 'package:mochi/view/dialog_update_conversation.dart';
import 'package:intl/intl.dart';
import 'package:mochi/view/participant_name.dart';

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
  Stream<List<Message>> _streamMessages;
  @override
  void initState() {
    super.initState();
    setState(() {
      // For the mobile-case where screen is initialised by the constructor
      currentConversation = widget.item;
    });
    _streamMessages = Repository.get()
        .getMessagesForConversation(currentConversation?.hash)
        .stream;
  }

  void updateConversation(Conversation conversation) {
    setState(() {
      currentConversation = conversation;
    });
    _streamMessages = Repository.get()
        .getMessagesForConversation(currentConversation?.hash)
        .stream;
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

    // messages list
    Widget w = _buildMessagesListContainer();

    // container
    w = Container(
      child: w,
    );

    // scaffold
    if (widget.isInTabletLayout) {
      return Scaffold(
        body: w,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(currentConversation?.name),
        ),
        body: w,
      );
    }
  }

  Widget _buildMessagesListContainer() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var sb = StreamBuilder(
        stream: _streamMessages,
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
                        _showConversationDetailsDialog(
                          currentConversation,
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
          shrinkWrap: true,
          reverse: true,
          children: snapshot.data.reversed.map((message) {
            return () {
              var bodies = <Widget>[
                MarkdownViewer(
                  content: message.body,
                  formatTypes: [
                    MarkdownTokenTypes.bold,
                    MarkdownTokenTypes.italic,
                    MarkdownTokenTypes.strikeThrough,
                    MarkdownTokenTypes.code,
                    MarkdownTokenTypes.link,
                    MarkdownTokenTypes.mention,
                  ],
                ),
              ];
              var exp = RegExp(r'(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)');
              Iterable<RegExpMatch> matches = exp.allMatches(message.body);
              matches.forEach((match) {
                bodies.add(
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Image.network(
                      message.body.substring(match.start, match.end),
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              });
              if (message.isDense == true) {
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                        height: 18,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: message.isSameMinute
                                ? Text("")
                                : Text(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bodies,
                        ),
                      ),
                    ],
                  ),
                );
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ParticipantName(
                            context: context,
                            participant: message.participant,
                            textTheme: textTheme,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: bodies,
                              ),
                          ),
                        ],
                      ),
                    ),
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
    final messageFocusNode = FocusNode();

    void _handleSubmitted(String text) {
      if (text.isNotEmpty) {
        Repository.get().createMessage(currentConversation.hash, text);
      }
    }

    FocusScope.of(context).requestFocus(messageFocusNode);

    return new Container(
      color: Theme.of(context).cardColor,
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                // autofocus: true,
                focusNode: messageFocusNode,
                onEditingComplete: () {
                  var text = _textController.text;
                  _textController.text = "";
                  _handleSubmitted(text);
                  // WidgetsBinding.instance.addPostFrameCallback(
                  //   (_) => _textController.text="",
                  // );
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
                  var text = _textController.text;
                  _textController.text = "";
                  _handleSubmitted(text);
                  // WidgetsBinding.instance.addPostFrameCallback(
                  //   (_) => _textController.text="",
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationDetailsDialog(Conversation conversation) {
    // final nameController = TextEditingController(
    //   text: conversation.name,
    // );
    // final topicController = TextEditingController(
    //   text: conversation.topic,
    // );

    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return ConversationDetailsContainer(
            conversation: conversation,
            // nameController: nameController,
            // topicController: topicController,
          );
        }).then<void>((bool userClickedCreate) {
      if (userClickedCreate == true) {
        // Repository.get().updateConversation(
        //   hash,
        //   nameController.text,
        //   topicController.text,
        // );
      }
    });
  }
}
