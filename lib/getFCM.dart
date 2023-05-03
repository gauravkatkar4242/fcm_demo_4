import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFCMTocken() async {
  String? fcmKey = await FirebaseMessaging.instance.getToken();
  return fcmKey;
}
