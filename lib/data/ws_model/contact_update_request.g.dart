// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactUpdateRequest _$ContactUpdateRequestFromJson(Map<String, dynamic> json) {
  return ContactUpdateRequest(
    action: json['_action'] as String,
    alias: json['alias'] as String,
    identityKey: json['identityKey'] as String,
  );
}

Map<String, dynamic> _$ContactUpdateRequestToJson(
        ContactUpdateRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'alias': instance.alias,
      'identityKey': instance.identityKey,
    };
