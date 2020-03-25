import 'package:flutter/material.dart';
import 'package:mochi/model/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mochi/model/participant.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
  final String hash;
  final String name;
  final String topic;
  final String displayPicture;
  final DateTime lastMessage;
  final int unreadMessagesCount;
  final List<Message> unreadMessagesLatest;
  final List<Participant> participants;
  final DateTime updated;

  Conversation({
    @required this.hash,
    @required this.name,
    this.topic = "",
    this.displayPicture,
    this.lastMessage,
    this.unreadMessagesCount = 0,
    this.unreadMessagesLatest,
    this.participants,
    this.updated,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return _$ConversationFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$ConversationToJson(this);
  }
}