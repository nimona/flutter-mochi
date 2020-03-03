import 'package:flutter/material.dart';
import 'package:flutterapp/model/profile.dart';

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