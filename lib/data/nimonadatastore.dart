import 'dart:async';

import 'package:flutterapp/data/datastore.dart';
import 'package:flutterapp/event/conversation_created.dart'
    as conversation_created;
import 'package:flutterapp/event/conversation_message_added.dart'
    as conversation_message_added;
import 'package:flutterapp/event/nimona_medatada.dart';
import 'package:flutterapp/event/nimona_typed.dart';
import 'package:flutterapp/event/utils.dart';
import 'package:nimona/models/get_request.dart';
import 'package:nimona/nimona.dart';
import 'package:uuid/uuid.dart';

class NimonaDataStore implements DataStore {
  @override
  Stream<conversation_created.ConversationCreated> getConversations(
    int limit,
    int offset,
  ) async* {
    GetRequest req = GetRequest(
      limit: limit,
      offset: offset,
      lookup: 'type:stream:poc.nimona.io/conversation',
      orderBy: 'MetadataDatetime',
      orderDir: 'ASC',
    );
    final subKey = await Nimona.get(req);
    Stream<String> sub = Nimona.pop(subKey);
    await for (final objectBody in sub) {
      try {
        // print('GOT ConversationCreated ' + objectBody);
        final NimonaTyped object = unmarshal(objectBody);
        if (object is conversation_created.ConversationCreated) {
          yield object;
        }
      } catch (e) {
        // TODO log error
        print('ERROR unmarshaling typed message object, err=' + e.toString());
      }
    }
  }

  @override
  Stream<conversation_created.ConversationCreated>
      subscribeToConversations() async* {
    final String rootType = 'stream:poc.nimona.io/conversation';
    final String subKey = await Nimona.subscribe('type:' + rootType);
    Stream<String> sub = Nimona.pop(subKey);
    await for (final objectBody in sub) {
      try {
        // print('GOT ConversationCreated ' + objectBody);
        final NimonaTyped object = unmarshal(objectBody);
        // print('UNMARSHALED ConversationCreated ' + object.toString());
        if (object is conversation_created.ConversationCreated) {
          yield object;
        }
      } catch (e) {
        // TODO log error
        print('ERROR unmarshaling conversation created object, err=' +
            e.toString());
      }
    }
  }

  @override
  Future<void> createConversation(String name, String topic) async {
    try {
      final c = conversation_created.ConversationCreated(
        dataM: conversation_created.DataM(
          nonceS: Uuid().v4().toString(),
        ),
      );
      await Nimona.put(c.toJson());
    } catch (e) {
      // TODO log error
      print('ERROR putting conversationCreated, err=' + e.toString());
    }
  }

  @override
  Stream<NimonaTyped> getMessagesForConversation(
    String conversationId,
    int limit,
    int offset,
  ) async* {
    GetRequest req = GetRequest(
      limit: limit,
      offset: offset,
      lookup: 'stream:' + conversationId,
      orderBy: 'MetadataDatetime',
      orderDir: 'ASC',
    );
    final subKey = await Nimona.get(req);
    Stream<String> sub = Nimona.pop(subKey);
    await for (final objectBody in sub) {
      try {
        // print('GOT ConversationCreated ' + objectBody);
        final NimonaTyped object = unmarshal(objectBody);
        yield object;
      } catch (e) {
        // TODO log error
        print('ERROR unmarshaling typed message object, err=' + e.toString());
      }
    }
  }

  @override
  Stream<NimonaTyped> subscribeToMessagesForConversation(
    String conversationId,
  ) async* {
    final subKey = await Nimona.subscribe('stream:' + conversationId);
    Stream<String> sub = Nimona.pop(subKey);
    await for (final objectBody in sub) {
      try {
        // print('GOT ConversationCreated ' + objectBody);
        final NimonaTyped object = unmarshal(objectBody);
        yield object;
      } catch (e) {
        // TODO log error
        print('ERROR unmarshaling typed message object, err=' + e.toString());
      }
    }
  }

  @override
  Future<void> createMessage(String conversationHash, String body) async {
    try {
      final c = conversation_message_added.ConversationMessageAdded(
        metadataM: MetadataM(
          streamS: conversationHash,
          ownerS: '@peer',
          datetimeS: DateTime.now().toUtc().toIso8601String(),
        ),
        dataM: conversation_message_added.DataM(
          bodyS: body,
        ),
      );
      await Nimona.put(c.toJson());
    } catch (e) {
      // TODO log error
      print('ERROR putting conversationCreated, err=' + e.toString());
    }
  }
}
