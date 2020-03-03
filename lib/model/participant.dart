import 'package:flutter/material.dart';
import 'package:flutterapp/model/profile.dart';

enum ParticipantType {
  OWNER,
  ADMINISTRATOR,
  MODERATOR,
  USER,
}

class Participant {
  final String key;
  final Profile profile;
  final ParticipantType type;

  Participant({
    @required this.key,
    @required this.profile,
    this.type = ParticipantType.USER,
  });
}