import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:crypto/crypto.dart';
import "package:base58check/base58.dart";
import 'package:mochi/model/contact.dart';
import 'package:mochi/model/conversation.dart';
import 'package:mochi/model/local_peer.dart';
import 'package:mochi/model/message.dart';
import 'package:mochi/model/participant.dart';
import 'dart:math';

import 'package:mochi/model/profile.dart';

const String _bitcoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

class Fake {
  static final Fake _faker = new Fake._internal();

  static Fake get() {
    return _faker;
  }

  Fake._internal() {
    // init
  }

  Base58Codec codec = const Base58Codec(_bitcoinAlphabet);
  Random rng = new Random();

  String hashString(String key) {
    var bytes = utf8.encode(key);
    var digest = sha1.convert(bytes);
    return codec.encode(digest.bytes).toString();
  }

  Profile getProfile() {
    return Profile(
      key: hashString(faker.guid.guid()),
      displayPicture: "https://picsum.photos/250",
      nameFirst: faker.person.firstName(),
      nameLast: faker.person.lastName(),
    );
  }

  LocalPeer getLocalPeer() {
    return LocalPeer(
      key: hashString("2c3a8580-845c-4b92-9690-6fed980679fb"),
      profile: Profile(
        key: hashString("b179a62b-af67-493f-985d-b8590b087055"),
        nameFirst: "John",
        nameLast: "Doe",
        displayPicture: "https://picsum.photos/250",
      ),
    );
  }

  Contact getContact() {
    var profile = getProfile();
    return Contact(
      key: profile.key,
      alias: faker.internet.userName(),
      profile: profile,
    );
  }

  Message getMessage() {
    var profile = getProfile();
    return Message(
      body: faker.lorem.sentence(),
      participant: Participant(
        key: profile.key,
        profile: profile,
      ),
      hash: hashString(faker.lorem.sentence()),
      sent: DateTime.now().subtract(Duration(seconds: rng.nextInt(100))),
      isEdited: rng.nextBool(),
    );
  }

  Participant getParticipant() {
    var profile = getProfile();
    var type = ParticipantType.USER;
    switch (rng.nextInt(7)) {
      case 1:
        type = ParticipantType.ADMINISTRATOR;
        break;
      case 2:
        type = ParticipantType.MODERATOR;
        break;
    }
    return Participant(
      key: profile.key,
      profile: profile,
      type: type,
    );
  }

  Conversation getConversation() {
    List<Message> messages = [];
    for (var i = 0; i < rng.nextInt(3); i++) {
      messages.add(getMessage());
    }
    return Conversation(
      hash: hashString(faker.guid.guid()),
      name: faker.lorem.sentence(),
      lastMessage: DateTime.now().subtract(Duration(seconds: rng.nextInt(1000))),
      topic: faker.lorem.sentence(),
      unreadMessagesLatest: messages,
      unreadMessagesCount: messages.length,
      displayPicture: "https://picsum.photos/500",
    );
  }
}
