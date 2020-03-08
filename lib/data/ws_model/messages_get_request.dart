import 'package:mochi/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'messages_get_request.g.dart';

@JsonSerializable()
class MessagesGetRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'conversationHash')
  String conversationHash;

  MessagesGetRequest({
    this.action = "messagesGet",
    this.conversationHash,
  });

  factory MessagesGetRequest.fromJson(Map<String, dynamic> json) =>
      _$MessagesGetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MessagesGetRequestToJson(this);
}
