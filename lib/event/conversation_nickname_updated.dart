import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';

class ConversationNicknameUpdated implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String typeS;
  String hashS;
  ConversationNicknameUpdated({
    this.dataM,
    this.metadataM,
    this.typeS,
    this.hashS,
  });
  
  String type() {
    return this.typeS;
  }

  ConversationNicknameUpdated copyWith({
    DataM dataM,
    MetadataM metadataM,
    String typeS,
    String hashS,
  }) {
    return ConversationNicknameUpdated(
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

  factory ConversationNicknameUpdated.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversationNicknameUpdated(
      dataM: DataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      typeS: map['type:s'],
      hashS: map['hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationNicknameUpdated.fromJson(String source) => ConversationNicknameUpdated.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationNicknameUpdated(dataM: $dataM, metadataM: $metadataM, typeS: $typeS, hashS: $hashS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversationNicknameUpdated &&
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
  String datetimeS;
  String nicknameS;
  DataM({
    this.datetimeS,
    this.nicknameS,
  });

  DataM copyWith({
    String datetimeS,
    String nicknameS,
  }) {
    return DataM(
      datetimeS: datetimeS ?? this.datetimeS,
      nicknameS: nicknameS ?? this.nicknameS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime:s': datetimeS,
      'nickname:s': nicknameS,
    };
  }

  factory DataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DataM(
      datetimeS: map['datetime:s'],
      nicknameS: map['nickname:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataM.fromJson(String source) => DataM.fromMap(json.decode(source));

  @override
  String toString() => 'DataM(datetimeS: $datetimeS, nicknameS: $nicknameS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DataM &&
      o.datetimeS == datetimeS &&
      o.nicknameS == nicknameS;
  }

  @override
  int get hashCode => datetimeS.hashCode ^ nicknameS.hashCode;
}
