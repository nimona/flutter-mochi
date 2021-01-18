import 'package:equatable/equatable.dart';

import 'package:flutterapp/model/conversation.dart';

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

class ClearCompleted extends ConversationsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearCompleted';
}
