import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_create_request.g.dart';

@JsonSerializable()
class MessageCreateRequest extends BaseRequest {

  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'conversationHash')
  String conversationHash;

  @JsonKey(name: 'body')
  String body;

  MessageCreateRequest({
    this.action = "messageCreate",
    this.conversationHash,
    this.body,
  });

  factory MessageCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$MessageCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MessageCreateRequestToJson(this);
}
