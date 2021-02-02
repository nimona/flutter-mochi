import 'dart:async';

import 'package:mochi/event/conversation_created.dart';
import 'package:mochi/event/conversation_message_added.dart';
import 'package:mochi/event/conversation_nickname_updated.dart';
import 'package:mochi/event/nimona_connection_info.dart';
import 'package:mochi/event/nimona_stream_subscription.dart';
import 'package:mochi/event/nimona_basic_object.dart';
import 'package:mochi/event/nimona_typed.dart';
import 'package:mochi/event/types.dart';

NimonaTyped unmarshal(String body) {
  final typed = BasicObject.fromJson(body);
  switch (typed.typeS) {
    case ConversationCreatedType:
      return ConversationCreated.fromJson(body);
    case ConversationNicknameUpdatedType:
      return ConversationNicknameUpdated.fromJson(body);
    case ConversationMessageAddedType:
      return ConversationMessageAdded.fromJson(body);
    case StreamSubscriptionType:
      return StreamSubscription.fromJson(body);
    case ConnectionInfoType:
      return connectionInfoFromJson(body);
    default:
      throw ('unknown object type');
  }
}
