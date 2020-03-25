import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mochi/model/own_profile.dart';
import 'package:mochi/view/own_profile_display_picture.dart';

class UpdateOwnProfileDialog extends StatefulWidget {
  const UpdateOwnProfileDialog({
    Key key,
    @required this.profile,
    @required this.callback,
  }) : super(key: key);

  final OwnProfile profile;
  final Function(
          bool update, String nameFirst, String nameLast, String displayPicture)
      callback;

  @override
  _UpdateOwnProfileDialogState createState() => _UpdateOwnProfileDialogState();
}

class _UpdateOwnProfileDialogState extends State<UpdateOwnProfileDialog> {
  String displayPicture;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final nameFirstController = TextEditingController(
      text: widget.profile.nameFirst,
    );

    final nameLastController = TextEditingController(
      text: widget.profile.nameLast,
    );

    var width = MediaQuery.of(context).size.width;
    var dialogContentWidth = width * 0.8;
    return Scaffold(
      body: Scrollbar(
        child: new Container(
          padding: EdgeInsets.all(10),
          width: dialogContentWidth,
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextField(
                controller: nameFirstController,
                decoration: new InputDecoration(
                  labelText: 'First name',
                  hintText: 'John',
                ),
              ),
              new TextField(
                controller: nameLastController,
                decoration: new InputDecoration(
                  labelText: 'Last name',
                  hintText: 'Doe',
                ),
              ),
              SizedBox(height:10),
              Container(
                width: 100,
                height: 100,
                child: () {
                  if (displayPicture == null || displayPicture.isEmpty) {
                    return OwnProfileDisplayPicture(
                      profile: widget.profile,
                      size: 100,
                    );
                  }
                  return OwnProfileDisplayPicture(
                    profile: widget.profile,
                    image: MemoryImage(
                      base64.decode(displayPicture),
                    ),
                    size: 100,
                  );
                }(),
              ),
              SizedBox(height: 10),
              Container(
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  onPressed: () {
                    var b = _selectFile();
                    b.then((String d) {
                      setState(() {
                        displayPicture = d;
                      });
                    });
                  },
                  child: Container(
                    child: Center(
                      child: Text(
                        'Pick new display picture',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Update"),
                    onPressed: () {
                      widget.callback(
                        true,
                        nameFirstController.text,
                        nameLastController.text,
                        displayPicture,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Future<String> _selectFile() async {
    String _path;
    try {
      _path = await FilePicker.getFilePath(
        type: FileType.image,
      );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    var b = File(_path).readAsBytesSync();
    var s = base64String(b);
    return s;
  }
}
