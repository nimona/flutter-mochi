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
    localAlias: json['localAlias'] as String,
    displayPicture: json['displayPicture'] as String,
  );
}

Map<String, dynamic> _$OwnProfileToJson(OwnProfile instance) =>
    <String, dynamic>{
      'key': instance.key,
      'nameFirst': instance.nameFirst,
      'nameLast': instance.nameLast,
      'localAlias': instance.localAlias,
      'displayPicture': instance.displayPicture,
    };
