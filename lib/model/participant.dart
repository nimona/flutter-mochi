import 'package:flutter/material.dart';
import 'package:mochi/model/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart';

enum ParticipantType {
  OWNER,
  ADMINISTRATOR,
  MODERATOR,
  USER,
}

@JsonSerializable()
class Participant {
  final String key;
  final Profile profile;
  final ParticipantType type;

  Participant({
    @required this.key,
    @required this.profile,
    this.type = ParticipantType.USER,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return _$ParticipantFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$ParticipantToJson(this);
  }
}