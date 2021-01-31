import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:mochi/model/profile.dart';

class Contact extends Equatable {
  final String key;
  final Profile profile;
  final String localAlias;
  Contact({
    this.key,
    this.profile,
    this.localAlias,
  });

  Contact copyWith({
    String key,
    Profile profile,
    String localAlias,
  }) {
    return Contact(
      key: key ?? this.key,
      profile: profile ?? this.profile,
      localAlias: localAlias ?? this.localAlias,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'profile': profile?.toMap(),
      'localAlias': localAlias,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Contact(
      key: map['key'],
      profile: Profile.fromMap(map['profile']),
      localAlias: map['localAlias'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) => Contact.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [key, profile, localAlias];
}
