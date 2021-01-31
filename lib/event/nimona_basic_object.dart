import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';

class BasicObject implements NimonaTyped {
  MetadataM metadataM;
  String typeS;
  String hashS;
  BasicObject({
    this.metadataM,
    this.typeS,
    this.hashS,
  });

  String type() {
    return this.typeS;
  }

  BasicObject copyWith({
    MetadataM metadataM,
    String typeS,
    String hashS,
  }) {
    return BasicObject(
      metadataM: metadataM ?? this.metadataM,
      typeS: typeS ?? this.typeS,
      hashS: hashS ?? this.hashS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'metadata:m': metadataM?.toMap(),
      'type:s': typeS,
      'hash:s': hashS,
    };
  }

  factory BasicObject.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return BasicObject(
      metadataM: MetadataM.fromMap(map['metadata:m']),
      typeS: map['type:s'],
      hashS: map['hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicObject.fromJson(String source) => BasicObject.fromMap(json.decode(source));

  @override
  String toString() => 'BasicObject(metadataM: $metadataM, typeS: $typeS, hashS: $hashS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is BasicObject &&
      o.metadataM == metadataM &&
      o.typeS == typeS &&
      o.hashS == hashS;
  }

  @override
  int get hashCode => metadataM.hashCode ^ typeS.hashCode ^ hashS.hashCode;
}
