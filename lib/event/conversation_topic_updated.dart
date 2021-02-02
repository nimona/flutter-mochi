import 'dart:convert';

import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';

class ConversationTopicUpdated implements NimonaTyped {
  ConversationTopicUpdatedDataM dataM;
  MetadataM metadataM;
  String hashS;
  ConversationTopicUpdated({
    this.dataM,
    this.metadataM,
    this.hashS,
  });
  
  String type() {
    return ConversationTopicUpdatedType;
  }

  ConversationTopicUpdated copyWith({
    ConversationTopicUpdatedDataM dataM,
    MetadataM metadataM,
    String typeS,
    String hashS,
  }) {
    return ConversationTopicUpdated(
      dataM: dataM ?? this.dataM,
      metadataM: metadataM ?? this.metadataM,
      hashS: hashS ?? this.hashS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data:m': dataM?.toMap(),
      'metadata:m': metadataM?.toMap(),
      'type:s': ConversationTopicUpdatedType,
      '_hash:s': hashS,
    };
  }

  factory ConversationTopicUpdated.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversationTopicUpdated(
      dataM: ConversationTopicUpdatedDataM.fromMap(map['data:m']),
      metadataM: MetadataM.fromMap(map['metadata:m']),
      hashS: map['_hash:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationTopicUpdated.fromJson(String source) => ConversationTopicUpdated.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationTopicUpdated(dataM: $dataM, metadataM: $metadataM, hashS: $hashS)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversationTopicUpdated &&
      o.dataM == dataM &&
      o.metadataM == metadataM &&
      o.hashS == hashS;
  }

  @override
  int get hashCode {
    return dataM.hashCode ^
      metadataM.hashCode ^
      hashS.hashCode;
  }
}

class ConversationTopicUpdatedDataM {
  String topicS;
  ConversationTopicUpdatedDataM({
    this.topicS,
  });

  ConversationTopicUpdatedDataM copyWith({
    String topicS,
  }) {
    return ConversationTopicUpdatedDataM(
      topicS: topicS ?? this.topicS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic:s': topicS,
    };
  }

  factory ConversationTopicUpdatedDataM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversationTopicUpdatedDataM(
      topicS: map['topic:s'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationTopicUpdatedDataM.fromJson(String source) => ConversationTopicUpdatedDataM.fromMap(json.decode(source));

  @override
  String toString() => 'ConversationTopicUpdatedDataM(topicS: $topicS)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversationTopicUpdatedDataM &&
      o.topicS == topicS;
  }

  @override
  int get hashCode => topicS.hashCode;
}
