import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_start_request.g.dart';

@JsonSerializable()
class ConversationStartRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'topic')
  String topic;

  ConversationStartRequest({
    this.action = "conversationStart",
    this.name,
    this.topic,
  });

  factory ConversationStartRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationStartRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationStartRequestToJson(this);
}
