import 'package:flutter/material.dart';

class UpdateConversationDialog extends StatelessWidget {
  const UpdateConversationDialog({
    Key key,
    @required this.nameController,
    @required this.topicController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController topicController;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dialogContentWidth = width * 0.8;
    return new AlertDialog(
      title: Text('Update conversation'),
      contentPadding: const EdgeInsets.all(24.0),
      content: new Container(
        width: dialogContentWidth,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextField(
              controller: nameController,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Conversation name',
                  hintText: 'eg. Worse than random'),
            ),
            new TextField(
              controller: topicController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'Topic',
                hintText: 'eg. typewriters',
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        new FlatButton(
          child: const Text('UPDATE'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}
