import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'own_profile.g.dart';

@JsonSerializable()
class OwnProfile {
  final String key;
  final String nameFirst;
  final String nameLast;
  final String localAlias;
  final String displayPicture;

  OwnProfile({
    @required this.key,
    this.nameFirst = "",
    this.nameLast = "",
    this.localAlias = "",
    this.displayPicture,
  });

  factory OwnProfile.fromJson(Map<String, dynamic> json) {
    return _$OwnProfileFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$OwnProfileToJson(this);
  }
}
