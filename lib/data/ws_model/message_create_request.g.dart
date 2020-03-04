// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCreateRequest _$MessageCreateRequestFromJson(Map<String, dynamic> json) {
  return MessageCreateRequest(
    action: json['_action'] as String,
    conversationHash: json['conversationHash'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$MessageCreateRequestToJson(
        MessageCreateRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'conversationHash': instance.conversationHash,
      'body': instance.body,
    };
