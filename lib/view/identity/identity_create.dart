import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/model/own_profile.dart';
import 'package:mochi/view/dialog_modify_profile.dart';

String base64String(Uint8List data) {
  return base64Encode(data);
}

class IdentityCreateScreen extends StatefulWidget {
  @override
  _IdentityCreateScreenState createState() => _IdentityCreateScreenState();
}

String nameFirst;
String nameLast;
String displayPicture;

class _IdentityCreateScreenState extends State<IdentityCreateScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _openFileExplorer() async {
      String _path;
      Map<String, String> _paths;
      try {
        _paths = null;
        _path = await FilePicker.getFilePath(
          type: FileType.any,
        );
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        displayPicture = base64String(File(_path).readAsBytesSync());
      });
    }

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        bottomOpacity: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Create new identity',
                textAlign: TextAlign.left,
                style: textTheme.headline3,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your name will be displayed on all your public and private interactions.',
                textAlign: TextAlign.left,
                style: textTheme.bodyText1,
              ),
            ),
            Expanded(
              child: UpdateOwnProfileDialog(
                saveButtonText: "Create identity",
                profile: OwnProfile(
                  key: "",
                ),
                callback: (
                  bool update,
                  String nameFirst,
                  String nameLast,
                  String displayPicture,
                ) {
                  if (update) {
                   var res= Repository.get().identityCreate(
                      nameFirst,
                      nameLast,
                      displayPicture,
                    );
                    res.then((value) {
                         Navigator.pushNamed(context, '/identity-created');
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
