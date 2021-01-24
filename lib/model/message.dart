import 'dart:convert';

import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String hash;
  final String body;
  final String sent;
  final String senderHash;
  final String senderNickname;
  final bool isEdited;
  Message({
    this.hash,
    this.body,
    this.sent,
    this.senderHash,
    this.senderNickname,
    this.isEdited,
  });

  Message copyWith({
    String hash,
    String body,
    DateTime sent,
    String senderHash,
    String senderNickname,
    bool isEdited,
  }) {
    return Message(
      hash: hash ?? this.hash,
      body: body ?? this.body,
      sent: sent ?? this.sent,
      senderHash: senderHash ?? this.senderHash,
      senderNickname: senderNickname ?? this.senderNickname,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'body': body,
      'sent': sent,
      'senderHash': senderHash,
      'senderNickname': senderNickname,
      'isEdited': isEdited,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Message(
      hash: map['hash'],
      body: map['body'],
      sent: map['sent'],
      senderHash: map['senderHash'],
      senderNickname: map['senderNickname'],
      isEdited: map['isEdited'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      hash,
      body,
      sent,
      senderHash,
      senderNickname,
      isEdited,
    ];
  }
}
