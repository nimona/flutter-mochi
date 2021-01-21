import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Conversation extends Equatable {
  final String hash;
  final String name;
  final String topic;
  final String displayPicture;
  Conversation({
    this.hash,
    this.name,
    this.topic,
    this.displayPicture,
  });

  Conversation copyWith({
    String hash,
    String name,
    String topic,
    String displayPicture,
  }) {
    return Conversation(
      hash: hash ?? this.hash,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      displayPicture: displayPicture ?? this.displayPicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'name': name,
      'topic': topic,
      'displayPicture': displayPicture,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Conversation(
      hash: map['hash'],
      name: map['name'],
      topic: map['topic'],
      displayPicture: map['displayPicture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) => Conversation.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [hash, name, topic, displayPicture];
}
