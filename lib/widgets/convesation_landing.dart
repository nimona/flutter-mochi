import 'package:flutter/material.dart';

class ConversationLanding extends StatelessWidget {
  ConversationLanding(this.title, this.message, {Key key}) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
            ),
            Text(
              message,
            ),
          ],
        ),
      ),
    );
  }
}
