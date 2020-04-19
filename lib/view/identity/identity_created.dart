import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/data/ws_model/daemon_info_response.dart';

class IdentityCreatedScreen extends StatefulWidget {
  @override
  _IdentityCreatedScreenState createState() => _IdentityCreatedScreenState();
}

class _IdentityCreatedScreenState extends State<IdentityCreatedScreen> {
  Future<DaemonInfoResponse> daemonInfo;

  @override
  void initState() {
    super.initState();

    daemonInfo = Repository.get().daemonInfoGet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDefaultSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Secret phrase copied'),
      ),
    );
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
      body: FutureBuilder(
        future: daemonInfo,
        builder: (
          BuildContext context,
          AsyncSnapshot<DaemonInfoResponse> snapshot,
        ) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Text(snapshot.connectionState.toString());
          }
          List<String> words = snapshot.data.identitySecretPhrase;
          return Container(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Yay!! 😊',
                    textAlign: TextAlign.left,
                    style: textTheme.headline3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your new identity is ready, you should make sure to keep it safe.',
                    textAlign: TextAlign.left,
                    style: textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Your very secret phrase.',
                    textAlign: TextAlign.left,
                    style: textTheme.headline4,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'These 24 words are your secret phrase, write them down and don’t share them with anyone.',
                      style: textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                    child: Column(
                      children: <Widget>[
                        WordsRow(index: 0, words: words),
                        WordsRow(index: 3, words: words),
                        WordsRow(index: 6, words: words),
                        WordsRow(index: 9, words: words),
                        WordsRow(index: 12, words: words),
                        WordsRow(index: 15, words: words),
                        WordsRow(index: 18, words: words),
                        WordsRow(index: 21, words: words),
                        Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: () {
                                      var phrase = '';
                                      for (var i = 0; i < words.length; i++) {
                                        var word = words[i];
                                        if (i % 4 == 0) {
                                          phrase = phrase.trimRight() + "\n";
                                        }
                                        phrase +=
                                            "${(i + 1).toString().padLeft(2, ' ')}";
                                        phrase += ": ${word.padRight(10, ' ')}";
                                      }
                                      return phrase.trimRight();
                                    }(),
                                  ),
                                );
                                showDefaultSnackbar(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                child: Text(
                                  'Copy to clipboard',
                                  style: TextStyle(
                                    color: Color(0xFF6697FF),
                                    // fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(15),
                      onPressed: () {
                        Navigator.pushNamed(context, '/main');
                      },
                      color: Color(0xFF6697FF),
                      child: Container(
                        child: Center(
                          child: Text(
                            'Ready',
                            style: TextStyle(
                              fontSize: 20.0,
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
          );
        },
      ),
    );
  }
}

class WordsRow extends StatelessWidget {
  const WordsRow({Key key, @required this.words, this.index}) : super(key: key);

  final List<String> words;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.only(left: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(words == null ? '' : words[index + 0]),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  '${index + 2}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.only(left: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(words == null ? '' : words[index + 1]),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  '${index + 3}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.only(left: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(words == null ? '' : words[index + 2]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
