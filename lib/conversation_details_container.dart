import 'package:flutter/material.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/view/participant_name.dart';

class ConversationDetailsContainer extends StatelessWidget {
  const ConversationDetailsContainer({
    Key key,
    @required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final nameController = TextEditingController(
      text: conversation.name,
    );
    final topicController = TextEditingController(
      text: conversation.topic,
    );

    // participants list
    Widget ps = ListView(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: conversation.participants.map((participant) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.network(
              "http://localhost:10100/displayPictures/" + participant.key,
              height: 40,
            ),
          ),
          title: ParticipantName(
            context: context,
            participant: participant,
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

    // conversation details
    Widget d = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new TextField(
          // // controller: nameController,
          // autofocus: true,
          decoration: new InputDecoration(
              labelText: 'Conversation name',
              hintText: 'eg. Worse than random'),
        ),
        new TextField(
          // controller: topicController,
          // autofocus: true,
          decoration: new InputDecoration(
            labelText: 'Topic',
            hintText: 'eg. typewriters',
          ),
        )
      ],
    );

    // scaffold
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Conversation details",
              style: textTheme.headline4,
              textAlign: TextAlign.left,
            ),
            Container(
              child: d,
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              "Conversation participants",
              style: textTheme.headline4,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: ps,
            )
          ],
        ),
      ),
    );
  }
}
