import 'package:equatable/equatable.dart';
import 'package:mochi/model/conversation.dart';

import 'package:mochi/model/message.dart';

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

class NicknameChanged extends MessagesEvent {
  final String senderCID;
  final String nickname;

  NicknameChanged(
    this.senderCID,
    this.nickname,
  ) : super([
          senderCID,
          nickname,
        ]);

  @override
  List<Object> get props => [
        senderCID,
        nickname,
      ];

  @override
  String toString() =>
      'NicknameChanged { senderCID: $senderCID, nickname: $nickname }';
}

class TopicChanged extends MessagesEvent {
  final String senderCID;
  final String topic;

  TopicChanged(
    this.senderCID,
    this.topic,
  ) : super([
          senderCID,
          topic,
        ]);

  @override
  List<Object> get props => [
        senderCID,
        topic,
      ];

  @override
  String toString() =>
      'TopicChanged { senderCID: $senderCID, topic: $topic }';
}

class UpdateMessage extends MessagesEvent {
  final Message updatedMessage;

  UpdateMessage(this.updatedMessage) : super([updatedMessage]);

  @override
  List<Object> get props => [updatedMessage];

  @override
  String toString() => 'UpdateMessage { updatedMessage: $updatedMessage }';
}

class DeleteMessage extends MessagesEvent {
  final Message message;

  DeleteMessage(this.message) : super([message]);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteMessage { message: $message }';
}
