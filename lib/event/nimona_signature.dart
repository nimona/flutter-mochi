import 'dart:convert';

class SignatureM {
  String algS;
  String signerS;
  String xD;
  SignatureM({
    this.algS,
    this.signerS,
    this.xD,
  });

  SignatureM copyWith({
    String algS,
    String signerS,
    String xD,
  }) {
    return SignatureM(
      algS: algS ?? this.algS,
      signerS: signerS ?? this.signerS,
      xD: xD ?? this.xD,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alg:s': algS,
      'signer:s': signerS,
      'x:d': xD,
    };
  }

  factory SignatureM.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SignatureM(
      algS: map['alg:s'],
      signerS: map['signer:s'],
      xD: map['x:d'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignatureM.fromJson(String source) => SignatureM.fromMap(json.decode(source));

  @override
  String toString() => 'SignatureM(algS: $algS, signerS: $signerS, xD: $xD)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SignatureM &&
      o.algS == algS &&
      o.signerS == signerS &&
      o.xD == xD;
  }

  @override
  int get hashCode => algS.hashCode ^ signerS.hashCode ^ xD.hashCode;
}
