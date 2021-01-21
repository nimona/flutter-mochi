import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutterapp/event/nimona_medatada.dart';
import 'package:flutterapp/event/nimona_typed.dart';

class ConversationSubscription implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String typeS;
  String hashS;
  ConversationSubscription({
    this.dataM,
    this.metadataM,
    this.typeS,
    this.hashS,
  });

  String type() {
    return this.typeS;
  }

  ConversationSubscription copyWith({
    DataM dataM,
    MetadataM metadataM,
    String typeS,
    String hashS,
  }) {
    return ConversationSubscription(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      typeS: typeS ?? this.typeS,
      hashS: hashS ?? this.hashS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': typeS,
      'hash:s': hashS,
    };
  }

  factory ConversationSubscription.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversationSubscription(
      dataM: DataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      typeS: map['type:s'],
      hashS: map['hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationSubscription.fromJson(String source) => ConversationSubscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationSubscription(dataM: $dataM, metadataM: $metadataM, typeS: $typeS, hashS: $hashS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversationSubscription &&
      o.dataM == dataM &&
      o.metadataM == metadataM &&
      o.typeS == typeS &&
      o.hashS == hashS;
  }

  @override
  int get hashCode {
    return dataM.hashCode ^
      metadataM.hashCode ^
      typeS.hashCode ^
      hashS.hashCode;
  }
}

class DataM {
  String expiryS;
  List<String> rootHashesAr;
  DataM({
    this.expiryS,
    this.rootHashesAr,
  });

  DataM copyWith({
    String expiryS,
    List<String> rootHashesAr,
  }) {
    return DataM(
      expiryS: expiryS ?? this.expiryS,
      rootHashesAr: rootHashesAr ?? this.rootHashesAr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'expiry:s': expiryS,
      'rootHashesAr': rootHashesAr,
    };
  }

  factory DataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DataM(
      expiryS: map['expiry:s'],
      rootHashesAr: List<String>.from(map['rootHashesAr']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DataM.fromJson(String source) => DataM.fromMap(json.decode(source));

  @override
  String toString() => 'DataM(expiryS: $expiryS, rootHashesAr: $rootHashesAr)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DataM &&
      o.expiryS == expiryS &&
      listEquals(o.rootHashesAr, rootHashesAr);
  }

  @override
  int get hashCode => expiryS.hashCode ^ rootHashesAr.hashCode;
}
