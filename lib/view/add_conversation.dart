import 'package:flutter/material.dart';
import 'package:mochi/data/repository.dart';

class AddConversationWidget extends StatelessWidget {
  const AddConversationWidget({
    Key key,
    @required this.nameController,
    @required this.topicController,
    @required this.hashController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController topicController;
  final TextEditingController hashController;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "Start new conversation",
            style: textTheme.headline4,
            textAlign: TextAlign.left,
          ),
          new TextField(
            controller: nameController,
            decoration: new InputDecoration(
              labelText: 'Conversation name',
              hintText: 'eg. Worse than random',
            ),
          ),
          new TextField(
            controller: topicController,
            decoration: new InputDecoration(
              labelText: 'Topic',
              hintText: '',
            ),
          ),
          new ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text("Create conversations"),
                onPressed: () {
                  Repository.get().createConversation(
                    nameController.text,
                    topicController.text,
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          new Text(
            "Join existing conversation",
            style: textTheme.headline4,
            textAlign: TextAlign.left,
          ),
          new TextField(
            controller: hashController,
            decoration: new InputDecoration(
              labelText: 'Conversation stream id',
              hintText: 'should start with oh1.',
            ),
          ),
          new ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text("Join conversations"),
                onPressed: () {
                  Repository.get().joinConversation(
                    hashController.text,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
