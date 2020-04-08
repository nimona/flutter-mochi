import 'package:flutter/material.dart';
import 'package:mochi/data/wsdatastore.dart';

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
      var cb = "0";
      if (profileUpdated != null) {
        cb = profileUpdated.millisecondsSinceEpoch.toString();
      }
      img = NetworkImage(
        "$daemonApiHttpUrl$daemonApiPort/displayPictures/$profileKey?_cb=$cb&size=$size",
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
