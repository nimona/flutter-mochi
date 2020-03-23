import 'package:flutter/material.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/view/participant_name.dart';

class ConversationDetailsContainer extends StatefulWidget {
  ConversationDetailsContainer({
    this.conversationUpdatedCallback,
    this.selectedConversation,
  });

  ValueChanged<Conversation> conversationUpdatedCallback;
  Conversation selectedConversation;

  @override
  _ConversationDetailsContainer createState() => _ConversationDetailsContainer(
      conversationUpdatedCallback, selectedConversation);
}

class _ConversationDetailsContainer
    extends State<ConversationDetailsContainer> {
  _ConversationDetailsContainer(
      this.conversationUpdatedCallback, this.selectedConversation);

  ValueChanged<Conversation> conversationUpdatedCallback;
  Conversation selectedConversation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Scrollbar(
        child: ListView(
          children: selectedConversation.participants.map((participant) {
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
              // selected: widget.selectedConversation == participant,
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }
}
