import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:flutterapp/model/profile.dart';

class LocalPeer extends Equatable {
  final String key;
  final Profile profile;
  LocalPeer({
    this.key,
    this.profile,
  });

  LocalPeer copyWith({
    String key,
    Profile profile,
  }) {
    return LocalPeer(
      key: key ?? this.key,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'profile': profile?.toMap(),
    };
  }

  factory LocalPeer.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return LocalPeer(
      key: map['key'],
      profile: Profile.fromMap(map['profile']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalPeer.fromJson(String source) => LocalPeer.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [key, profile];
}
