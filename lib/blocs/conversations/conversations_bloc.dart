import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/blocs/conversations/conversations_event.dart';
import 'package:flutterapp/blocs/conversations/conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final Repository _repository = Repository.get();

  ConversationsBloc() : super(ConversationsLoading());

  StreamSubscription _conversationsSubscription;

  @override
  Stream<ConversationsState> mapEventToState(
    ConversationsEvent event,
  ) async* {
    if (event is LoadConversations) {
      yield* _mapLoadConversationsToState();
    } else if (event is AddConversation) {
      yield* _mapAddConversationToState(event);
    }
  }

  Stream<ConversationsState> _mapLoadConversationsToState() async* {
    try {
      await _conversationsSubscription?.cancel();
      _conversationsSubscription = Repository.get()
          .getConversations()
          .stream
          .listen((conversation) => add(AddConversation(conversation)));
      yield ConversationsLoaded();
    } catch (_) {
      yield ConversationsNotLoaded();
    }
  }

  Stream<ConversationsState> _mapAddConversationToState(
    AddConversation event,
  ) async* {
    final List<Conversation> updatedConversations =
        List.from((state as ConversationsLoaded).conversations)
          ..add(event.conversation);
    yield ConversationsLoaded(updatedConversations);
    _saveConversations(updatedConversations);
  }

  Future _saveConversations(List<Conversation> conversations) {
    // TODO put conversation to repository
  }
}
