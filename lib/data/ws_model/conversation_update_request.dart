import 'package:mochi/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_update_request.g.dart';

@JsonSerializable()
class ConversationUpdateRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'hash')
  String hash;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'topic')
  String topic;

  ConversationUpdateRequest({
    this.action = "conversationUpdate",
    this.hash,
    this.name,
    this.topic,
  });

  factory ConversationUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationUpdateRequestToJson(this);
}
