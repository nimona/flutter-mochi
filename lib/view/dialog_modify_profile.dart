import 'package:flutter/material.dart';

class UpdateOwnProfileDialog extends StatelessWidget {
  const UpdateOwnProfileDialog({
    Key key,
    @required this.nameFirstController,
    @required this.nameLastController,
  }) : super(key: key);

  final TextEditingController nameFirstController;
  final TextEditingController nameLastController;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dialogContentWidth = width * 0.8;
    return new AlertDialog(
      title: Text('Update profile info'),
      contentPadding: const EdgeInsets.all(24.0),
      content: new Container(
          width: dialogContentWidth,
          child: new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new TextField(
                  controller: nameFirstController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'First name',
                    hintText: 'John',
                  ),
                ),
                new TextField(
                  controller: nameLastController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Last name',
                    hintText: 'Doe',
                  ),
                )
              ],
            ),
          )),
      actions: <Widget>[
        new FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        new FlatButton(
            child: const Text('UPDATE'),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    );
  }
}
