import 'package:flutter/material.dart';

class Profile {
  final String key;
  final String nameFirst;
  final String nameLast;
  final String localAlias;
  final String displayPicture;

  Profile({
    @required this.key,
    this.nameFirst = "",
    this.nameLast = "",
    this.localAlias = "",
    this.displayPicture,
  });
}

class LocalPeer {
  final String key;
  final Profile profile;

  LocalPeer({
    @required this.key,
    @required this.profile,
  });
}

class Contact {
  final String key;
  final Profile profile;
  final String localAlias;

  Contact({
    @required this.key,
    @required this.profile,
    @required this.localAlias,
  });
}

class Message {
  final String hash;
  final String body;
  final DateTime sent;
  final Profile sender;
  final bool isEdited;

  Message({
    @required this.hash,
    @required this.sender,
    @required this.body,
    @required this.sent,
    this.isEdited,
  });
}

enum ParticipantType {
  OWNER,
  ADMINISTRATOR,
  MODERATOR,
  USER,
}

class Participant {
  final String key;
  final Profile profile;
  final ParticipantType type;

  Participant({
    @required this.key,
    @required this.profile,
    this.type = ParticipantType.USER,
  });
}

class Conversation {
  final String hash;
  final String name;
  final String topic;
  final String displayPicture;
  final DateTime lastMessage;
  final int unreadMessagesCount;
  final List<Message> unreadMessagesLatest;

  Conversation({
    @required this.hash,
    @required this.name,
    this.topic = "",
    this.displayPicture,
    this.lastMessage,
    this.unreadMessagesCount = 0,
    this.unreadMessagesLatest,
  });
}