import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/model/message.dart';
import 'package:flutterapp/blocs/messages/messages_event.dart';
import 'package:flutterapp/blocs/messages/messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {

  MessagesBloc() : super(MessagesInitial());

  StreamSubscription _messagesSubscription;

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is LoadMessagesForConversation) {
      yield* _mapLoadMessagesForConversationToState(event);
    } else if (event is AddMessage) {
      yield* _mapAddMessageToState(event);
    } else if (event is ClearMessages) {
      yield* _mapClearMessageFromState();
    }
  }

  Stream<MessagesState> _mapLoadMessagesForConversationToState(
    LoadMessagesForConversation event,
  ) async* {
    try {
      yield MessagesLoaded(event.conversation, []);
      _messagesSubscription?.cancel();
      _messagesSubscription = Repository.get()
          .getMessagesForConversation(event.conversation.hash)
          .stream
          .listen((message) => add(AddMessage(message)));
    } catch (err) {
      yield MessagesNotLoaded();
    }
  }

  Stream<MessagesState> _mapAddMessageToState(
    AddMessage event,
  ) async* {
    if (state is MessagesLoaded) {
      MessagesLoaded currentState = state;
      final List<Message> updatedMessages = List.from(currentState.messages)
        ..add(event.message);
      yield MessagesLoaded(currentState.conversation, updatedMessages);
      _saveMessages(updatedMessages);
    }
  }

  Stream<MessagesState> _mapClearMessageFromState() async* {
    if (state is MessagesLoaded) {
      _messagesSubscription?.cancel();
      final List<Message> updatedMessages =
          List.from((state as MessagesLoaded).messages)..clear();
      _saveMessages(updatedMessages);
    }
  }

  Future _saveMessages(List<Message> messages) {
    // TODO put message to repository
  }
}
