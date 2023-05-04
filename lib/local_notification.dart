import 'dart:developer';
import 'dart:io';

import 'package:fcm_demo_4/screens/screen_three.dart';
import 'package:fcm_demo_4/screens/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

void notificationTapBackground(NotificationResponse notificationResponse) {
  print(" ---------- notificationTapBackground ---------- ");
}

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool? notificationPermissionStatus;

  initNotification() async {
    if (notificationPermissionStatus != true) {
      notificationPermissionStatus = await _requestPermissions();
    }
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_notification');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print(
            "---- ${notificationResponse.payload} ${notificationResponse.payload != null}");
        if (notificationResponse.payload != null) {
          print(" ----- Payload found ----- ");
          _handleMessage(notificationResponse.payload!);
        } else {
          print(" ----- Payload not found ----- ");
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  void _handleMessage(String message) {
    print(" ----- _handleMessage ----- ");
    if (message.contains('navigate_to: screenTwo')) {
      Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => const ScreenTwo(),
        ),
      );
    } else if (message.contains('navigate_to: screenThree')) {
      Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => const ScreenThree(),
        ),
      );
    } else {
      log(" *--- Screen not Found ---");
    }
  }

  Future<bool?> _requestPermissions() async {
    if (Platform.isIOS) {
      notificationPermissionStatus = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      notificationPermissionStatus =
          await androidImplementation?.requestPermission();
    }
    return notificationPermissionStatus;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String payload = "Hello",
  }) async {
    print("-------- $payload");
    notificationPermissionStatus = true;
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "proctoringNotificationChannelId",
      "proctoringNotificationChannelName",
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void removeNotification({required int id}) {
    if (notificationPermissionStatus != true) return;
    flutterLocalNotificationsPlugin.cancel(id);
  }

  void removeAllNotification() {
    if (notificationPermissionStatus != true) return;
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
