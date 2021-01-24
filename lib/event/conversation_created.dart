import 'dart:convert';

import 'package:flutterapp/event/nimona_medatada.dart';
import 'package:flutterapp/event/nimona_typed.dart';

class ConversationCreated implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String hashS;
  ConversationCreated({
    this.dataM,
    this.metadataM,
    this.hashS,
  });

  String type() {
    return 'stream:poc.nimona.io/conversation';
  }

  ConversationCreated copyWith({
    DataM dataM,
    MetadataM metadataM,
    String hashS,
  }) {
    return ConversationCreated(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      hashS: hashS ?? this.hashS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': 'stream:poc.nimona.io/conversation',
      '_hash:s': hashS,
    };
  }

  factory ConversationCreated.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationCreated(
      dataM: DataM.fromMap(map['data:m']),
      // FIX: this breaks if JSON has `"metadata:m":{}`.
      // metadataM: MetadataM.fromMap(map['metadata:m']),
      hashS: map['_hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationCreated.fromJson(String source) =>
      ConversationCreated.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationCreated(dataM: $dataM, metadataM: $metadataM, hashS: $hashS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ConversationCreated &&
        o.dataM == dataM &&
        o.metadataM == metadataM &&
        o.hashS == hashS;
  }

  @override
  int get hashCode {
    return dataM.hashCode ^ metadataM.hashCode ^ hashS.hashCode;
  }
}

class DataM {
  String nonceS;
  DataM({
    this.nonceS,
  });

  DataM copyWith({
    String nonceS,
  }) {
    return DataM(
      nonceS: nonceS ?? this.nonceS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nonce:s': nonceS,
    };
  }

  factory DataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DataM(
      nonceS: map['nonce:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataM.fromJson(String source) => DataM.fromMap(json.decode(source));

  @override
  String toString() => 'DataM(nonceS: $nonceS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DataM && o.nonceS == nonceS;
  }

  @override
  int get hashCode => nonceS.hashCode;
}
