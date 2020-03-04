// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_get_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesGetRequest _$MessagesGetRequestFromJson(Map<String, dynamic> json) {
  return MessagesGetRequest(
    action: json['_action'] as String,
    conversationHash: json['conversationHash'] as String,
  );
}

Map<String, dynamic> _$MessagesGetRequestToJson(MessagesGetRequest instance) =>
    <String, dynamic>{
      '_action': instance.action,
      'conversationHash': instance.conversationHash,
    };
