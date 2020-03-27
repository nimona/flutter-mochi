import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String hash;
  final String body;
  final DateTime sent;
  final bool isEdited;
  final String profileKey;
  final DateTime profileUpdated;
  final String alias;
  final String nameFirst;
  final String nameLast;

  final bool isDense;
  final bool isSameMinute;

  Message({
    @required this.hash,
    @required this.body,
    @required this.sent,
    this.isEdited,
    this.profileKey,
    this.profileUpdated,
    this.alias,
    this.nameFirst,
    this.nameLast,
    this.isDense,
    this.isSameMinute,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MessageToJson(this);
  }
}
