import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:crypto/crypto.dart';
import "package:base58check/base58.dart";
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/model/conversation.dart';
import 'package:flutterapp/model/local_peer.dart';
import 'package:flutterapp/model/message.dart';
import 'package:flutterapp/model/participant.dart';
import 'dart:math';

import 'package:flutterapp/model/profile.dart';

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
      localAlias: faker.internet.userName(),
      nameFirst: faker.person.firstName(),
      nameLast: faker.person.lastName(),
    );
  }

  LocalPeer getLocalPeer() {
    return LocalPeer(
      key: hashString("2c3a8580-845c-4b92-9690-6fed980679fb"),
      profile: Profile(
        key: hashString("b179a62b-af67-493f-985d-b8590b087055"),
        localAlias: "me",
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
      localAlias: profile.localAlias,
      profile: profile,
    );
  }

  Message getMessage() {
    return Message(
      body: faker.lorem.sentence(),
      senderHash: getProfile().key,
      hash: hashString(faker.lorem.sentence()),
      sent: DateTime.now().subtract(Duration(seconds: rng.nextInt(100))).toIso8601String(),
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
      topic: faker.lorem.sentence(),
    );
  }
}
