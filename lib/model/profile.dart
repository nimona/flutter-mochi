import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String key;
  final String nameFirst;
  final String nameLast;
  final String localAlias;
  final String displayPicture;

  Profile({
    @required this.key,
    this.nameFirst = "",
    this.nameLast = "",
    this.localAlias = "",
    this.displayPicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$ProfileToJson(this);
  }
}
