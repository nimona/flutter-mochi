import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_get_request.g.dart';

@JsonSerializable()
class ConversationGetRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'conversationHash')
  String conversationHash;

  ConversationGetRequest({
    this.action = "conversationGet",
    this.conversationHash,
  });

  factory ConversationGetRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationGetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationGetRequestToJson(this);
}
