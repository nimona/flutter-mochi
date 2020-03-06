import 'package:flutterapp/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contacts_get_request.g.dart';

@JsonSerializable()
class ContactsGetRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  ContactsGetRequest({
    this.action = "contactsGet",
  });

  factory ContactsGetRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactsGetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsGetRequestToJson(this);
}
