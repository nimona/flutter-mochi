// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_add_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactAddRequest _$ContactAddRequestFromJson(Map<String, dynamic> json) {
  return ContactAddRequest(
    action: json['_action'] as String,
    alias: json['alias'] as String,
    identityKey: json['identityKey'] as String,
  );
}

Map<String, dynamic> _$ContactAddRequestToJson(ContactAddRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'alias': instance.alias,
      'identityKey': instance.identityKey,
    };
