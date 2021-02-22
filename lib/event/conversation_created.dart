import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';

class ConversationCreated implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String cidS;
  ConversationCreated({
    this.dataM,
    this.metadataM,
    this.cidS,
  });

  String type() {
    return ConversationCreatedType;
  }

  ConversationCreated copyWith({
    DataM dataM,
    MetadataM metadataM,
    String cidS,
  }) {
    return ConversationCreated(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      cidS: cidS ?? this.cidS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': ConversationCreatedType,
      '_cid:s': cidS,
    };
  }

  factory ConversationCreated.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationCreated(
      dataM: DataM.fromMap(map['data:m']),
      // FIX: this breaks if JSON has `"metadata:m":{}`.
      // metadataM: MetadataM.fromMap(map['metadata:m']),
      cidS: map['_cid:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationCreated.fromJson(String source) =>
      ConversationCreated.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationCreated(dataM: $dataM, metadataM: $metadataM, cidS: $cidS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ConversationCreated &&
        o.dataM == dataM &&
        o.metadataM == metadataM &&
        o.cidS == cidS;
  }

  @override
  int get hashCode {
    return dataM.hashCode ^ metadataM.hashCode ^ cidS.hashCode;
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
