// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationUpdateRequest _$ConversationUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return ConversationUpdateRequest(
    action: json['_action'] as String,
    hash: json['hash'] as String,
    name: json['name'] as String,
    topic: json['topic'] as String,
  );
}

Map<String, dynamic> _$ConversationUpdateRequestToJson(
        ConversationUpdateRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'hash': instance.hash,
      'name': instance.name,
      'topic': instance.topic,
    };
