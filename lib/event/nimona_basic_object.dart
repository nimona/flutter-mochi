import 'package:flutterapp/event/nimona_medatada.dart';
import 'package:flutterapp/event/nimona_typed.dart';

class BasicObject implements NimonaTyped {
  MetadataM metadataM;
  String typeS;

  BasicObject({this.metadataM, this.typeS});

  BasicObject.fromJson(Map<String, dynamic> json) {
    metadataM = json['metadata:m'] != null
        ? new MetadataM.fromJson(json['metadata:m'])
        : null;
    typeS = json['type:s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metadataM != null) {
      data['metadata:m'] = this.metadataM.toJson();
    }
    data['type:s'] = this.typeS;
    return data;
  }

  String type() {
    return this.typeS;
  }
}
