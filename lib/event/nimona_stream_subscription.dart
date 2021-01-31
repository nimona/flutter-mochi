import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';

class StreamSubscription implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String hashS;
  StreamSubscription({
    this.dataM,
    this.metadataM,
    this.hashS,
  });

  String type() {
    return 'nimona.io/stream.Subscription';
  }

  StreamSubscription copyWith({
    DataM dataM,
    MetadataM metadataM,
    String typeS,
    String hashS,
  }) {
    return StreamSubscription(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      hashS: hashS ?? this.hashS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': type(),
      'hash:s': hashS,
    };
  }

  factory StreamSubscription.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return StreamSubscription(
      dataM: DataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      hashS: map['hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamSubscription.fromJson(String source) => StreamSubscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StreamSubscription(dataM: $dataM, metadataM: $metadataM, hashS: $hashS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is StreamSubscription &&
      o.dataM == dataM &&
      o.metadataM == metadataM &&
      o.hashS == hashS;
  }

  @override
  int get hashCode {
    return dataM.hashCode ^
      metadataM.hashCode ^
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
