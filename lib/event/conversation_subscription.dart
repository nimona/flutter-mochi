import 'package:flutterapp/event/nimona_medatada.dart';
import 'package:flutterapp/event/nimona_typed.dart';

class ConversationSubscription implements NimonaTyped {
  DataM dataM;
  MetadataM metadataM;
  String typeS;

  ConversationSubscription({this.dataM, this.metadataM, this.typeS});

  ConversationSubscription.fromJson(Map<String, dynamic> json) {
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
  String expiryS;
  List<String> rootHashesAr;

  DataM({this.expiryS, this.rootHashesAr});

  DataM.fromJson(Map<String, dynamic> json) {
    expiryS = json['expiry:s'];
    rootHashesAr = json['rootHashes:ar'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry:s'] = this.expiryS;
    data['rootHashes:ar'] = this.rootHashesAr;
    return data;
  }
}
