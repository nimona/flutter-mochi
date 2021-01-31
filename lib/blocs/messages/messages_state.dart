import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/message.dart';

@immutable
abstract class MessagesState extends Equatable {
  MessagesState([List props = const []]) : super();
}

class MessagesInitial extends MessagesState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'MessagesInitial';
}

class MessagesLoading extends MessagesState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'MessagesLoading';
}

class MessagesLoaded extends MessagesState {
  @override
  List<Object> get props => [conversation, messages];

  Conversation conversation;
  List<Message> messages;
  Map<String, String> nicknames;

  MessagesLoaded(
    this.conversation,
    this.messages,
    this.nicknames,
  ) : super([
          conversation,
          messages,
          nicknames,
        ]);

  @override
  String toString() => 'MessagesLoaded { messages: $messages }';
}

class MessagesNotLoaded extends MessagesState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'MessagesNotLoaded';
}
