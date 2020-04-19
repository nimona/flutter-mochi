// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daemon_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaemonInfoResponse _$DaemonInfoResponseFromJson(Map<String, dynamic> json) {
  return DaemonInfoResponse(
    addresses: (json['addresses'] as List)?.map((e) => e as String)?.toList(),
    peerPublicKey: json['peerPublicKey'] as String,
    peerPrivateKey: json['peerPrivateKey'] as String,
    identityPublicKey: json['identityPublicKey'] as String,
    identityPrivateKey: json['identityPrivateKey'] as String,
    identitySecretPhrase: (json['identitySecretPhrase'] as List)
        ?.map((e) => e as String)
        ?.toList(),
  );
}

Map<String, dynamic> _$DaemonInfoResponseToJson(DaemonInfoResponse instance) =>
    <String, dynamic>{
      'addresses': instance.addresses,
      'peerPublicKey': instance.peerPublicKey,
      'peerPrivateKey': instance.peerPrivateKey,
      'identityPublicKey': instance.identityPublicKey,
      'identityPrivateKey': instance.identityPrivateKey,
      'identitySecretPhrase': instance.identitySecretPhrase,
    };
