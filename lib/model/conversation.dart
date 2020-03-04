import 'package:flutter/material.dart';
import 'package:flutterapp/model/message.dart';
import 'package:json_annotation/json_annotation.dart';

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

  Conversation({
    @required this.hash,
    @required this.name,
    this.topic = "",
    this.displayPicture,
    this.lastMessage,
    this.unreadMessagesCount = 0,
    this.unreadMessagesLatest,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return _$ConversationFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$ConversationToJson(this);
  }
}