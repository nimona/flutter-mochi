// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_peer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalPeer _$LocalPeerFromJson(Map<String, dynamic> json) {
  return LocalPeer(
    key: json['key'] as String,
    profile: json['profile'] == null
        ? null
        : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocalPeerToJson(LocalPeer instance) => <String, dynamic>{
      'key': instance.key,
      'profile': instance.profile,
    };
