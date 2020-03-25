// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    key: json['key'] as String,
    nameFirst: json['nameFirst'] as String,
    nameLast: json['nameLast'] as String,
    displayPicture: json['displayPicture'] as String,
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'key': instance.key,
      'nameFirst': instance.nameFirst,
      'nameLast': instance.nameLast,
      'displayPicture': instance.displayPicture,
      'updated': instance.updated?.toIso8601String(),
    };
