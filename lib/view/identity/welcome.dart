import 'package:flutter/material.dart';

import 'package:mochi/data/repository.dart';
import 'package:mochi/data/ws_model/daemon_info_response.dart';
import 'package:mochi/view/identity/delayed_animation.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<DaemonInfoResponse> daemonInfo;

  @override
  void initState() {
    super.initState();

    daemonInfo = Repository.get().daemonInfoGet().then(
      (DaemonInfoResponse data) {
        if (data.identityPublicKey.isNotEmpty) {
          Navigator.pushNamed(context, '/main');
        }
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0xFF6697FF),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: daemonInfo,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DaemonInfoResponse> snapshot,
                ) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text(
                      "Reticulating splines...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textTheme.caption.fontSize,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("Something went horribly wrong.\n" +
                        snapshot.error.toString());
                  }
                  return Column(
                    children: [
                      DelayedAnimation(
                        delay: 0,
                        child: Opacity(
                          opacity: 1,
                          child: Container(
                            width: 100,
                            height: 113,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'images/nimona-white.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      DelayedAnimation(
                        delay: 1000,
                        child: Text(
                          "Hey there!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textTheme.headline6.fontSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      DelayedAnimation(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(15),
                          onPressed: () {
                            Navigator.pushNamed(context, '/identity-create');
                          },
                          color: Colors.white,
                          child: Container(
                            width: 260,
                            child: Center(
                              child: Text(
                                'Create new identity',
                                style: TextStyle(
                                  fontSize: textTheme.headline6.fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6697FF),
                                ),
                              ),
                            ),
                          ),
                        ),
                        delay: 1500,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DelayedAnimation(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/identity-load');
                          },
                          color: Color(0xFF4d85ff),
                          child: Container(
                            width: 260,
                            child: Center(
                              child: Text(
                                'I already have one',
                                style: TextStyle(
                                  fontSize: textTheme.bodyText2.fontSize,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        delay: 2000,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
