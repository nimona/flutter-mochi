import 'dart:async';

import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/conversation_nickname_updated.dart';
import 'package:mochi/event/nimona_stream_subscription.dart';
import 'package:mochi/event/nimona_basic_object.dart';
import 'package:mochi/event/nimona_typed.dart';

NimonaTyped unmarshal(String body) {
  final typed = BasicObject.fromJson(body);
  switch (typed.typeS) {
    case 'stream:poc.nimona.io/conversation':
      return ConversationCreated.fromJson(body);
    case 'poc.nimona.io/conversation.NicknameUpdated':
      return ConversationNicknameUpdated.fromJson(body);
    case 'poc.nimona.io/conversation.MessageAdded':
      return ConversationMessageAdded.fromJson(body);
    case 'nimona.io/stream.Subscription':
      return StreamSubscription.fromJson(body);
    default:
      throw ('unknown object type');
  }
}
