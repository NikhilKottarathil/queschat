// import 'dart:convert';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:queschat/constants/styles.dart';
// import 'package:queschat/function/some_function.dart';
// import 'package:queschat/home/home/home_events.dart';
// import 'package:queschat/main.dart';
// import 'package:queschat/models/chat_room_model.dart';
// import 'package:queschat/router/app_router.dart';
//
//
//  initializeNotifications() {
// const AndroidInitializationSettings initializationSettingsAndroid =
// AndroidInitializationSettings('@mipmap/ic_launcher');
// final IOSInitializationSettings initializationSettingsIOS =
// IOSInitializationSettings();
// final MacOSInitializationSettings initializationSettingsMacOS =
// MacOSInitializationSettings();
// final InitializationSettings initializationSettings =
// InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//     macOS: initializationSettingsMacOS);
//
// flutterLocalNotificationsPlugin.initialize(initializationSettings,
// onSelectNotification: selectNotification);
//
// setupInteractedMessage(context);
//
// getFirebaseMessagingToken();
// }
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   displayMessage(message);
// }
//
// AndroidNotificationChannel androidNotificationChannel =
//     const AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// Future<String> getFirebaseMessagingToken() async {
//   String firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
//   print('fcm : ' + firebaseMessagingToken);
//   return 'firebaseMessagingToken';
// }
//
// Future<dynamic> selectNotification(String payload) async {
//   print('notification  selectNotification');
//   print(payload);
//   if (payload.isNotEmpty) {
//     Map<String, dynamic> messageData = json.decode(payload);
//
//     notificationAction(messageData, 0);
//   }
// }
//
// Future<void> setupInteractedMessage(BuildContext context) async {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     displayMessage(message);
//   });
//
//
//   FirebaseMessaging.instance
//       .getInitialMessage()
//       .then((RemoteMessage message) async {
//     print('notification  initialMessage');
//     if (message != null) {
//       Map<String, dynamic> messageData = message.data;
//
//       notificationAction(messageData, 2);
//     }
//   });
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     print('notification  onMessageOpenedApp');
//     if (message != null) {
//       Map<String, dynamic> messageData = message.data;
//
//       notificationAction(messageData, 1);
//     }
//   });
// }
//
// Future<void> displayMessage(RemoteMessage message) async {
//   final List<ActiveNotification> activeNotifications =
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.getActiveNotifications();
//   print(activeNotifications.length);
//
//   // activeNotifications.forEach((element) {
//   //   element.id==
//   // });
//   print('notification onMessage');
//   print(message.notification);
//
//   print(message.data);
//   print(message.senderId);
//
//   String title =
//       await authRepository.getNameOfSelectedUserByContact(message.data['body']);
//   // RemoteNotification notification = message.notification;
//   // AndroidNotification android = message.notification?.android;
//   // if (notification != null && android != null && !kIsWeb) {
//     if (message.data['type'] == 'message_room') {
//       if (currentMessageRoomId != message.data['message_room_id']) {
//         const List<String> lines = <String>[
//           'Alex Faarborg  Check this out',
//           'Jeff Chang    Launch Party'
//         ];
//         const InboxStyleInformation inboxStyleInformation =
//             InboxStyleInformation(lines,
//                 contentTitle: '2 messages', summaryText: 'janedoe@example.com');
//         flutterLocalNotificationsPlugin
//             .show(
//                 getAlphabetOrderNumberFromString(
//                     message.data['message_room_id']),
//                 //   0,
//                 message.data['title'],
//                 message.data['body'],
//                 NotificationDetails(
//                   android: AndroidNotificationDetails(
//                     androidNotificationChannel.id,
//                     androidNotificationChannel.name,
//                     androidNotificationChannel.description,
//                     importance: Importance.max,
//                     priority: Priority.high,
//                     // groupKey: title,
//                     // setAsGroupSummary: false,
//
//
//                     // styleInformation: inboxStyleInformation,
//                     // TODO add a proper drawable resource to android, for now using
//                     //      one that already exists in example app.
//                   ),
//                 ),
//                 payload: json.encode(message.data))
//             .whenComplete(() => print('notification complete'))
//             .then((value) => print('notification then'));
//       }
//     }
//   // }
// }
//
// notificationAction(Map<String, dynamic> messageData, int delay) async {
//   print('notificationAction');
//   print(messageData);
//   homeBloc.add(ChangeTab(0));
//
//   if (messageData != null && messageData['type'] != null) {
//     String messageType = messageData['type'];
//     if (messageType == 'message_room') {
//       homeBloc.add(ChangeTab(1));
//       if (messageData['messageRoomType'] == 'channel') {
//         messageHomeBloc.add(ChangeTab(1));
//       } else {
//         messageHomeBloc.add(ChangeTab(1));
//       }
//       Navigator.pushNamed(
//         MyApp.navigatorKey.currentContext,
//         '/messageRoom',
//         arguments: {
//           'parentPage': messageData['message_room_type'] == 'channel'
//               ? 'notificationChannel'
//               : 'notificationAllChat',
//           'chatRoomModel': ChatRoomModel(id: messageData['message_room_id'])
//         },
//       );
//     }
//   }
// }
