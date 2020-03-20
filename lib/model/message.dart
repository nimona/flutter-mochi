import 'package:flutter/material.dart';
import 'package:mochi/model/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String hash;
  final String body;
  final DateTime sent;
  final Participant participant;
  final bool isEdited;
  final bool isDense;

  Message({
    @required this.hash,
    this.participant,
    @required this.body,
    @required this.sent,
    this.isEdited,
    this.isDense,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$MessageToJson(this);
  }
}