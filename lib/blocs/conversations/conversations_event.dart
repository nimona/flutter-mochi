import 'package:equatable/equatable.dart';
import 'package:mochi/event/conversation_message_added.dart';

import 'package:mochi/model/conversation.dart';

abstract class ConversationsEvent extends Equatable {
  ConversationsEvent([List props = const []]) : super();
}

class LoadConversations extends ConversationsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadConversations';
}

class AddConversation extends ConversationsEvent {
  final Conversation conversation;

  AddConversation(this.conversation) : super([conversation]);

  @override
  List<Object> get props => [conversation];

  @override
  String toString() => 'AddConversation { conversation: $conversation }';
}

class AddMessage extends ConversationsEvent {
  final ConversationMessageAdded message;

  AddMessage(this.message) : super([message]);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddMessage { message: $message }';
}

class SelectConversation extends ConversationsEvent {
  final Conversation conversation;

  SelectConversation(this.conversation) : super([conversation]);

  @override
  List<Object> get props => [conversation];

  @override
  String toString() => 'SelectConversation { conversation: $conversation }';
}

class UpdateConversation extends ConversationsEvent {
  final Conversation updatedConversation;

  UpdateConversation(this.updatedConversation) : super([updatedConversation]);

  @override
  List<Object> get props => [updatedConversation];

  @override
  String toString() =>
      'UpdateConversation { updatedConversation: $updatedConversation }';
}

class DeleteConversation extends ConversationsEvent {
  final Conversation conversation;

  DeleteConversation(this.conversation) : super([conversation]);

  @override
  List<Object> get props => [conversation];

  @override
  String toString() => 'DeleteConversation { conversation: $conversation }';
}

class UpdateTopic extends ConversationsEvent {
  final String conversationHash;
  final String topic;

  UpdateTopic(
    this.conversationHash,
    this.topic,
  ) : super([
          conversationHash,
          topic,
        ]);

  @override
  List<Object> get props => [
        conversationHash,
        topic,
      ];

  @override
  String toString() =>
      'UpdateTopic { conversationHash: $conversationHash, topic: $topic }';
}

class ClearCompleted extends ConversationsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearCompleted';
}
