import 'package:adhara_markdown/mdviewer.dart';
import 'package:adhara_markdown/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/conversation_details_container.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/model/message_block.dart';
import 'package:mochi/view/add_conversation.dart';
import 'package:mochi/view/conversation_display_picture.dart';
import 'package:intl/intl.dart';
import 'package:mochi/view/participant_name.dart';
import 'package:mochi/view/profile_display_picture.dart';

class MessagesContainer extends StatefulWidget {
  MessagesContainer({
    this.isInTabletLayout,
    this.conversation,
  });

  final bool isInTabletLayout;
  Conversation conversation;

  final _MessagesContainer state = new _MessagesContainer();

  void updateConversation(Conversation conversation) {
    this.conversation = conversation;
    state.updateConversation(conversation);
  }

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _MessagesContainer extends State<MessagesContainer> {
  Conversation currentConversation;
  Stream<List<MessageBlock>> _streamMessages;

  bool showDetails = false;
  Widget w;

  @override
  void initState() {
    print("INIT");
    super.initState();
    // setState(() {
    //   // For the mobile-case where screen is initialised by the constructor
    //   currentConversation = widget.conversation;
    // });
    _streamMessages = Repository.get()
        .getMessagesForConversation(currentConversation?.hash)
        .stream
        .asBroadcastStream();
  }

  void updateConversation(Conversation conversation) {
    print("UPDATE");
    setState(() {
      currentConversation = conversation;
      showDetails = false;
    });
    _streamMessages = Repository.get()
        .getMessagesForConversation(currentConversation?.hash)
        .stream
        .asBroadcastStream();
    w = _buildMessagesListContainer();
  }

  @override
  Widget build(BuildContext context) {
    if (currentConversation == null) {
      return _buildLanding();
    }

    if (showDetails) {
      return _buildDetails();
    }

    print("BUILD");

    // messages list
    if (w == null) {
      w = _buildMessagesListContainer();
    }

    // container
    var cw = Container(
      child: w,
    );

    // scaffold
    if (widget.isInTabletLayout) {
      return Scaffold(
        body: cw,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(currentConversation?.name),
        ),
        body: cw,
      );
    }
  }

  Widget _buildLanding() {
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

  Widget _buildDetails() {
    return ConversationDetailsContainer(
      conversation: currentConversation,
      callback: (bool update, String name, topic, displayPicture) {
        Repository.get().updateConversation(
          this.currentConversation.hash,
          name,
          topic,
        );
        Repository.get().updateConversationDisplayPicture(
          this.currentConversation.hash,
          displayPicture,
        );
        updateConversation(this.currentConversation);
      },
    );
  }

  Widget _buildMessagesListContainer() {
    var sb = StreamBuilder(
      stream: _streamMessages,
      initialData: List<MessageBlock>(),
      builder:
          (BuildContext context, AsyncSnapshot<List<MessageBlock>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return new Expanded(
            child: Center(
              child: Text(
                "No messages yet",
              ),
            ),
          );
        }

        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          return new Expanded(
            child: _buildMessagesList(snapshot),
          );
        }

        return Expanded(
          child: Container(),
        );
      },
    );

    return new Container(
        color: Color(0xFFF3F3FB),
        child: new Column(
          children: <Widget>[
            _buildConversationHeader(),
            sb,
            _buildTextComposer(),
          ],
      ),
    );
  }

  Container _buildConversationHeader() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return new Container(
      // color: Theme.of(context).cardColor,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: ConversationDisplayPicture(
              conversation: currentConversation,
              size: 56,
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
                        setState(() {
                          showDetails = true;
                        });
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

  List<Widget> _buildMessageBodies(BuildContext ctx, MessageItem msg) {
    var bodies = <Widget>[
      MarkdownViewer(
        content: msg.body,
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
    Iterable<RegExpMatch> matches = exp.allMatches(msg.body);
    matches.forEach((match) {
      bodies.add(
        Container(
          width: 250,
          margin: EdgeInsets.only(
            top: 5,
          ),
          child: Image.network(
            msg.body.substring(match.start, match.end),
            fit: BoxFit.contain,
          ),
        ),
      );
    });
    return bodies;
  }

  Widget _buildMessageItem(BuildContext ctx, MessageItem msg) {
    final TextTheme textTheme = Theme.of(ctx).textTheme;
    final dateFormatSmall = new DateFormat('hh:mm');
    return Container(
      margin: EdgeInsets.fromLTRB(0, 2, 10, 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 50,
            height: 18,
            child: Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              child: Align(
                alignment: Alignment.center,
                child: msg.isAtSameMinute
                    ? Text("")
                    : Text(
                        dateFormatSmall.format(msg.sent),
                        style: TextStyle(
                          color: textTheme.caption.color,
                          fontSize: textTheme.caption.fontSize - 2,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildMessageBodies(ctx, msg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBlock(BuildContext ctx, MessageBlock msg) {
    final TextTheme textTheme = Theme.of(ctx).textTheme;
    final dateFormatFull = new DateFormat('hh:mm');

    var msgs = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: ProfileDisplayPicture(
              profileKey: msg.profileKey,
              profileUpdated: msg.profileUpdated,
              size: 40,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ParticipantName(
                      context: context,
                      nameFirst: msg.nameFirst,
                      nameLast: msg.nameLast,
                      profileKey: msg.profileKey,
                      alias: msg.alias,
                      textTheme: textTheme,
                    ),
                    Text(
                      dateFormatFull.format(msg.initialMessage.sent),
                      style: textTheme.caption,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildMessageBodies(ctx, msg.initialMessage),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    for (var eMsg in msg.extraMessages) {
      msgs.add(_buildMessageItem(ctx, eMsg));
    }

    return Card(
      elevation: 0,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: msgs,
        ),
      ),
    );
  }

  Widget _buildMessagesList(AsyncSnapshot<List<MessageBlock>> snapshot) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        reverse: true,
        children: snapshot.data.reversed.map((msg) {
          return _buildMessageBlock(context, msg);
        }).toList(),
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
    return new Card(
      elevation: 0,
      child: new Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
