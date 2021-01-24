import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/blocs/conversations/conversations_event.dart';
import 'package:flutterapp/blocs/conversations/conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc() : super(ConversationsLoading());

  StreamSubscription<ConversationCreated> _conversationsSubscription;

  @override
  Stream<ConversationsState> mapEventToState(
    ConversationsEvent event,
  ) async* {
    if (event is LoadConversations) {
      yield* _mapLoadConversationsToState();
    }
    if (event is AddConversation) {
      yield* _mapAddConversationToState(event);
    }
    if (event is SelectConversation) {
      yield* _mapLoadMessagesForConversationToState(event);
    }
  }

  Stream<ConversationsState> _mapLoadConversationsToState() async* {
    try {
      await _conversationsSubscription?.cancel();
      _conversationsSubscription = Repository.get()
          .getConversations()
          .stream
          .listen((ConversationCreated event) {
        final Conversation conversation = Conversation(
          hash: event.hashS,
          name: event.dataM.nonceS,
        );
        this.add(AddConversation(conversation));
      });
      yield ConversationsLoaded();
    } catch (_) {
      yield ConversationsNotLoaded();
    }
  }

  Stream<ConversationsState> _mapAddConversationToState(
    AddConversation event,
  ) async* {
    ConversationsLoaded currentState = state;
    final List<Conversation> updatedConversations =
        List.from(currentState.conversations)..add(event.conversation);
    yield ConversationsLoaded(
      selected: currentState.selected,
      conversations: updatedConversations,
    );
    _saveConversations(updatedConversations);
  }

  Stream<ConversationsState> _mapLoadMessagesForConversationToState(
    SelectConversation event,
  ) async* {
    if (state is ConversationsLoaded) {
      ConversationsLoaded currentState = state;
      yield ConversationsLoaded(
        selected: event.conversation,
        conversations: currentState.conversations,
      );
    }
  }

  Future _saveConversations(List<Conversation> conversations) {
    // TODO put conversation to repository
  }
}
