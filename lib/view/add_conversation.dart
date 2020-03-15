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
    var width = MediaQuery.of(context).size.width;
    var dialogContentWidth = width * 0.5;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            width: dialogContentWidth,
            child: new Expanded(
              child: new Column(
                children: <Widget>[
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
                      hintText: 'eg. typewriters',
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
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          new Container(
            width: dialogContentWidth,
            child: new Expanded(
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: hashController,
                    decoration: new InputDecoration(
                      labelText: 'Conversation stream id',
                      hintText: 'should start with oh.',
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
            ),
          ),
        ],
      ),
    );
  }
}
