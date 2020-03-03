import 'package:flutter/material.dart';
import 'package:flutterapp/model/profile.dart';

class LocalPeer {
  final String key;
  final Profile profile;

  LocalPeer({
    @required this.key,
    @required this.profile,
  });
}