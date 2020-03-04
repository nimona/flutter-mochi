// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_start_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationStartRequest _$ConversationStartRequestFromJson(
    Map<String, dynamic> json) {
  return ConversationStartRequest(
    action: json['_action'] as String,
    name: json['name'] as String,
    topic: json['topic'] as String,
  );
}

Map<String, dynamic> _$ConversationStartRequestToJson(
        ConversationStartRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'name': instance.name,
      'topic': instance.topic,
    };
