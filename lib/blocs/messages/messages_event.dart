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
  final String senderHash;
  final String nickname;

  NicknameChanged(
    this.senderHash,
    this.nickname,
  ) : super([
          senderHash,
          nickname,
        ]);

  @override
  List<Object> get props => [
        senderHash,
        nickname,
      ];

  @override
  String toString() =>
      'NicknameChanged { senderHash: $senderHash, nickname: $nickname }';
}

class TopicChanged extends MessagesEvent {
  final String senderHash;
  final String topic;

  TopicChanged(
    this.senderHash,
    this.topic,
  ) : super([
          senderHash,
          topic,
        ]);

  @override
  List<Object> get props => [
        senderHash,
        topic,
      ];

  @override
  String toString() =>
      'TopicChanged { senderHash: $senderHash, topic: $topic }';
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
