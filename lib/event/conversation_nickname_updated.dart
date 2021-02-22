import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';

class ConversationNicknameUpdated implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String cidS;
  ConversationNicknameUpdated({
    this.dataM,
    this.metadataM,
    this.cidS,
  });
  
  String type() {
    return ConversationNicknameUpdatedType;
  }

  ConversationNicknameUpdated copyWith({
    DataM dataM,
    MetadataM metadataM,
    String typeS,
    String cidS,
  }) {
    return ConversationNicknameUpdated(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      cidS: cidS ?? this.cidS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': ConversationNicknameUpdatedType,
      '_cid:s': cidS,
    };
  }

  factory ConversationNicknameUpdated.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversationNicknameUpdated(
      dataM: DataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      cidS: map['_cid:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationNicknameUpdated.fromJson(String source) => ConversationNicknameUpdated.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationNicknameUpdated(dataM: $dataM, metadataM: $metadataM, cidS: $cidS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversationNicknameUpdated &&
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
