// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    hash: json['hash'] as String,
    sender: json['sender'] == null
        ? null
        : Profile.fromJson(json['sender'] as Map<String, dynamic>),
    body: json['body'] as String,
    sent: json['sent'] == null ? null : DateTime.parse(json['sent'] as String),
    isEdited: json['isEdited'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'hash': instance.hash,
      'body': instance.body,
      'sent': instance.sent?.toIso8601String(),
      'sender': instance.sender,
      'isEdited': instance.isEdited,
    };
