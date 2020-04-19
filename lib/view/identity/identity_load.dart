import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mochi/data/repository.dart';
import 'package:mochi/data/ws_model/daemon_info_response.dart';

class IdentityLoadScreen extends StatefulWidget {
  @override
  _IdentityLoadScreenState createState() => _IdentityLoadScreenState();
}

class _IdentityLoadScreenState extends State<IdentityLoadScreen> {
  Future<DaemonInfoResponse> daemonInfo;
  TextEditingController mnemonicPhraseCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    daemonInfo = Repository.get().daemonInfoGet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Use existing identity.',
                textAlign: TextAlign.left,
                style: textTheme.headline3,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Please paste or type in your mnemonic seed.',
                textAlign: TextAlign.left,
                style: textTheme.bodyText1,
              ),
              Text(
                'Line breaks, numbers, and special characters will be ignored.',
                textAlign: TextAlign.left,
                style: textTheme.bodyText1,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 2,
                maxLines: 10,
                style: TextStyle(
                  fontFamily: "Courier",
                ),
                controller: mnemonicPhraseCtrl,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Color(0xFF4d85ff)),
                    ),
                    labelText: 'Mnemonic phrase',
                    labelStyle: TextStyle(
                      fontFamily: textTheme.bodyText1.fontFamily,
                      fontSize: textTheme.headline6.fontSize,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(15),
                  onPressed: () {
                    try {
                      Repository.get()
                          .identityLoad(
                        mnemonicPhraseCtrl.text,
                      )
                          .then(
                        (value) {
                          sleep(const Duration(seconds: 1));
                          Navigator.pushNamed(context, '/main');
                        },
                      );
                    } catch (e) {
                      print("could not load identity, err=" + e.toString());
                      return;
                    }
                    print("loaded id");
                  },
                  color: Color(0xFF6697FF),
                  child: Container(
                    child: Center(
                      child: Text(
                        'Import identity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
