import 'package:flutterapp/event/nimona_medatada.dart';
import 'package:flutterapp/event/nimona_typed.dart';

class ConversationMessageAdded implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String typeS;

  ConversationMessageAdded({this.dataM, this.metadataM, this.typeS});

  ConversationMessageAdded.fromJson(Map<String, dynamic> json) {
    dataM = json['data:m'] != null ? new DataM.fromJson(json['data:m']) : null;
    metadataM = json['metadata:m'] != null
        ? new MetadataM.fromJson(json['metadata:m'])
        : null;
    typeS = json['type:s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataM != null) {
      data['data:m'] = this.dataM.toJson();
    }
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

class DataM {
  String bodyS;
  String datetimeS;

  DataM({this.bodyS, this.datetimeS});

  DataM.fromJson(Map<String, dynamic> json) {
    bodyS = json['body:s'];
    datetimeS = json['datetime:s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body:s'] = this.bodyS;
    data['datetime:s'] = this.datetimeS;
    return data;
  }
}
