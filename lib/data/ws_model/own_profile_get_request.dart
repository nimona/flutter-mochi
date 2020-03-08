import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'own_profile_get_request.g.dart';

@JsonSerializable()
class OwnProfileGetRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  OwnProfileGetRequest({
    this.action = "ownProfileGet",
  });

  factory OwnProfileGetRequest.fromJson(Map<String, dynamic> json) =>
      _$OwnProfileGetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OwnProfileGetRequestToJson(this);
}
