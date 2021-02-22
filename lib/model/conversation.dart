import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Conversation extends Equatable {
  final String cid;
  // final String name;
  final String topic;
  final String displayPicture;
  Conversation({
    this.cid,
    this.topic,
    this.displayPicture,
  });

  Conversation copyWith({
    String cid,
    String name,
    String topic,
    String displayPicture,
  }) {
    return Conversation(
      cid: cid ?? this.cid,
      topic: topic ?? this.topic,
      displayPicture: displayPicture ?? this.displayPicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'topic': topic,
      'displayPicture': displayPicture,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Conversation(
      cid: map['cid'],
      topic: map['topic'],
      displayPicture: map['displayPicture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) => Conversation.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [cid, topic, displayPicture];
}
