import 'dart:convert';

import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String key;
  final String nameFirst;
  final String nameLast;
  final String localAlias;
  final String displayPicture;
  Profile({
    this.key,
    this.nameFirst,
    this.nameLast,
    this.localAlias,
    this.displayPicture,
  });

  Profile copyWith({
    String key,
    String nameFirst,
    String nameLast,
    String localAlias,
    String displayPicture,
  }) {
    return Profile(
      key: key ?? this.key,
      nameFirst: nameFirst ?? this.nameFirst,
      nameLast: nameLast ?? this.nameLast,
      localAlias: localAlias ?? this.localAlias,
      displayPicture: displayPicture ?? this.displayPicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'nameFirst': nameFirst,
      'nameLast': nameLast,
      'localAlias': localAlias,
      'displayPicture': displayPicture,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Profile(
      key: map['key'],
      nameFirst: map['nameFirst'],
      nameLast: map['nameLast'],
      localAlias: map['localAlias'],
      displayPicture: map['displayPicture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      key,
      nameFirst,
      nameLast,
      localAlias,
      displayPicture,
    ];
  }
}
