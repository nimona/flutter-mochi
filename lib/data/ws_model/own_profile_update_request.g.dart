// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_profile_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnProfileUpdateRequest _$OwnProfileUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return OwnProfileUpdateRequest(
    action: json['_action'] as String,
    nameFirst: json['nameFirst'] as String,
    nameLast: json['nameLast'] as String,
    displayPicture: json['displayPicture'] as String,
  );
}

Map<String, dynamic> _$OwnProfileUpdateRequestToJson(
        OwnProfileUpdateRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'nameFirst': instance.nameFirst,
      'nameLast': instance.nameLast,
      'displayPicture': instance.displayPicture,
    };
