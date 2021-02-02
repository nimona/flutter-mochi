import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

// const MethodChannel platform =
//     MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

class Notifier {
  static final Notifier _notifier = new Notifier._internal();

  static Notifier get() {
    return _notifier;
  }

  Notifier._internal() {
    () async {
      // final NotificationAppLaunchDetails notificationAppLaunchDetails =
      //     await flutterLocalNotificationsPlugin
      //         .getNotificationAppLaunchDetails();

      const MacOSInitializationSettings initializationSettingsMacOS =
          MacOSInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true);
      final InitializationSettings initializationSettings =
          InitializationSettings(macOS: initializationSettingsMacOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
      });
    }();
  }

  Future<void> showNotification(
    String title,
    String subtitle,
    String payload,
  ) async {
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      subtitle: 'the subtitle',
    );
    const macOSPlatformChannelSpecifics = MacOSNotificationDetails(
      subtitle: 'the subtitle',
    );
    const platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );
    final ms = (new DateTime.now()).millisecondsSinceEpoch;
    await flutterLocalNotificationsPlugin.show(
      (ms / 1000).round(),
      title,
      subtitle,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
