import 'package:flutter/material.dart';
import 'package:flutterapp/model/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
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

  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$MessageToJson(this);
  }
}