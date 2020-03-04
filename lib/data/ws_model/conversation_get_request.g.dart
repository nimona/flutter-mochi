// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_get_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationGetRequest _$ConversationGetRequestFromJson(
    Map<String, dynamic> json) {
  return ConversationGetRequest(
    action: json['_action'] as String,
    conversationHash: json['conversationHash'] as String,
  );
}

Map<String, dynamic> _$ConversationGetRequestToJson(
        ConversationGetRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'conversationHash': instance.conversationHash,
    };
