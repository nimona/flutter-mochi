// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnProfile _$OwnProfileFromJson(Map<String, dynamic> json) {
  return OwnProfile(
    key: json['key'] as String,
    nameFirst: json['nameFirst'] as String,
    nameLast: json['nameLast'] as String,
    alias: json['alias'] as String,
    displayPicture: json['displayPicture'] as String,
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
  );
}

Map<String, dynamic> _$OwnProfileToJson(OwnProfile instance) =>
    <String, dynamic>{
      'key': instance.key,
      'nameFirst': instance.nameFirst,
      'nameLast': instance.nameLast,
      'alias': instance.alias,
      'displayPicture': instance.displayPicture,
      'updated': instance.updated?.toIso8601String(),
    };
