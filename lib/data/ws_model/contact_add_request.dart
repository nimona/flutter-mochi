import 'package:mochi/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_add_request.g.dart';

@JsonSerializable()
class ContactAddRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'alias')
  String alias;

  @JsonKey(name: 'identityKey')
  String identityKey;

  ContactAddRequest({
    this.action = "contactAdd",
    this.alias,
    this.identityKey,
  });

  factory ContactAddRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactAddRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ContactAddRequestToJson(this);
}
