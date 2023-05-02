// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import 'local_notification.dart';
//
// initFcmListeners() async {
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     print(
//         "------------------ on message Tapped  - ${message.toMap().toString()}");
//     print(message.toMap().toString());
//     if (message.notification!.android!.channelId == "channel1") {
//       print("*** channel 1 received ***");
//     } else {
//       print("*** channel 2 received ***");
//     }
//   });
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     print(
//         "------------------ on message received on foreground - ${message.toMap().toString()}");
//     if (message.notification != null) {
//       LocalNotification().showNotification(
//         id: 1,
//         title: "${message.notification!.title ?? "NULL"} - Local",
//         body: message.notification!.body ?? "Body",
//         payload: message.toMap().toString(),
//       );
//     }
//   });
//
//   //open notify content from terminated state of the app
//   FirebaseMessaging.instance.getInitialMessage().then((message) {
//     print(
//         "------------------ FirebaseMessaging.getInitialMessage: message : ${message?.toMap().toString()}");
//   });
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print(
//       "------------------ on message received on background - ${message.toMap().toString()}");
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.toMap().toString()}");
//   // if (message.notification != null) {
//   //   LocalNotification().showNotification(
//   //     id: 1,
//   //     title: "${message.notification!.title ?? "NULL"} - Local",
//   //     body: message.notification!.body ?? "Body",
//   //   );
//   // }
// }
