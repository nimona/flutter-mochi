import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutterapp/data/repository.dart';
import 'package:flutterapp/event/conversation_message_added.dart';
import 'package:flutterapp/event/conversation_nickname_updated.dart';
import 'package:flutterapp/model/message.dart';
import 'package:flutterapp/blocs/messages/messages_event.dart';
import 'package:flutterapp/blocs/messages/messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial());

  StreamSubscription _eventSubscription;

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is LoadMessagesForConversation) {
      yield* _mapLoadMessagesForConversationToState(event);
    } else if (event is AddMessage) {
      yield* _mapAddMessageToState(event);
    } else if (event is NicknameChanged) {
      yield* _mapNicknameChangesToState(event);
    } else if (event is ClearMessages) {
      yield* _mapClearMessageFromState();
    }
  }

  Stream<MessagesState> _mapLoadMessagesForConversationToState(
    LoadMessagesForConversation event,
  ) async* {
    try {
      yield MessagesLoaded(event.conversation, [], {});
      _eventSubscription?.cancel();
      _eventSubscription = Repository.get()
          .getMessagesForConversation(event.conversation.hash)
          .stream
          .listen((event) {
        if (event is ConversationMessageAdded) {
          add(
            AddMessage(
              Message(
                body: event.dataM.bodyS,
                hash: event.hashS ?? event.hashCode.toString(),
                senderHash: event.metadataM.ownerS,
                sent: event.dataM.datetimeS,
                senderNickname: "",
              ),
            ),
          );
        }
        if (event is ConversationNicknameUpdated) {
          add(
            NicknameChanged(
              event.metadataM.ownerS,
              event.dataM.nicknameS,
            ),
          );
        }
      });
    } catch (err) {
      yield MessagesNotLoaded();
    }
  }

  Stream<MessagesState> _mapAddMessageToState(
    AddMessage event,
  ) async* {
    if (state is MessagesLoaded) {
      MessagesLoaded currentState = state;
      final message = event.message.copyWith(
        senderNickname: currentState.nicknames[event.message.senderHash],
      );
      final List<Message> updatedMessages = List.from(currentState.messages)
        ..add(message);
      yield MessagesLoaded(
        currentState.conversation,
        updatedMessages,
        currentState.nicknames,
      );
    }
  }

  Stream<MessagesState> _mapNicknameChangesToState(
    NicknameChanged event,
  ) async* {
    if (state is MessagesLoaded) {
      MessagesLoaded currentState = state;
      // update nickname map
      Map<String, String> nicknames = currentState.nicknames;
      nicknames[event.senderHash] = event.nickname;
      // go through existing messages and update nicknames
      List<Message> messages = List.from(currentState.messages);
      for (var i = 0; i < messages.length; i++) {
        final Message message = messages[i];
        if (message.senderHash != event.senderHash) {
          continue;
        }
        if (message.senderNickname == event.nickname) {
          continue;
        }
        messages[i] = message.copyWith(
          senderNickname: event.nickname,
        );
      }

      yield MessagesLoaded(
        currentState.conversation,
        messages,
        nicknames,
      );
    }
  }

  Stream<MessagesState> _mapClearMessageFromState() async* {
    if (state is MessagesLoaded) {
      _eventSubscription?.cancel();
      List.from((state as MessagesLoaded).messages)..clear();
    }
  }
}
