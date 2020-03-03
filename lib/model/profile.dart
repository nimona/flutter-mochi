import 'package:flutter/material.dart';

class Profile {
  final String key;
  final String nameFirst;
  final String nameLast;
  final String localAlias;
  final String displayPicture;

  Profile({
    @required this.key,
    this.nameFirst = "",
    this.nameLast = "",
    this.localAlias = "",
    this.displayPicture,
  });
}