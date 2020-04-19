import 'package:json_annotation/json_annotation.dart';
import 'package:mochi/data/ws_model/base_request.dart';

part 'daemon_info_response.g.dart';

@JsonSerializable()
class DaemonInfoResponse extends BaseRequest {
  @JsonKey(name: 'addresses')
  List<String> addresses;

  @JsonKey(name: 'peerPublicKey')
  String peerPublicKey;

  @JsonKey(name: 'peerPrivateKey')
  String peerPrivateKey;

  @JsonKey(name: 'identityPublicKey')
  String identityPublicKey;

  @JsonKey(name: 'identityPrivateKey')
  String identityPrivateKey;

  @JsonKey(name: 'identitySecretPhrase')
  List<String> identitySecretPhrase;

  DaemonInfoResponse({
    this.addresses,
    this.peerPublicKey,
    this.peerPrivateKey,
    this.identityPublicKey,
    this.identityPrivateKey,
    this.identitySecretPhrase,
  }) : super();

  factory DaemonInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$DaemonInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DaemonInfoResponseToJson(this);
}
