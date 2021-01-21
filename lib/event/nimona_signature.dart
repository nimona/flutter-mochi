class SignatureM {
  String algS;
  String signerS;
  String xD;

  SignatureM({this.algS, this.signerS, this.xD});

  SignatureM.fromJson(Map<String, dynamic> json) {
    algS = json['alg:s'];
    signerS = json['signer:s'];
    xD = json['x:d'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alg:s'] = this.algS;
    data['signer:s'] = this.signerS;
    data['x:d'] = this.xD;
    return data;
  }
}
