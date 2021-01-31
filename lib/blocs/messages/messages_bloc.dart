import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/conversation_nickname_updated.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/blocs/messages/messages_event.dart';
import 'package:mochi/blocs/messages/messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial());

  StreamController _subCtrl;
  StreamController _getCtrl;

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
    }
  }

  Stream<MessagesState> _mapLoadMessagesForConversationToState(
    LoadMessagesForConversation event,
  ) async* {
    try {
      yield MessagesLoaded(event.conversation, [], {});
      var handler = (bool old, event) {
        if (event is ConversationMessageAdded) {
          add(
            AddMessage(
              Message(
                body: event.dataM.bodyS,
                hash: event.hashS ?? event.hashCode.toString(),
                senderHash: event.metadataM.ownerS,
                sent: event.metadataM.datetimeS,
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
      };
      var oldHandler = (event) {
        return handler(true, event);
      };
      var newHandler = (event) {
        return handler(false, event);
      };
      // close old controllers
      _subCtrl?.close();
      _getCtrl?.close();
      // start listening for new events
      _subCtrl = await Repository.get()
          .subscribeToMessagesForConversation(event.conversation.hash);
      _subCtrl.stream.listen(newHandler);
      // get old events
      _getCtrl = await Repository.get()
          .getMessagesForConversation(event.conversation.hash, 100, 0);
      _getCtrl.stream.listen(oldHandler);
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
}
