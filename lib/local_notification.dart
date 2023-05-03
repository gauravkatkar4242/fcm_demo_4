import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
        print(" ---------- onDidReceiveNotificationResponse ---------- ");
        print("id: ${notificationResponse.id}");
        print("actionId: ${notificationResponse.actionId}");
        print("input: ${notificationResponse.input}");
        print("payload: ${notificationResponse.payload}");
        print(
            "notificationResponseType: ${notificationResponse.notificationResponseType}");
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
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
    print("___");
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
