import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/view/dialog_create_contact.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/view/dialog_create_conversation.dart';

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
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            height: 35.0,
            child: new TabBar(
              labelColor: Colors.blue,
              tabs: [
                Text("contacts"),
                Text("conversations"),
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
    );
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
