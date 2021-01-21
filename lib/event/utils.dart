import 'dart:convert';

import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/event/conversation_message_added.dart';
import 'package:flutterapp/event/conversation_nickname_updated.dart';
import 'package:flutterapp/event/conversation_subscription.dart';
import 'package:flutterapp/event/nimona_basic_object.dart';
import 'package:flutterapp/event/nimona_typed.dart';

NimonaTyped unmarshal(String body) {
  final json = jsonDecode(body);
  final typed = BasicObject.fromJson(json);
  switch (typed.typeS) {
    case 'stream:poc.nimona.io/conversation':
      return ConversationCreated.fromJson(json);
    case 'poc.nimona.io/conversation.NicknameUpdated':
      return ConversationNicknameUpdated.fromJson(json);
    case 'poc.nimona.io/conversation.MessageAdded':
      return ConversationMessageAdded.fromJson(json);
    case 'nimona.io/stream.Subscription':
      return ConversationSubscription.fromJson(json);
    default:
      throw ('unknown object type');
  }
}
