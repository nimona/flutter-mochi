// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_load_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityLoadRequest _$IdentityLoadRequestFromJson(Map<String, dynamic> json) {
  return IdentityLoadRequest(
    action: json['_action'] as String,
    mnemonic: json['mnemonic'] as String,
  );
}

Map<String, dynamic> _$IdentityLoadRequestToJson(
        IdentityLoadRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'mnemonic': instance.mnemonic,
    };
