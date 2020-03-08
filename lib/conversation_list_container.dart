import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/model/own_profile.dart';
import 'package:flutterapp/view/dialog_create_contact.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/view/dialog_create_conversation.dart';
import 'package:flutterapp/view/dialog_modify_profile.dart';

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
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            leading: FlutterLogo(size: 56.0),
            contentPadding: EdgeInsets.all(16.0),
            title: () {
              if (_ownProfile.nameLast != "" || _ownProfile.nameLast != "") {
                return Text(_ownProfile.nameFirst + " " + _ownProfile.nameLast);
              }
              return Text(
                "Anonymous",
                style: TextStyle(
                  color: Colors.grey,
                ),
              );
            }(),
            subtitle: Text(
              _ownProfile.key,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            // trailing: Icon(Icons.account_circle),
            onTap: () {
              _showUpdateOwnProfileDialog();
            },
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
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          _showCreateContactDialog();
                        },
                        child: Icon(Icons.add),
                        backgroundColor: Colors.blue,
                      ),
                      body: Scrollbar(
                        child: ListView(
                          children: _contacts.keys.map((i) {
                            var contact = _contacts[i];
                            return ListTile(
                              title: Text(
                                contact.localAlias,
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
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          _showCreateConversationDialog();
                        },
                        child: Icon(Icons.add),
                        backgroundColor: Colors.blue,
                      ),
                      body: Scrollbar(
                        child: ListView(
                          children: _conversationItems.keys.map((i) {
                            var conversation = _conversationItems[i];
                            return ListTile(
                              title: Text(
                                conversation.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Text(
                                conversation.unreadMessagesCount.toString(),
                              ),
                              subtitle: Text(
                                conversation.topic,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => itemSelectedCallback(conversation),
                              selected: widget.selectedItem == conversation,
                              dense: true,
                            );
                          }).toList(),
                        ),
                      ),
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

  void _showUpdateOwnProfileDialog() {
    final nameFirstController = TextEditingController();
    final nameLastController = TextEditingController();

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
