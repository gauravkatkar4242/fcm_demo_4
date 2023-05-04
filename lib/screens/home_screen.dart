import 'dart:developer';

import 'package:fcm_demo_4/screens/screen_three.dart';
import 'package:fcm_demo_4/screens/screen_two.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../getFCM.dart';
import '../local_notification.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    setupFcmListeners();
    LocalNotification().initNotification();
  }

  Future<void> setupFcmListeners() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen(_pushLocalNotification);

    // To display foreground notification in iOS
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true, // Required to display a heads up notification
    //   badge: true,
    //   sound: true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Home Screen',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getToken,
        child: const Center(child: Text("Get Token")),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> getToken() async {
    String? fcmKey = await getFCMToken();
    log("FCM key : $fcmKey");
  }

  void _handleMessage(RemoteMessage message) {
    print("--- _handleMessage ---");
    if (message.data['navigate_to'] == 'screenTwo') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ScreenTwo(),
        ),
      );
    } else if (message.data['navigate_to'] == 'screenThree') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ScreenThree(),
        ),
      );
    } else {
      log(" --- Screen ${message.data['navigate_to']} not Found ---");
    }
  }

  void _pushLocalNotification(RemoteMessage message) {
    log("--- message received on foreground - ${message.toMap().toString()}");
    if (message.notification != null) {
      LocalNotification().showNotification(
        id: 1,
        title: "${message.notification!.title ?? "NULL"} - Local",
        body: message.notification!.body ?? "Body",
        payload: message.toMap().toString(),
      );
    }
  }
}
