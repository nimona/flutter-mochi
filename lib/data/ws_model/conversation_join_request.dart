import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_join_request.g.dart';

@JsonSerializable()
class ConversationJoinRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'conversationHash')
  String conversationHash;

  ConversationJoinRequest({
    this.action = "conversationJoin",
    this.conversationHash,
  });

  factory ConversationJoinRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationJoinRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationJoinRequestToJson(this);
}
