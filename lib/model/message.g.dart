// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    hash: json['hash'] as String,
    participant: json['participant'] == null
        ? null
        : Participant.fromJson(json['participant'] as Map<String, dynamic>),
    body: json['body'] as String,
    sent: json['sent'] == null ? null : DateTime.parse(json['sent'] as String),
    isEdited: json['isEdited'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'hash': instance.hash,
      'body': instance.body,
      'sent': instance.sent?.toIso8601String(),
      'participant': instance.participant,
      'isEdited': instance.isEdited,
    };
