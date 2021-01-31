import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mochi/model/profile.dart';

enum ParticipantType {
  OWNER,
  ADMINISTRATOR,
  MODERATOR,
  USER,
}

class Participant extends Equatable {
  final String key;
  final Profile profile;
  // enum
  final ParticipantType type;

  Participant({
    @required this.key,
    @required this.profile,
    this.type = ParticipantType.USER,
  });

  Participant copyWith({
    String key,
    Profile profile,
    ParticipantType type,
  }) {
    return Participant(
      key: key ?? this.key,
      profile: profile ?? this.profile,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'profile': profile?.toMap(),
      'type': type?.index,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Participant(
      key: map['key'],
      profile: Profile.fromMap(map['profile']),
      type: ParticipantType.values[map['type']],
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) => Participant.fromMap(json.decode(source));

  @override
  String toString() => 'Participant(key: $key, profile: $profile, type: $type)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Participant &&
      o.key == key &&
      o.profile == profile &&
      o.type == type;
  }

  @override
  int get hashCode => key.hashCode ^ profile.hashCode ^ type.hashCode;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [key, profile, type];
}
