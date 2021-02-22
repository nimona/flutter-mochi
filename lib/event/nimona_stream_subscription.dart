import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';

class StreamSubscription implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String cidS;
  StreamSubscription({
    this.dataM,
    this.metadataM,
    this.cidS,
  });

  String type() {
    return StreamSubscriptionType;
  }

  StreamSubscription copyWith({
    DataM dataM,
    MetadataM metadataM,
    String typeS,
    String cidS,
  }) {
    return StreamSubscription(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      cidS: cidS ?? this.cidS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': StreamSubscriptionType,
      '_cid:s': cidS,
    };
  }

  factory StreamSubscription.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return StreamSubscription(
      dataM: DataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      cidS: map['_cid:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamSubscription.fromJson(String source) => StreamSubscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StreamSubscription(dataM: $dataM, metadataM: $metadataM, cidS: $cidS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is StreamSubscription &&
      o.dataM == dataM &&
      o.metadataM == metadataM &&
      o.cidS == cidS;
  }

  @override
  int get hashCode {
    return dataM.hashCode ^
      metadataM.hashCode ^
      cidS.hashCode;
  }
}

class DataM {
  String expiryS;
  DataM({
    this.expiryS,
  });

  DataM copyWith({
    String expiryS,
  }) {
    return DataM(
      expiryS: expiryS ?? this.expiryS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'expiry:s': expiryS,
    };
  }

  factory DataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DataM(
      expiryS: map['expiry:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataM.fromJson(String source) => DataM.fromMap(json.decode(source));

  @override
  String toString() => 'DataM(expiryS: $expiryS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DataM &&
      o.expiryS == expiryS;
  }

  @override
  int get hashCode => expiryS.hashCode;
}
