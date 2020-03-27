import 'package:flutter/material.dart';
import 'package:mochi/model/conversation.dart';

class ConversationDisplayPicture extends StatelessWidget {
  const ConversationDisplayPicture({
    Key key,
    @required this.conversation,
    this.image,
    @required this.size,
  }) : super(key: key);

  final Conversation conversation;
  final ImageProvider image;
  final int size;

  @override
  Widget build(BuildContext context) {
    ImageProvider img = image;
    if (img == null) {
      var cb = "0";
      if (conversation.updated != null) {
        cb = conversation.updated.millisecondsSinceEpoch.toString();
      }
      var hash = conversation.hash;
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
