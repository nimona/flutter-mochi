import 'dart:async';
import 'dart:math';

import 'package:mochi/data/datastore.dart';
import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/nimona_connection_info.dart';
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/utils.dart';

final List<String> mockEvents = [
  '{"data:m":{"nonce:s":"hello-world!!1"},"metadata:m":{},"type:s":"stream:poc.nimona.io/conversation","_hash:s":"oh1.2rA8iDpuVpTS3WDeG7LLQWGUtzrgw9xHgGAVHPafnCTo"}',
];

final List<String> mockConversationEvents = [
  // '{"data:m":{"expiry:s":"","rootHashes:ar":["oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"]},"metadata:m":{"owner:s":"ed25519.DrKSCKD8HXXiDkGjhYYz54ihtGco4EHHUfzQ5Fp5r6Qv","parents:as":["oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"nimona.io/stream.Subscription"}',
  '{"data:m":{"body:s":"a. hello world","datetime:s":"2021-01-20T22:36:56Z"},"metadata:m":{"_signature:m":{"alg:s":"OH_ES256","signer:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","x:d":"LD3O1BVnf3qv3ZwbajlpTcOQMwXbYx2oLoN/Gb+7jVane3NvylJcCOM1Yo6WiAJ7NuLViUUDVhK8VKD/p/uhCg=="},"owner:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","parents:as":["oh1.Hc87Lz67wW9qL391hjAPaSQmxDQdb5Ug8ki6hg1XJ5VQ"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
  // '{"data:m":{"expiry:s":"","rootHashes:ar":["oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"]},"metadata:m":{"_signature:m":{"alg:s":"OH_ES256","signer:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","x:d":"mkb/iRn5B+H/vulye8kC3J/lr5TwOPPDnkCwr0DzpjNa8/ppvbLtZmdQwcakC65UOd+x//hyD31+Fw/KNxZjCw=="},"owner:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","parents:as":["oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"nimona.io/stream.Subscription"}',
  '{"data:m":{"body:s":"b. hi","datetime:s":"2021-01-20T22:37:20Z"},"metadata:m":{"owner:s":"ed25519.DrKSCKD8HXXiDkGjhYYz54ihtGco4EHHUfzQ5Fp5r6Qv","parents:as":["oh1.53aSh3q7CxzWWJFeyeqD3EDGUQjokKSHyGjQHgvHNZi","oh1.AgdATFJqtoYuW7uJ4rTgH1FBFVTHvro1zVTxhXgnyfd6"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
  '{"data:m":{"body:s":"c. woo","datetime:s":"2021-01-20T22:37:25Z"},"metadata:m":{"_signature:m":{"alg:s":"OH_ES256","signer:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","x:d":"KAIFX4bFc2wBBwMIDnjZbOuRjhW/PSkNcmyEV3s3BLbTiBBsnBgRCXfnVyRpUokhzNN1ArzHhqEq1fcZK++DBg=="},"owner:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","parents:as":["oh1.Uwg6Jogmt2ZynhTLNCvV7aeHPPxNgsT2ZNgex8nWHAx","oh1.Uwg6Jogmt2ZynhTLNCvV7aeHPPxNgsT2ZNgex8nWHAx"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
  '{"data:m":{"body:s":"d. I\'m chaning names","datetime:s":"2021-01-20T22:37:31Z"},"metadata:m":{"owner:s":"ed25519.DrKSCKD8HXXiDkGjhYYz54ihtGco4EHHUfzQ5Fp5r6Qv","parents:as":["oh1.4NSiiEEfk1pnvjfsMSEV82dt2VT76fywX4PpAtQSBWqe"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
  '{"data:m":{"datetime:s":"2021-01-20T22:37:35Z","nickname:s":"b"},"metadata:m":{"owner:s":"ed25519.DrKSCKD8HXXiDkGjhYYz54ihtGco4EHHUfzQ5Fp5r6Qv","parents:as":["oh1.Fch19giY4eJ2oab438zVBovCPVhqzwmNMFKpyRccjnAc"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.NicknameUpdated"}',
  '{"data:m":{"body:s":"e. Hello b, I\'m a","datetime:s":"2021-01-20T22:37:48Z"},"metadata:m":{"_signature:m":{"alg:s":"OH_ES256","signer:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","x:d":"E0pzsbgw/tSzXMhCEZYhZNSWfBo4IfX+8UNe/R/gerH73llYVf92mUXosuQRnoDydzhQSLX+F1YBYmEQryQqDw=="},"owner:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","parents:as":["oh1.2c1GAijydVosNC4ej3inL134RuaAZNzh8Z59bT4rCqLs"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
  '{"data:m":{"datetime:s":"2021-01-20T22:37:52Z","nickname:s":"a"},"metadata:m":{"_signature:m":{"alg:s":"OH_ES256","signer:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","x:d":"yWMngnq1HJralcHXyezjLyS6YyjgSA2xiZ4By9PpIYpuRcr7AobO4+umGLY2NccADBW/j0PhG/8A5J/3U+jaBw=="},"owner:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","parents:as":["oh1.ChXixA5M7KNgC5MV7nmp5xZsCH8nRwcAZmPUTHVrgyrb"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.NicknameUpdated"}',
  '{"data:m":{"body:s":"f. heelo a","datetime:s":"2021-01-20T22:38:01Z"},"metadata:m":{"owner:s":"ed25519.DrKSCKD8HXXiDkGjhYYz54ihtGco4EHHUfzQ5Fp5r6Qv","parents:as":["oh1.9TxJh9bixDX1xXtYF9Pi9py2t6iaqjtCqg2JcGYmeukP"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
  '{"data:m":{"body:s":"g. :D","datetime:s":"2021-01-20T23:48:19Z"},"metadata:m":{"_signature:m":{"alg:s":"OH_ES256","signer:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","x:d":"5SmVI3T+CWHLd5y85wGYHHIf92iymUivS8Z7OFRy8c2w7Fu8wF6gdsyQotGC9yCzt1n3Vd7xyLq14JJrFTwiBQ=="},"owner:s":"ed25519.F9zL12SmEJXbWHoYgwG7UUhGLJAwtpzBc8cT72fbA9eF","parents:as":["oh1.85j6PPACTiRxGAJs3a6X3oC5U3y6J3n68BMNyrTuBG19"],"stream:s":"oh1.3aYaYKrEaDe9oJGbrDxfDcnJpnSsSe3VZ5U2WqrDRhzh"},"type:s":"poc.nimona.io/conversation.MessageAdded"}',
];

class MockDataStore implements DataStore {
  @override
  Future<void> init() async {}

  @override
  Future<ConnectionInfo> getConnectionInfo() async {}

  @override
  Future<void> joinConversation(
    String conversationRootHash,
  ) async {}

  @override
  Future<void> refreshConversation(
    String conversationRootHash,
  ) async {}

  @override
  Stream<ConversationCreated> getConversations(
    int limit,
    int offset,
  ) {}

  @override
  Stream<ConversationCreated> subscribeToConversations() async* {
    for (var eventBody in mockEvents) {
      try {
        await Future.delayed(
          Duration(
            milliseconds: Random().nextInt(5000) + 1000,
          ),
        );
        final ConversationCreated event =
            ConversationCreated.fromJson(eventBody);
        yield event;
      } catch (e) {
        // TODO log error
        print("ERROR unmarshaling conversationCreated object, err=" +
            e.toString());
      }
    }
  }

  @override
  Future<void> createConversation(String name, String topic) async {
    return;
  }

  @override
  Future<StreamController<NimonaTyped>> getMessagesForConversation(
    String conversationId,
    int limit,
    int offset,
  ) {}

  @override
  Future<StreamController<ConversationMessageAdded>> subscribeToMessages() async {}

  @override
  Future<StreamController<NimonaTyped>> subscribeToMessagesForConversation(
    String conversationId,
  ) {
    // for (var eventBody in mockConversationEvents) {
    //   try {
    //     await Future.delayed(
    //       Duration(
    //         milliseconds: Random().nextInt(5000) + 1000,
    //       ),
    //     );
    //     final event = unmarshal(eventBody);
    //     yield event;
    //   } catch (e) {
    //     // TODO log error
    //     print("ERROR unmarshaling typed object, err=" + e.toString());
    //   }
    // }
  }

  @override
  Future<void> createMessage(String conversationHash, String body) async {
    return;
  }
}
