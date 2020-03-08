import 'package:flutter/material.dart';
import 'package:mochi/model/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final String key;
  final Profile profile;
  final String localAlias;

  Contact({
    @required this.key,
    @required this.profile,
    @required this.localAlias,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return _$ContactFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$ContactToJson(this);
  }
}
