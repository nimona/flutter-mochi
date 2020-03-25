import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'own_profile.g.dart';

@JsonSerializable()
class OwnProfile {
  final String key;
  final String nameFirst;
  final String nameLast;
  final String alias;
  final String displayPicture;
  final DateTime updated;

  OwnProfile({
    @required this.key,
    this.nameFirst = "",
    this.nameLast = "",
    this.alias = "",
    this.displayPicture,
    this.updated,
  });

  factory OwnProfile.fromJson(Map<String, dynamic> json) {
    return _$OwnProfileFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$OwnProfileToJson(this);
  }
}
