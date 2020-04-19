// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityCreateRequest _$IdentityCreateRequestFromJson(
    Map<String, dynamic> json) {
  return IdentityCreateRequest(
    action: json['_action'] as String,
    nameFirst: json['nameFirst'] as String,
    nameLast: json['nameLast'] as String,
    displayPicture: json['displayPicture'] as String,
  );
}

Map<String, dynamic> _$IdentityCreateRequestToJson(
        IdentityCreateRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'nameFirst': instance.nameFirst,
      'nameLast': instance.nameLast,
      'displayPicture': instance.displayPicture,
    };
