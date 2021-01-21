import 'package:flutterapp/event/conversation_created.dart';
import 'package:flutterapp/event/conversation_message_added.dart';
import 'package:flutterapp/event/conversation_nickname_updated.dart';
import 'package:flutterapp/event/conversation_subscription.dart';
import 'package:flutterapp/event/nimona_basic_object.dart';
import 'package:flutterapp/event/nimona_typed.dart';

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
      return ConversationSubscription.fromJson(body);
    default:
      throw ('unknown object type');
  }
}
