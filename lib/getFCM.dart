import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFCMToken() async {
  String? fcmKey = await FirebaseMessaging.instance.getToken();
  // save token
  return fcmKey;
}
