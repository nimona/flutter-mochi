import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';

class BasicObject implements NimonaTyped {
  MetadataM metadataM;
  String typeS;
  String cidS;
  BasicObject({
    this.metadataM,
    this.typeS,
    this.cidS,
  });

  String type() {
    return this.typeS;
  }

  BasicObject copyWith({
    MetadataM metadataM,
    String typeS,
    String cidS,
  }) {
    return BasicObject(
      metadataM: metadataM ?? this.metadataM,
      typeS: typeS ?? this.typeS,
      cidS: cidS ?? this.cidS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'metadata:m': metadataM?.toMap(),
      'type:s': typeS,
      '_cid:s': cidS,
    };
  }

  factory BasicObject.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return BasicObject(
      metadataM: MetadataM.fromMap(map['metadata:m']),
      typeS: map['type:s'],
      cidS: map['_cid:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BasicObject.fromJson(String source) => BasicObject.fromMap(json.decode(source));

  @override
  String toString() => 'BasicObject(metadataM: $metadataM, typeS: $typeS, cidS: $cidS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is BasicObject &&
      o.metadataM == metadataM &&
      o.typeS == typeS &&
      o.cidS == cidS;
  }

  @override
  int get hashCode => metadataM.hashCode ^ typeS.hashCode ^ cidS.hashCode;
}
