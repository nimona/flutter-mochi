import 'package:flutter/material.dart';
import 'package:flutterapp/model/profile.dart';

class Contact {
  final String key;
  final Profile profile;
  final String localAlias;

  Contact({
    @required this.key,
    @required this.profile,
    @required this.localAlias,
  });
}