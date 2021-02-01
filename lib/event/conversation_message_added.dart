import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';

final String objectType = 'poc.nimona.io/conversation.MessageAdded';

class ConversationMessageAdded implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String hashS;
  ConversationMessageAdded({
    this.dataM,
    this.metadataM,
    this.hashS,
  });

  String type() {
    return objectType;
  }

  ConversationMessageAdded copyWith({
    DataM dataM,
    MetadataM metadataM,
    String typeS,
    String hashS,
  }) {
    return ConversationMessageAdded(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      hashS: hashS ?? this.hashS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': objectType,
      '_hash:s': hashS,
    };
  }

  factory ConversationMessageAdded.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ConversationMessageAdded(
      dataM: DataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      hashS: map['_hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationMessageAdded.fromJson(String source) =>
      ConversationMessageAdded.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationMessageAdded(dataM: $dataM, metadataM: $metadataM, hashS: $hashS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ConversationMessageAdded &&
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
  String bodyS;
  String datetimeS;
  DataM({
    this.bodyS,
    this.datetimeS,
  });

  DataM copyWith({
    String bodyS,
    String datetimeS,
  }) {
    return DataM(
      bodyS: bodyS ?? this.bodyS,
      datetimeS: datetimeS ?? this.datetimeS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'body:s': bodyS,
      'datetime:s': datetimeS,
    };
  }

  factory DataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DataM(
      bodyS: map['body:s'],
      datetimeS: map['datetime:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataM.fromJson(String source) => DataM.fromMap(json.decode(source));

  @override
  String toString() => 'DataM(bodyS: $bodyS, datetimeS: $datetimeS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DataM && o.bodyS == bodyS && o.datetimeS == datetimeS;
  }

  @override
  int get hashCode => bodyS.hashCode ^ datetimeS.hashCode;
}
