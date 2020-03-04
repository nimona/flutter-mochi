// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_join_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationJoinRequest _$ConversationJoinRequestFromJson(
    Map<String, dynamic> json) {
  return ConversationJoinRequest(
    action: json['_action'] as String,
    conversationHash: json['conversationHash'] as String,
  );
}

Map<String, dynamic> _$ConversationJoinRequestToJson(
        ConversationJoinRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'conversationHash': instance.conversationHash,
    };
