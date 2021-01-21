import 'dart:convert';

import 'package:flutter/foundation.dart';

class MetadataM {
  String ownerS;
  List<String> parentsAs;
  String streamS;
  MetadataM({
    this.ownerS,
    this.parentsAs,
    this.streamS,
  });

  MetadataM copyWith({
    String ownerS,
    List<String> parentsAs,
    String streamS,
  }) {
    return MetadataM(
      ownerS: ownerS ?? this.ownerS,
      parentsAs: parentsAs ?? this.parentsAs,
      streamS: streamS ?? this.streamS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'owner:s': ownerS,
      'parents:as': parentsAs,
      'stream:s': streamS,
    };
  }

  factory MetadataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MetadataM(
      ownerS: map['owner:s'],
      parentsAs: List<String>.from(map['parents:as']),
      streamS: map['stream:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MetadataM.fromJson(String source) => MetadataM.fromMap(json.decode(source));

  @override
  String toString() => 'MetadataM(ownerS: $ownerS, parentsAs: $parentsAs, streamS: $streamS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MetadataM &&
      o.ownerS == ownerS &&
      listEquals(o.parentsAs, parentsAs) &&
      o.streamS == streamS;
  }

  @override
  int get hashCode => ownerS.hashCode ^ parentsAs.hashCode ^ streamS.hashCode;
}
