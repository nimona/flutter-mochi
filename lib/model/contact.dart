import 'package:flutter/material.dart';
import 'package:mochi/model/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final String key;
  final Profile profile;
  final String alias;

  Contact({
    @required this.key,
    this.profile,
    this.alias,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return _$ContactFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$ContactToJson(this);
  }
}
