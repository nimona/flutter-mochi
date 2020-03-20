import 'package:flutter/material.dart';

class JoinConversationDialog extends StatelessWidget {
  const JoinConversationDialog({
    Key key,
    @required this.hashController,
  }) : super(key: key);

  final TextEditingController hashController;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dialogContentWidth = width * 0.8;
    return new AlertDialog(
      title: Text('Join a new conversation'),
      contentPadding: const EdgeInsets.all(24.0),
      content: new Container(
        width: dialogContentWidth,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextField(
              controller: hashController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'Conversation stream id',
                hintText: 'should start with oh.',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        new FlatButton(
            child: const Text('JOIN'),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    );
  }
}
