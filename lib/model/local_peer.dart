import 'package:flutter/material.dart';
import 'package:flutterapp/model/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_peer.g.dart';

@JsonSerializable()
class LocalPeer {
  final String key;
  final Profile profile;

  LocalPeer({
    @required this.key,
    @required this.profile,
  });

  factory LocalPeer.fromJson(Map<String, dynamic> json) {
    return _$LocalPeerFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$LocalPeerToJson(this);
  }
}