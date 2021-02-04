import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: new BoxDecoration(
                color: Colors.pink.shade50.withAlpha(75),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.pink.shade50.withAlpha(100),),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.courierPrime().fontFamily,
                    color: Colors.pink.shade200,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
