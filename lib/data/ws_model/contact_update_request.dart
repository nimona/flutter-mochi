import 'package:mochi/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_update_request.g.dart';

@JsonSerializable()
class ContactUpdateRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'alias')
  String alias;

  @JsonKey(name: 'identityKey')
  String identityKey;

  ContactUpdateRequest({
    this.action = "contactUpdate",
    this.alias,
    this.identityKey,
  });

  factory ContactUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ContactUpdateRequestToJson(this);
}
