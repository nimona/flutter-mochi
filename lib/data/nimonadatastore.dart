import 'dart:async';

import 'package:mochi/data/datastore.dart';
import 'package:mochi/event/conversation_created.dart' as conversation_created;
import 'package:mochi/event/conversation_message_added.dart'
    as conversation_message_added;
import 'package:mochi/event/conversation_nickname_updated.dart';
import 'package:mochi/event/conversation_topic_updated.dart';
import 'package:mochi/event/nimona_connection_info.dart';
import 'package:mochi/event/nimona_medatada.dart';
import 'package:mochi/event/nimona_stream_subscription.dart' as nss;
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';
import 'package:mochi/event/utils.dart';
import 'package:nimona/models/get_request.dart';
import 'package:nimona/models/subscribe_request.dart';
import 'package:nimona/nimona.dart';
import 'package:uuid/uuid.dart';

class NimonaDataStore implements DataStore {
  @override
  Future<void> init() async {
    try {
      Nimona.init();
    } catch (e) {
      print('ERROR initializing, err=' + e.toString());
    }
  }

  @override
  Future<ConnectionInfo> getConnectionInfo() async {
    try {
      final res = await Nimona.getConnectionInfo();
      return unmarshal(res);
    } catch (e) {
      print('getConnectionInfo() ERROR err=' + e.toString());
      throw e;
    }
  }

  @override
  Future<void> refreshConversation(
    String conversationRootCID,
  ) async {
    try {
      await Nimona.requestStream(conversationRootCID);
    } catch (e) {
      print('ERROR refreshing stream, err=' + e.toString());
      throw e;
    }
  }

  @override
  Future<void> joinConversation(
    String conversationRootCID,
  ) async {
    try {
      await Nimona.requestStream(conversationRootCID);
      final sub = nss.StreamSubscription(
        dataM: nss.DataM(
          expiryS: DateTime.now().add(Duration(days: 30)).toIso8601String(),
        ),
        metadataM: MetadataM(
          datetimeS: DateTime.now().toIso8601String(),
          ownerS: '@peer',
          streamS: conversationRootCID,
        ),
      );
      await Nimona.put(sub.toJson());
    } catch (e) {
      print('ERROR requesting stream, err=' + e.toString());
      throw e;
    }
  }

  @override
  Stream<NimonaTyped> getConversations(
    int limit,
    int offset,
  ) async* {
    // TODO split requests for conversations and updates for limits to work
    // TODO maybe rename or split to getConversationUpdates
    GetRequest req = GetRequest(
      limit: limit,
      offset: offset,
      lookups: [
        'type:' + ConversationCreatedType,
        'type:' + ConversationTopicUpdatedType,
      ],
      orderBy: 'MetadataDatetime',
      orderDir: 'ASC',
    );
    final objectBodies = await Nimona.get(req);
    for (final objectBody in objectBodies) {
      try {
        final NimonaTyped object = unmarshal(objectBody);
        yield object;
      } catch (e) {
        print('ERROR unmarshaling typed message object, err=' + e.toString());
        throw e;
      }
    }
  }

  @override
  Stream<conversation_created.ConversationCreated>
      subscribeToConversations() async* {
    final String subKey = await Nimona.subscribe(
      SubscribeRequest(
        lookups: [
          'type:' + ConversationCreatedType,
        ],
      ),
    );
    Stream<String> sub = Nimona.pop(subKey);
    await for (final objectBody in sub) {
      try {
        final NimonaTyped object = unmarshal(objectBody);
        if (object is conversation_created.ConversationCreated) {
          yield object;
        }
      } catch (e) {
        print('ERROR unmarshaling conversation created object, err=' +
            e.toString());
        throw e;
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
        metadataM: MetadataM(
          datetimeS: DateTime.now().toIso8601String(),
          ownerS: '@peer',
        ),
      );
      await Nimona.put(c.toJson());
    } catch (e) {
      print('ERROR putting conversationCreated, err=' + e.toString());
      throw e;
    }
  }

  @override
  Future<StreamController<NimonaTyped>> getMessagesForConversation(
    String conversationId,
    int limit,
    int offset,
  ) async {
    GetRequest req = GetRequest(
      limit: limit,
      offset: offset,
      lookups: [
        'stream:' + conversationId,
      ],
      orderBy: 'MetadataDatetime',
      orderDir: 'ASC',
    );
    final objectBodies = await Nimona.get(req);
    var ctrl = StreamController<NimonaTyped>();
    for (final objectBody in objectBodies) {
      try {
        final NimonaTyped object = unmarshal(objectBody);
        ctrl.add(object);
      } catch (e) {
        print('ERROR unmarshaling typed message object, err=' + e.toString());
      }
    }
    return ctrl;
  }

  @override
  Future<StreamController<NimonaTyped>> subscribeToMessagesForConversation(
    String conversationId,
  ) async {
    final subKey = await Nimona.subscribe(
      SubscribeRequest(
        lookups: [
          'stream:' + conversationId,
        ],
      ),
    );
    var ctrl = StreamController<NimonaTyped>(
      onCancel: () async {
        await Nimona.cancel(subKey);
      },
    );
    Stream<String> sub = Nimona.pop(subKey);
    sub.listen((objectBody) {
      try {
        final NimonaTyped object = unmarshal(objectBody);
        ctrl.add(object);
      } catch (e) {
        print('ERROR unmarshaling typed message object, err=' + e.toString());
      }
    });
    return ctrl;
  }

  @override
  Future<StreamController<NimonaTyped>> subscribeToMessages() async {
    final subKey = await Nimona.subscribe(
      SubscribeRequest(
        lookups: [
          'type:' + ConversationMessageAddedType,
          'type:' + ConversationTopicUpdatedType,
        ],
      ),
    );
    var ctrl = StreamController<NimonaTyped>(
      onCancel: () async {
        await Nimona.cancel(subKey);
      },
    );
    Stream<String> sub = Nimona.pop(subKey);
    sub.listen((objectBody) {
      try {
        final NimonaTyped object = unmarshal(objectBody);
        ctrl.add(object);
      } catch (e) {
        print('ERROR unmarshaling typed message object, err=' + e.toString());
      }
    });
    return ctrl;
  }

  @override
  Future<void> createMessage(String conversationCID, String body) async {
    try {
      final c = conversation_message_added.ConversationMessageAdded(
        metadataM: MetadataM(
          streamS: conversationCID,
          ownerS: '@peer',
          datetimeS: DateTime.now().toUtc().toIso8601String(),
        ),
        dataM: conversation_message_added.DataM(
          bodyS: body,
        ),
      );
      await Nimona.put(c.toJson());
    } catch (e) {
      print('ERROR putting conversationCreated, err=' + e.toString());
      throw e;
    }
  }

  @override
  Future<void> updateNickname(String conversationCID, String nickname) async {
    try {
      final event = ConversationNicknameUpdated(
        metadataM: MetadataM(
          datetimeS: DateTime.now().toUtc().toIso8601String(),
          ownerS: '@peer',
          streamS: conversationCID,
        ),
        dataM: DataM(
          nicknameS: nickname,
        ),
      );
      await Nimona.put(event.toJson());
    } catch (e) {
      print('ERROR putting updateNickname, err=' + e.toString());
      throw e;
    }
  }

  @override
  Future<void> updateTopic(String conversationCID, String topic) async {
    try {
      final event = ConversationTopicUpdated(
        metadataM: MetadataM(
          datetimeS: DateTime.now().toUtc().toIso8601String(),
          ownerS: '@peer',
          streamS: conversationCID,
        ),
        dataM: ConversationTopicUpdatedDataM(
          topicS: topic,
        ),
      );
      await Nimona.put(event.toJson());
    } catch (e) {
      print('ERROR putting updateTopic, err=' + e.toString());
      throw e;
    }
  }
}
