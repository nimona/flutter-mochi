import 'package:mochi/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'own_profile_update_request.g.dart';

@JsonSerializable()
class OwnProfileUpdateRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'nameFirst')
  String nameFirst;

  @JsonKey(name: 'nameLast')
  String nameLast;

  @JsonKey(name: 'displayPicture')
  String displayPicture;

  OwnProfileUpdateRequest({
    this.action = "ownProfileUpdate",
    this.nameFirst,
    this.nameLast,
    this.displayPicture,
  }) : super();

  factory OwnProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$OwnProfileUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OwnProfileUpdateRequestToJson(this);
}
