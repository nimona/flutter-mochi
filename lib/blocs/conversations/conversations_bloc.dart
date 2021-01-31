import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/blocs/conversations/conversations_event.dart';
import 'package:mochi/blocs/conversations/conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc() : super(ConversationsLoading());

  StreamSubscription<ConversationCreated> _conversationsSubscription;
  StreamSubscription<ConversationCreated> _conversationsGet;

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
      await _conversationsGet?.cancel();
      var handleConversationCreated = (ConversationCreated event) {
        final Conversation conversation = Conversation(
          hash: event.hashS,
          name: event.dataM.nonceS,
        );
        this.add(AddConversation(conversation));
      };
      _conversationsSubscription = Repository.get()
          .subscribeToConversations()
          .stream
          .listen(handleConversationCreated);
      _conversationsGet =
          Repository.get().getConversations(100, 0).stream.listen((event) {
        try {
          Repository.get().refreshConversation(event.hashS);
        } catch (e) {}
        try {
          handleConversationCreated(event);
        } catch (e) {}
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
}
