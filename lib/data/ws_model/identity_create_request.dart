import 'package:json_annotation/json_annotation.dart';
import 'package:mochi/data/ws_model/base_request.dart';

part 'identity_create_request.g.dart';

@JsonSerializable()
class IdentityCreateRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'nameFirst')
  String nameFirst;

  @JsonKey(name: 'nameLast')
  String nameLast;

  @JsonKey(name: 'displayPicture')
  String displayPicture;

  IdentityCreateRequest({
    this.action = "identityCreate",
    this.nameFirst,
    this.nameLast,
    this.displayPicture,
  }) : super();

  factory IdentityCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$IdentityCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$IdentityCreateRequestToJson(this);
}
