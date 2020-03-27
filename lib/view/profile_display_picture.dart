import 'package:flutter/material.dart';

class ProfileDisplayPicture extends StatelessWidget {
  const ProfileDisplayPicture({
    Key key,
    @required this.profileKey,
    @required this.profileUpdated,
    this.image,
    @required this.size,
  }) : super(key: key);

  final String profileKey;
  final DateTime profileUpdated;
  final ImageProvider image;
  final int size;

  @override
  Widget build(BuildContext context) {
    ImageProvider img = image;
    if (img == null) {
      img = NetworkImage(
        "http://localhost:10100/displayPictures/" +
            profileKey +
            "?_cb=" +
            profileUpdated.millisecondsSinceEpoch.toString() +
            "&size=" +
            size.toString(),
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
