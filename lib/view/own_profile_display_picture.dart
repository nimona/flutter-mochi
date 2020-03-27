import 'package:flutter/material.dart';
import 'package:mochi/model/own_profile.dart';

class OwnProfileDisplayPicture extends StatelessWidget {
  const OwnProfileDisplayPicture({
    Key key,
    @required this.profile,
    this.image,
    @required this.size,
  }) : super(key: key);

  final OwnProfile profile;
  final ImageProvider image;
  final int size;

  @override
  Widget build(BuildContext context) {
    ImageProvider img = image;
    if (img == null) {
      var cb = "0";
      if (profile.updated != null) {
        cb = profile.updated.millisecondsSinceEpoch.toString();
      }
      var hash = profile.key;
      img = NetworkImage(
        "http://localhost:10100/displayPictures/$hash?_cb=$cb&size=$size",
      );
    }
    return Container(
      width: size.toDouble(),
      height: size.toDouble(),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: FractionalOffset.topCenter,
              image: img,
            ),
            borderRadius: BorderRadius.circular(
              size.toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}
