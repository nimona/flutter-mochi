import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/model/own_profile.dart';
import 'package:mochi/view/dialog_create_contact.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/view/dialog_create_conversation.dart';
import 'package:mochi/view/dialog_join_conversation.dart';
import 'package:mochi/view/dialog_modify_profile.dart';

class ConversationListContainer extends StatefulWidget {
  ConversationListContainer({
    this.itemSelectedCallback,
    this.selectedItem,
  });

  ValueChanged<Conversation> itemSelectedCallback;
  Conversation selectedItem;

  @override
  _ConversationListContainer createState() =>
      _ConversationListContainer(itemSelectedCallback, selectedItem);
}

class _ConversationListContainer extends State<ConversationListContainer> {
  _ConversationListContainer(this.itemSelectedCallback, this.selectedItem);

  ValueChanged<Conversation> itemSelectedCallback;
  Conversation selectedItem;

  Map<String, Conversation> _conversationItems = {};
  StreamSubscription _streamSubscription;

  Map<String, Contact> _contacts = {};

  OwnProfile _ownProfile = OwnProfile(key: "0xF00");

  @override
  void initState() {
    super.initState();
    var conversationsStream = Repository.get().getConversations().stream;
    _streamSubscription = conversationsStream.listen((conversation) {
      if (mounted) {
        setState(() {
          _conversationItems[conversation.hash] = conversation;
        });
      }
    });
    var contactsStream = Repository.get().getContacts().stream;
    _streamSubscription = contactsStream.listen((contact) {
      if (mounted) {
        setState(() {
          _contacts[contact.key] = contact;
        });
      }
    });
    var ownProfileStream = Repository.get().getOwnProfile().stream;
    _streamSubscription = ownProfileStream.listen((ownProfile) {
      if (mounted) {
        setState(() {
          _ownProfile = ownProfile;
        });
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    String getProfileName() {
      if (_ownProfile.nameLast != "" || _ownProfile.nameLast != "") {
        return _ownProfile.nameFirst + " " + _ownProfile.nameLast;
      }
      return "Anonymous";
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.network(
                    "http://localhost:10100/displayPictures/" + _ownProfile.key,
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
                                getProfileName(),
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
                            _showUpdateOwnProfileDialog(
                              _ownProfile.nameFirst,
                              _ownProfile.nameLast,
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
                                text: _ownProfile.key,
                              ),
                            );
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Public key copied'),
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
                                  _ownProfile.key,
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
          Expanded(
            child: DefaultTabController(
              initialIndex: 1,
              length: 2,
              child: new Scaffold(
                appBar: new PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: new Container(
                    height: 56,
                    child: new TabBar(
                      labelColor: Colors.blue,
                      tabs: [
                        Container(
                          height: 56,
                          child: Center(
                            child: Text("contacts"),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Center(
                            child: Text("conversations"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: Scaffold(
                            body: Scrollbar(
                              child: ListView(
                                children: _contacts.keys.map((i) {
                                  var contact = _contacts[i];
                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: Image.network(
                                        "http://localhost:10100/displayPictures/" +
                                            contact.key,
                                        height: 40,
                                      ),
                                    ),
                                    title: Text(
                                      "@" + contact.alias,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      contact.key,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // onTap: () => itemSelectedCallback(contact),
                                    // selected: widget.selectedItem == contact,
                                    dense: true,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: RaisedButton(
                              child: Text("Add contact"),
                              onPressed: () {
                                _showCreateContactDialog();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: Scrollbar(
                            child: ListView(
                              children: _conversationItems.keys.map((i) {
                                var conversation = _conversationItems[i];
                                return ListTile(
                                  title: Text(
                                    conversation.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.network(
                                      "http://localhost:10100/displayPictures/" +
                                          conversation.hash,
                                      height: 40,
                                    ),
                                  ),
                                  trailing: Text(
                                    (conversation
                                                .unreadMessagesLatest?.length ??
                                            0)
                                        .toString(),
                                  ),
                                  subtitle: Text(
                                    conversation.topic,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () =>
                                      itemSelectedCallback(conversation),
                                  selected: widget.selectedItem == conversation,
                                  dense: true,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: RaisedButton(
                              child: Text("Create or join conversation"),
                              onPressed: () {
                                setState(() {
                                  itemSelectedCallback(null);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateOwnProfileDialog(String nameFirst, nameLast) {
    final nameFirstController = TextEditingController(
      text: nameFirst,
    );
    final nameLastController = TextEditingController(
      text: nameLast,
    );

    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return UpdateOwnProfileDialog(
            nameFirstController: nameFirstController,
            nameLastController: nameLastController,
          );
        }).then<void>((bool userClickedCreate) {
      if (userClickedCreate == true) {
        Repository.get().updateOwnProfile(
          nameFirstController.text,
          nameLastController.text,
        );
      }
    });
  }

  void _showCreateConversationDialog() {
    final nameController = TextEditingController();
    final topicController = TextEditingController();

    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CreateConversationDialog(
            nameController: nameController,
            topicController: topicController,
          );
        }).then<void>((bool userClickedCreate) {
      if (userClickedCreate == true && nameController.text.isNotEmpty) {
        Repository.get().createConversation(
          nameController.text,
          topicController.text,
        );
      }
    });
  }

  void _showJoinConversationDialog() {
    final hashController = TextEditingController();
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return JoinConversationDialog(
            hashController: hashController,
          );
        }).then<void>((bool userClickedJoin) {
      if (userClickedJoin == true && hashController.text.isNotEmpty) {
        Repository.get().joinConversation(
          hashController.text,
        );
      }
    });
  }

  void _showCreateContactDialog() {
    final aliasController = TextEditingController();
    final publicKeyController = TextEditingController();

    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CreateContactDialog(
            aliasController: aliasController,
            publicKeyController: publicKeyController,
          );
        }).then<void>((bool userClickedCreate) {
      if (userClickedCreate == true && aliasController.text.isNotEmpty) {
        Repository.get().createContact(
          publicKeyController.text,
          aliasController.text,
        );
      }
    });
  }
}
