import 'dart:async';

import 'package:flutter/services.dart';

/// MochiMobile is the top-level object that can be used to interact
/// with the go-hash native API (written in Go).
/// It used Flutter's MethodChannels to call the native code.
class MochiMobile {
  static const MethodChannel _channel = const MethodChannel('mochi_mobile');

  /// startDaemon starts a mochi deamon if not already there.
  static Future<String> startDaemon() async {
    return await _channel.invokeMethod('startDaemon');
  }
}

// DateTime _timestamp(dynamic value) =>
//     new DateTime.fromMillisecondsSinceEpoch(value as int);

// /// MochiDb represents a go-hash database.
// class MochiDb {
//   final String filePath;
//   final List<Group> groups;

//   const MochiDb(this.filePath, this.groups);

//   /// Function that converts an untyped [Map] (received from native code)
//   /// into a [MochiDb] instance.
//   static MochiDb from(String filePath, Map<dynamic, dynamic> map) {
//     List<Group> groups = new List<Group>();
//     map.forEach((key, contents) {
//       List<dynamic> contentList = contents;
//       var entries = contentList.map((e) => LoginInfo.from(e)).toList();
//       groups.add(new Group(key.toString(), entries));
//     });
//     return new MochiDb(filePath, groups);
//   }
// }

// /// A group of [LoginInfo] entries in a [MochiDb].
// class Group {
//   final String name;
//   final List<LoginInfo> entries;

//   const Group(this.name, this.entries);
// }

// /// LoginInfo represents a single entry in a [MochiDb].
// class LoginInfo {
//   final String name, description, username, password, url;
//   final DateTime updatedAt;

//   const LoginInfo(this.name, this.description, this.username, this.password,
//       this.url, this.updatedAt);

//   /// Create a [LoginInfo] instance from an untyped [Map]
//   /// (received from native code).
//   LoginInfo.from(Map<dynamic, dynamic> map)
//       : name = map["name"] as String,
//         description = map['description'] as String,
//         username = map['username'] as String,
//         password = map['password'] as String,
//         url = map['url'] as String,
//         updatedAt = _timestamp(map['updatedAt']);
// }
