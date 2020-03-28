import 'package:flutter/material.dart';

class MessageItem {
  String hash;
  String body;
  DateTime sent;
  bool isEdited;
  bool isAtSameMinute;

  MessageItem({
    @required this.hash,
    @required this.body,
    @required this.sent,
    this.isEdited,
    this.isAtSameMinute,
  });
}

class MessageBlock {
  MessageItem initialMessage;
  List<MessageItem> extraMessages = [];
  String profileKey;
  DateTime profileUpdated;
  String alias;
  String nameFirst;
  String nameLast;

  MessageBlock({
    this.initialMessage,
    this.profileKey,
    this.profileUpdated,
    this.alias,
    this.nameFirst,
    this.nameLast,
    this.extraMessages,
  });
}
