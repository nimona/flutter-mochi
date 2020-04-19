import 'package:json_annotation/json_annotation.dart';
import 'package:mochi/data/ws_model/base_request.dart';

part 'identity_load_request.g.dart';

@JsonSerializable()
class IdentityLoadRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'mnemonic')
  String mnemonic;

  IdentityLoadRequest({
    this.action = "identityLoad",
    this.mnemonic,
  }) : super();

  factory IdentityLoadRequest.fromJson(Map<String, dynamic> json) =>
      _$IdentityLoadRequestFromJson(json);
  Map<String, dynamic> toJson() => _$IdentityLoadRequestToJson(this);
}
