import 'dart:convert';

import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';

ConnectionInfo connectionInfoFromJson(String str) =>
    ConnectionInfo.fromJson(json.decode(str));

String connectionInfoToJson(ConnectionInfo data) => json.encode(data.toJson());

class ConnectionInfo implements NimonaTyped {
  ConnectionInfo({
    this.hashS,
    this.dataM,
  });

  final String hashS;
  final ConnectionInfoDataM dataM;

  ConnectionInfo copyWith({
    String hashS,
    ConnectionInfoDataM dataM,
  }) =>
      ConnectionInfo(
        hashS: hashS ?? this.hashS,
        dataM: dataM ?? this.dataM,
      );

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) => ConnectionInfo(
        hashS: json['_hash:s'] == null ? null : json['_hash:s'],
        dataM: json['data:m'] == null
            ? null
            : ConnectionInfoDataM.fromJson(json['data:m']),
      );

  Map<String, dynamic> toJson() => {
        '_hash:s': hashS == null ? null : hashS,
        'data:m': dataM == null ? null : dataM.toJson(),
        'type:s': ConnectionInfoType,
      };

  String type() {
    return ConnectionInfoType;
  }
}

class ConnectionInfoDataM {
  ConnectionInfoDataM({
    this.addressesAs,
    this.objectFormatsAs,
    this.publicKeyS,
    this.relaysAo,
    this.versionI,
  });

  final List<String> addressesAs;
  final List<String> objectFormatsAs;
  final String publicKeyS;
  final List<RelaysAo> relaysAo;
  final int versionI;

  ConnectionInfoDataM copyWith({
    List<String> addressesAs,
    List<String> objectFormatsAs,
    String publicKeyS,
    List<RelaysAo> relaysAo,
    int versionI,
  }) =>
      ConnectionInfoDataM(
        addressesAs: addressesAs ?? this.addressesAs,
        objectFormatsAs: objectFormatsAs ?? this.objectFormatsAs,
        publicKeyS: publicKeyS ?? this.publicKeyS,
        relaysAo: relaysAo ?? this.relaysAo,
        versionI: versionI ?? this.versionI,
      );

  factory ConnectionInfoDataM.fromJson(Map<String, dynamic> json) =>
      ConnectionInfoDataM(
        addressesAs: json['addresses:as'] == null
            ? null
            : List<String>.from(json['addresses:as'].map((x) => x)),
        objectFormatsAs: json['objectFormats:as'] == null
            ? null
            : List<String>.from(json['objectFormats:as'].map((x) => x)),
        publicKeyS: json['publicKey:s'] == null ? null : json['publicKey:s'],
        relaysAo: json['relays:ao'] == null
            ? null
            : List<RelaysAo>.from(
                json['relays:ao'].map((x) => RelaysAo.fromJson(x))),
        versionI: json['version:i'] == null ? null : json['version:i'],
      );

  Map<String, dynamic> toJson() => {
        'addresses:as': addressesAs == null
            ? null
            : List<dynamic>.from(addressesAs.map((x) => x)),
        'objectFormats:as': objectFormatsAs == null
            ? null
            : List<dynamic>.from(objectFormatsAs.map((x) => x)),
        'publicKey:s': publicKeyS == null ? null : publicKeyS,
        'relays:ao': relaysAo == null
            ? null
            : List<dynamic>.from(relaysAo.map((x) => x.toJson())),
        'version:i': versionI == null ? null : versionI,
      };
}

class RelaysAo {
  RelaysAo({
    this.dataM,
    this.typeS,
  });

  final RelaysAoDataM dataM;
  final String typeS;

  RelaysAo copyWith({
    RelaysAoDataM dataM,
    String typeS,
  }) =>
      RelaysAo(
        dataM: dataM ?? this.dataM,
        typeS: typeS ?? this.typeS,
      );

  factory RelaysAo.fromJson(Map<String, dynamic> json) => RelaysAo(
        dataM: json['data:m'] == null
            ? null
            : RelaysAoDataM.fromJson(json['data:m']),
        typeS: json['type:s'] == null ? null : json['type:s'],
      );

  Map<String, dynamic> toJson() => {
        'data:m': dataM == null ? null : dataM.toJson(),
        'type:s': typeS == null ? null : typeS,
      };
}

class RelaysAoDataM {
  RelaysAoDataM({
    this.addressesAs,
    this.publicKeyS,
    this.versionI,
  });

  final List<String> addressesAs;
  final String publicKeyS;
  final int versionI;

  RelaysAoDataM copyWith({
    List<String> addressesAs,
    String publicKeyS,
    int versionI,
  }) =>
      RelaysAoDataM(
        addressesAs: addressesAs ?? this.addressesAs,
        publicKeyS: publicKeyS ?? this.publicKeyS,
        versionI: versionI ?? this.versionI,
      );

  factory RelaysAoDataM.fromJson(Map<String, dynamic> json) => RelaysAoDataM(
        addressesAs: json['addresses:as'] == null
            ? null
            : List<String>.from(json['addresses:as'].map((x) => x)),
        publicKeyS: json['publicKey:s'] == null ? null : json['publicKey:s'],
        versionI: json['version:i'] == null ? null : json['version:i'],
      );

  Map<String, dynamic> toJson() => {
        'addresses:as': addressesAs == null
            ? null
            : List<dynamic>.from(addressesAs.map((x) => x)),
        'publicKey:s': publicKeyS == null ? null : publicKeyS,
        'version:i': versionI == null ? null : versionI,
      };
}
