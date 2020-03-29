import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:mochi/model/own_profile.dart';
import 'package:mochi/view/conversation_display_picture.dart';
import 'package:mochi/view/dialog_create_contact.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/view/dialog_modify_profile.dart';
import 'package:mochi/view/own_profile_display_picture.dart';
import 'package:mochi/view/profile_display_picture.dart';

class ConversationListContainer extends StatefulWidget {
  ConversationListContainer({
    this.itemSelectedCallback,
  });

  final ValueChanged<Conversation> itemSelectedCallback;

  @override
  _ConversationListContainer createState() =>
      _ConversationListContainer(itemSelectedCallback);
}

class _ConversationListContainer extends State<ConversationListContainer> {
  _ConversationListContainer(this.itemSelectedCallback);

  ValueChanged<Conversation> itemSelectedCallback;
  String selectedConversationHash;

  Map<String, Conversation> _conversationItems = {};
  StreamSubscription _streamSubscriptionConversation;
  StreamSubscription _streamSubscriptionContact;
  StreamSubscription _streamSubscriptionOwnProfile;

  Map<String, Contact> _contacts = {};

  OwnProfile _ownProfile = OwnProfile(key: "0xF00");

  @override
  void initState() {
    super.initState();
    var conversationsStream = Repository.get().getConversations().stream;
    _streamSubscriptionConversation =
        conversationsStream.listen((conversation) {
      if (mounted) {
        setState(() {
          _conversationItems[conversation.hash] = conversation;
        });
      }
    });
    var contactsStream = Repository.get().getContacts().stream;
    _streamSubscriptionContact = contactsStream.listen((contact) {
      if (mounted) {
        setState(() {
          _contacts[contact.key] = contact;
        });
      }
    });
    var ownProfileStream = Repository.get().getOwnProfile().stream;
    _streamSubscriptionOwnProfile = ownProfileStream.listen((ownProfile) {
      if (mounted) {
        setState(() {
          _ownProfile = ownProfile;
        });
      }
    });
  }

  @override
  void dispose() {
    _streamSubscriptionConversation.cancel();
    _streamSubscriptionContact.cancel();
    _streamSubscriptionOwnProfile.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    String getProfileName() {
      var name = "${_ownProfile.nameFirst} ${_ownProfile.nameLast}".trim();
      return name.isEmpty ? "anonymous" : name;
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: OwnProfileDisplayPicture(
                  profile: _ownProfile,
                  size: 54,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getProfileName(),
                          textAlign: TextAlign.left,
                          style: textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
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
              length: 3,
              child: new Scaffold(
                appBar: new PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: new Container(
                    height: 40,
                    child: new TabBar(
                      labelColor: Colors.blue,
                      tabs: [
                        Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              "contacts",
                              style: textTheme.button,
                              overflow: TextOverflow.ellipsis,
                              semanticsLabel: "contacts",
                            ),
                          ),
                          // child: Icon(
                          //   Icons.people,
                          // ),
                        ),
                        Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              "conversations",
                              style: textTheme.button,
                              overflow: TextOverflow.ellipsis,
                              semanticsLabel: "conversations",
                            ),
                          ),
                          // child: Icon(
                          //   Icons.chat,
                          // ),
                        ),
                        Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              "settings",
                              style: textTheme.button,
                              overflow: TextOverflow.ellipsis,
                              semanticsLabel: "settings",
                            ),
                          ),
                          // child: Icon(
                          //   Icons.settings,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildContactsTab(),
                    buildConversationsTab(),
                    UpdateOwnProfileDialog(
                      profile: _ownProfile,
                      callback: (
                        bool update,
                        String nameFirst,
                        String nameLast,
                        String displayPicture,
                      ) {
                        if (update) {
                          Repository.get().updateOwnProfile(
                            nameFirst,
                            nameLast,
                            displayPicture,
                          );
                        }
                      },
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

  Widget buildConversationsTab() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormatFull = new DateFormat("EEE, MMM d, hh:mm");
    return Container(
      color: colorScheme.background,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView(
                children: _conversationItems.keys.map((i) {
                  var conversation = _conversationItems[i];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedConversationHash = conversation.hash;
                      });
                      itemSelectedCallback(conversation);
                    },
                    child: Card(
                      shape: selectedConversationHash == conversation.hash
                          ? new RoundedRectangleBorder(
                              side: new BorderSide(
                                color: colorScheme.primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            )
                          : new RoundedRectangleBorder(
                              side: new BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      elevation: 0,
                      color: Colors.white,
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   border: Border(
                          //     left: BorderSide(
                          //       color: widget.selectedConversationHash == conversation
                          //           ? colorScheme.primary
                          //           : colorScheme.surface,
                          //       width: 5,
                          //     ),
                          //   ),
                          // ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: ConversationDisplayPicture(
                                  size: 50,
                                  conversation: conversation,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              conversation.name,
                                              style: textTheme.subtitle1,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        buildConversationUnreadCountBadge(
                                          conversation,
                                          colorScheme,
                                          textTheme,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 5,
                                      thickness: 1,
                                      color: Color(0xFFF3F3FB),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        conversation.topic,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyText1,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        dateFormatFull
                                            .format(conversation.updated),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.caption,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                  // setState(() {
                  itemSelectedCallback(null);
                  // });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConversationUnreadCountBadge(
    Conversation conversation,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (selectedConversationHash == conversation.hash) {
      return Container();
    }
    if (conversation.unreadMessagesLatest.length == 0) {
      return Container();
    }
    return Badge(
      badgeContent: Align(
        alignment: Alignment.topRight,
        child: Text(
          conversation.unreadMessagesLatest.length.toString(),
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: textTheme.overline.fontSize,
          ),
        ),
      ),
      badgeColor: colorScheme.primary,
      // shape: BadgeShape.square,
      // borderRadius: 5,
    );
  }

  Widget buildContactsTab() {
    return Container(
      color: Color(0xF3F3FB),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scaffold(
              body: Scrollbar(
                child: ListView(
                  children: _contacts.keys.map((i) {
                    var contact = _contacts[i];
                    return ListTile(
                      leading: ProfileDisplayPicture(
                        profileKey: contact.profile.key,
                        profileUpdated: contact.profile.updated,
                        size: 40,
                      ),
                      title: Text(
                        "@${contact.alias}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        contact.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
    );
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
            updateContact: false,
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
