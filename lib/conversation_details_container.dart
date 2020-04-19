import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mochi/data/wsdatastore.dart';

import 'package:mochi/model/conversation.dart';
import 'package:mochi/view/conversation_display_picture.dart';
import 'package:mochi/view/participant_name.dart';
import 'package:mochi_mobile/mochi_mobile.dart';

class ConversationDetailsContainer extends StatefulWidget {
  const ConversationDetailsContainer({
    Key key,
    @required this.conversation,
    @required this.callback,
  }) : super(key: key);

  final Conversation conversation;
  final Function(bool update, String name, String topic, String displayPicture)
      callback;

  @override
  _ConversationDetailsContainerState createState() =>
      _ConversationDetailsContainerState();
}

class _ConversationDetailsContainerState
    extends State<ConversationDetailsContainer> {
  String displayPicture;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final nameController = TextEditingController(
      text: widget.conversation.name,
    );
    final topicController = TextEditingController(
      text: widget.conversation.topic,
    );

    Widget ps = Text("no participants");

    // participants list
    if (widget.conversation.participants != null) {
      ps = ListView(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: widget.conversation.participants.map((participant) {
          return ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                "$daemonApiHttpUrl$daemonApiPort/displayPictures/${participant.key}",
                height: 40,
              ),
            ),
            title: ParticipantName(
              context: context,
              nameFirst: participant.profile.nameFirst,
              nameLast: participant.profile.nameLast,
              profileKey: participant.profile.key,
              alias: participant.contact?.alias,
              textTheme: textTheme,
            ),
            subtitle: Text(
              participant.key,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // onTap: () => conversationUpdatedCallback(participant),
            // selected: widget.conversation == participant,
            dense: true,
          );
        }).toList(),
      );
    }

    if (displayPicture == null) {
      displayPicture = "";
    }

    // conversation details
    Widget d = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: () {
                if (displayPicture.isEmpty) {
                  return ConversationDisplayPicture(
                    conversation: widget.conversation,
                    size: 100,
                  );
                }
                return ConversationDisplayPicture(
                  conversation: widget.conversation,
                  image: MemoryImage(
                    base64.decode(displayPicture),
                  ),
                  size: 100,
                );
              }(),
            ),
            SizedBox(width: 10),
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
          ],
        ),
        new TextField(
          controller: nameController,
          decoration: new InputDecoration(
              labelText: 'Conversation name',
              hintText: 'eg. Worse than random'),
        ),
        new TextField(
          controller: topicController,
          decoration: new InputDecoration(
            labelText: 'Topic',
            hintText: 'eg. typewriters',
          ),
        )
      ],
    );

    // scaffold
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
            "Conversation details",
            style: textTheme.headline4,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Container(
            child: d,
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
                    false,
                    nameController.text,
                    topicController.text,
                    displayPicture,
                  );
                },
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  widget.callback(false, "", "", "");
                },
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          Text(
            "Conversation participants",
            style: textTheme.headline4,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ps,
          ),
        ],
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
