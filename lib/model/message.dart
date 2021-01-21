import 'package:flutter/material.dart';

class Message {
  final String hash;
  final String body;
  final DateTime sent;
  final String senderHash;
  final String senderNickname;
  final bool isEdited;

  Message({
    @required this.hash,
    @required this.senderHash,
    @required this.senderNickname,
    @required this.body,
    @required this.sent,
    this.isEdited,
  });
}