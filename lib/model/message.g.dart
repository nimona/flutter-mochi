// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    hash: json['hash'] as String,
    body: json['body'] as String,
    sent: json['sent'] == null ? null : DateTime.parse(json['sent'] as String),
    isEdited: json['isEdited'] as bool,
    profileKey: json['profileKey'] as String,
    profileUpdated: json['profileUpdated'] == null
        ? null
        : DateTime.parse(json['profileUpdated'] as String),
    alias: json['alias'] as String,
    nameFirst: json['nameFirst'] as String,
    nameLast: json['nameLast'] as String,
    isDense: json['isDense'] as bool,
    isSameMinute: json['isSameMinute'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'hash': instance.hash,
      'body': instance.body,
      'sent': instance.sent?.toIso8601String(),
      'isEdited': instance.isEdited,
      'profileKey': instance.profileKey,
      'profileUpdated': instance.profileUpdated?.toIso8601String(),
      'alias': instance.alias,
      'nameFirst': instance.nameFirst,
      'nameLast': instance.nameLast,
      'isDense': instance.isDense,
      'isSameMinute': instance.isSameMinute,
    };
