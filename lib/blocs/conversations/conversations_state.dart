import 'package:flutter/material.dart';

import 'package:flutterapp/model/conversation.dart';

@immutable
abstract class ConversationsState {
  ConversationsState([List props = const []]) : super();
}

class ConversationsLoading extends ConversationsState {
  @override
  String toString() => 'ConversationsLoading';
}

class ConversationsLoaded extends ConversationsState {
  final List<Conversation> conversations;

  ConversationsLoaded([this.conversations = const []]) : super([conversations]);

  @override
  String toString() => 'ConversationsLoaded { conversations: $conversations }';
}

class ConversationsNotLoaded extends ConversationsState {
  @override
  String toString() => 'ConversationsNotLoaded';
}
