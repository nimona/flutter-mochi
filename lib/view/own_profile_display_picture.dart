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
      img = NetworkImage(
        "http://localhost:10100/displayPictures/" +
            profile.key +
            "?_cb=" +
            profile.updated.millisecondsSinceEpoch.toString() +
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
            borderRadius: BorderRadius.circular(3),
            // borderRadius: BorderRadius.circular(size.toDouble()),
          ),
        ),
      ),
    );
  }
}
