import 'dart:convert';

import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String cid;
  final String body;
  final String sent;
  final String senderCID;
  final String senderNickname;
  final bool isEdited;
  Message({
    this.cid,
    this.body,
    this.sent,
    this.senderCID,
    this.senderNickname,
    this.isEdited,
  });

  Message copyWith({
    String cid,
    String body,
    DateTime sent,
    String senderCID,
    String senderNickname,
    bool isEdited,
  }) {
    return Message(
      cid: cid ?? this.cid,
      body: body ?? this.body,
      sent: sent ?? this.sent,
      senderCID: senderCID ?? this.senderCID,
      senderNickname: senderNickname ?? this.senderNickname,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'body': body,
      'sent': sent,
      'senderCID': senderCID,
      'senderNickname': senderNickname,
      'isEdited': isEdited,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Message(
      cid: map['cid'],
      body: map['body'],
      sent: map['sent'],
      senderCID: map['senderCID'],
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
      cid,
      body,
      sent,
      senderCID,
      senderNickname,
      isEdited,
    ];
  }
}
