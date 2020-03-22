import 'package:flutter/material.dart';

class CreateContactDialog extends StatelessWidget {
  const CreateContactDialog({
    Key key,
    @required this.aliasController,
    @required this.publicKeyController,
    @required this.updateContact,
  }) : super(key: key);

  final bool updateContact;

  final TextEditingController aliasController;
  final TextEditingController publicKeyController;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dialogContentWidth = width * 0.8;
    return new AlertDialog(
      title: () {
        if (updateContact) {
          return new Text('Update contact');
        }
        return new Text('Add new contact');
      }(),
      contentPadding: const EdgeInsets.all(24.0),
      content: new Container(
        width: dialogContentWidth,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextField(
              controller: aliasController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'Contact name',
                hintText: 'eg. shivam',
              ),
            ),
            new TextField(
              controller: publicKeyController,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'Public key',
                hintText: 'usually starts with ed25519',
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
            }),
        new FlatButton(child: () {
          if (updateContact) {
            return new Text('UPDATE');
          }
          return new Text('ADD');
        }(), onPressed: () {
          Navigator.pop(context, true);
        })
      ],
    );
  }
}
