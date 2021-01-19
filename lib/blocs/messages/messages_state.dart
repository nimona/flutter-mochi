import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/conversation.dart';

import 'package:flutterapp/model/message.dart';

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

  MessagesLoaded(this.conversation, this.messages) : super([conversation, messages]);

  @override
  String toString() => 'MessagesLoaded { messages: $messages }';
}

class MessagesNotLoaded extends MessagesState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'MessagesNotLoaded';
}