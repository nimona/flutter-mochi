class MetadataM {
  String ownerS;
  List<String> parentsAs;
  String streamS;

  MetadataM({this.ownerS, this.parentsAs, this.streamS});

  MetadataM.fromJson(Map<String, dynamic> json) {
    ownerS = json['owner:s'];
    parentsAs = json['parents:as'].cast<String>();
    streamS = json['stream:s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner:s'] = this.ownerS;
    data['parents:as'] = this.parentsAs;
    data['stream:s'] = this.streamS;
    return data;
  }
}
