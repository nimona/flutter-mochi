import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversations_get_request.g.dart';

@JsonSerializable()
class ConversationsGetRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  ConversationsGetRequest({
    this.action = "conversationsGet",
  });

  factory ConversationsGetRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationsGetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationsGetRequestToJson(this);
}
