import 'package:flutter/material.dart';

import 'package:mochi/model/conversation.dart';

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
  final Conversation selected;
  final String publicKey;
  final Map<String, DateTime> lastRead;
  final Map<String, int> unreadCount;

  ConversationsLoaded({
    this.selected,
    this.conversations = const [],
    this.publicKey,
    this.lastRead,
    this.unreadCount,
  }) : super([
          selected,
          conversations,
          publicKey,
          lastRead,
          unreadCount,
        ]);

  @override
  String toString() => 'ConversationsLoaded { conversations: $conversations }';
}

class ConversationsNotLoaded extends ConversationsState {
  @override
  String toString() => 'ConversationsNotLoaded';
}
