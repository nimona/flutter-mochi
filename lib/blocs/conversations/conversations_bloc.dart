import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mochi/data/notifier.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/nimona_connection_info.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/blocs/conversations/conversations_event.dart';
import 'package:mochi/blocs/conversations/conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc() : super(ConversationsLoading());

  StreamSubscription<ConversationCreated> _conversationsSubscription;
  StreamSubscription<ConversationCreated> _conversationsGet;
  StreamController<ConversationMessageAdded> _messagesSubscription;

  @override
  Stream<ConversationsState> mapEventToState(
    ConversationsEvent event,
  ) async* {
    if (event is LoadConversations) {
      yield* _mapLoadConversationsToState(event);
    }
    if (event is AddConversation) {
      yield* _mapAddConversationToState(event);
    }
    if (event is SelectConversation) {
      yield* _mapSelectConversationToState(event);
    }
    if (event is AddMessage) {
      yield* _mapAddMessageToState(event);
    }
  }

  Stream<ConversationsState> _mapLoadConversationsToState(
    LoadConversations event,
  ) async* {
    try {
      await _conversationsSubscription?.cancel();
      await _conversationsGet?.cancel();
      await _messagesSubscription?.close();
      final connectionInfo = await Repository.get().getConnectionInfo();
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
      _messagesSubscription = await Repository.get().subscribeToMessages();
      _messagesSubscription.stream.listen((event) {
        this.add(AddMessage(
          event,
        ));
      });
      yield ConversationsLoaded(
        publicKey: connectionInfo.dataM.publicKeyS,
        lastRead: {},
        unreadCount: {},
      );
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
    // if we don't have a last read for this conversation, add one as now
    if (currentState.lastRead[event.conversation.hash] == null) {
      var lastRead = currentState.lastRead;
      lastRead.update(
        event.conversation.hash,
        (value) => DateTime.now(),
        ifAbsent: () => DateTime.now(),
      );
      var unreadCount = currentState.unreadCount;
      unreadCount.update(
        event.conversation.hash,
        (value) => 0,
        ifAbsent: () => 0,
      );
      yield ConversationsLoaded(
        selected: currentState.selected,
        conversations: updatedConversations,
        publicKey: currentState.publicKey,
        lastRead: lastRead,
        unreadCount: unreadCount,
      );
      return;
    }
    yield ConversationsLoaded(
      selected: currentState.selected,
      conversations: updatedConversations,
      publicKey: currentState.publicKey,
      lastRead: currentState.lastRead,
      unreadCount: currentState.unreadCount,
    );
  }

  Stream<ConversationsState> _mapSelectConversationToState(
    SelectConversation event,
  ) async* {
    if (state is ConversationsLoaded) {
      ConversationsLoaded currentState = state;
      var lastRead = currentState.lastRead;
      lastRead.update(
        event.conversation.hash,
        (value) => DateTime.now(),
        ifAbsent: () => DateTime.now(),
      );
      var unreadCount = currentState.unreadCount;
      unreadCount.update(
        event.conversation.hash,
        (value) => 0,
        ifAbsent: () => 0,
      );
      yield ConversationsLoaded(
        selected: event.conversation,
        conversations: currentState.conversations,
        publicKey: currentState.publicKey,
        lastRead: lastRead,
        unreadCount: unreadCount,
      );
    }
  }

  Stream<ConversationsState> _mapAddMessageToState(
    AddMessage event,
  ) async* {
    if (state is ConversationsLoaded) {
      ConversationsLoaded currentState = state;
      if (currentState.publicKey == event.message.metadataM.ownerS) {
        return;
      }
      final messageLastRead = DateTime.tryParse(
        event.message.metadataM.datetimeS,
      );
      if (messageLastRead == null) {
        return;
      }
      final conversationHash = event.message.metadataM.streamS;
      final conversationLastRead = currentState.lastRead[conversationHash];
      if (conversationLastRead == null) {
        return;
      }
      if (conversationLastRead.isAfter(messageLastRead)) {
        return;
      }
      var unreadCount = currentState.unreadCount;
      if (currentState.selected?.hash != event.message.metadataM.streamS) {
        unreadCount.update(
          event.message.metadataM.streamS,
          (value) => value+1,
          ifAbsent: () => 1,
        );
      }
      yield ConversationsLoaded(
        selected: currentState.selected,
        conversations: currentState.conversations,
        publicKey: currentState.publicKey,
        lastRead: currentState.lastRead,
        unreadCount: unreadCount,
      );
      try {
        Notifier.get().showNotification(
          '@ ' + event.message.metadataM.ownerS,
          '> ' + event.message.dataM.bodyS,
          '# ' + event.message.metadataM.streamS,
        );
      } catch (e) {
        print('ERR=' + e.toString());
      }
    }
  }
}
