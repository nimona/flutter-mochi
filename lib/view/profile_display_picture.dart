import 'package:flutter/material.dart';
import 'package:mochi/model/profile.dart';

class ProfileDisplayPicture extends StatelessWidget {
  const ProfileDisplayPicture({
    Key key,
    @required this.profile,
    this.image,
    this.size,
  }) : super(key: key);

  final Profile profile;
  final ImageProvider image;
  final double size;

  @override
  Widget build(BuildContext context) {
    ImageProvider img = image;
    if (img == null) {
      img = NetworkImage(
        "http://localhost:10100/displayPictures/" +
            profile.key +
            "?_cb=" +
            profile.updated.toString(),
      );
    }
    return Container(
      width: size ?? 40,
      height: size ?? 40,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: FractionalOffset.topCenter,
              image: img,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
