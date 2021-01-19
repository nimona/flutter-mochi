import 'package:equatable/equatable.dart';
import 'package:flutterapp/model/conversation.dart';

import 'package:flutterapp/model/message.dart';

abstract class MessagesEvent extends Equatable {
  MessagesEvent([List props = const []]) : super();
}

class LoadMessagesForConversation extends MessagesEvent {
  final Conversation conversation;

  LoadMessagesForConversation(this.conversation) : super([conversation]);

  @override
  List<Object> get props => [conversation];

  @override
  String toString() => 'LoadMessagesForConversation';
}

class AddMessage extends MessagesEvent {
  final Message message;

  AddMessage(this.message) : super([message]);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddMessage { message: $message }';
}

class UpdateMessage extends MessagesEvent {
  final Message updatedMessage;

  UpdateMessage(this.updatedMessage) : super([updatedMessage]);

  @override
  List<Object> get props => [updatedMessage];

  @override
  String toString() =>
      'UpdateMessage { updatedMessage: $updatedMessage }';
}

class DeleteMessage extends MessagesEvent {
  final Message message;

  DeleteMessage(this.message) : super([message]);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteMessage { message: $message }';
}

class ClearMessages extends MessagesEvent {
  ClearMessages() : super([]);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearMessages';
}
