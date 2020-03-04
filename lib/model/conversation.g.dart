// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation(
    hash: json['hash'] as String,
    name: json['name'] as String,
    topic: json['topic'] as String,
    displayPicture: json['displayPicture'] as String,
    lastMessage: json['lastMessage'] == null
        ? null
        : DateTime.parse(json['lastMessage'] as String),
    unreadMessagesCount: json['unreadMessagesCount'] as int,
    unreadMessagesLatest: (json['unreadMessagesLatest'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'name': instance.name,
      'topic': instance.topic,
      'displayPicture': instance.displayPicture,
      'lastMessage': instance.lastMessage?.toIso8601String(),
      'unreadMessagesCount': instance.unreadMessagesCount,
      'unreadMessagesLatest': instance.unreadMessagesLatest,
    };
