import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/some_function.dart';
import 'package:queschat/home/home/home_events.dart';
import 'package:queschat/main.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/router/app_router.dart';

DatabaseReference reference = FirebaseDatabase.instance.reference();
int i = 0;
//
initializeNotifications(BuildContext context) {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'basic_channel',
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
          ]);
    }
  });
  setupInteractedMessage(context);
//
  getFirebaseMessagingToken();
}

//
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  displayMessage(message);
}

Future<String> getFirebaseMessagingToken() async {
  String firebaseMessagingToken = await FirebaseMessaging.instance.getToken();
  print('fcm : ' + firebaseMessagingToken);
  return firebaseMessagingToken;
}

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

Future<void> setupInteractedMessage(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('notification  onMessage Listen');

    displayMessage(message);
  });

  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage message) async {
    print('notification  initialMessage');
    if (message != null) {
      Map<String, dynamic> messageData = message.data;

      notificationAction(messageData, 2);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('notification  onMessageOpenedApp');
    if (message != null) {
      Map<String, dynamic> messageData = message.data;

      notificationAction(messageData, 1);
    }
  });
  AwesomeNotifications()
      .actionStream
      .listen((ReceivedNotification receivedNotification) {
    print('notification action stream');
    print(receivedNotification.payload);
    // print(receivedNotification.);
    notificationAction(receivedNotification.payload, 0);
  });
}

Future<void> displayMessage(RemoteMessage message) async {
  // AwesomeNotifications().
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    print('notification start display  ${message.data}');

    Map<String, String> data = {};
    message.data.forEach((key, value) {
      data.addAll({key: value.toString()});
    });

    if (!isAllowed) {
      print('notification display permission not allowed');

      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'basic_channel',
          permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Sound,
          ]);
    } else {
      if (data['type'] == 'message_room') {
        if (!activeMessageRoomIds.contains(data['message_room_id']))
        {
          if (data['message_room_type'] == 'chat') {

            if(data['sender_id']!=AppData().userId) {
              UserContactModel userContactModel = await authRepository
                  .getDetailsOfSelectedUser(data['sender_id'], 'any');

              AwesomeNotifications().createNotification(
                content: NotificationContent(
                    channelKey: 'basic_channel',
                    id: getAlphabetOrderNumberFromString(
                        data['message_room_id']),
                    groupKey: data['message_room_id'],
                    summary: userContactModel.name,
                    title: userContactModel.name,
                    body: data['body_message'],
                    payload: data,
                    roundedLargeIcon: true,
                    largeIcon: userContactModel.profilePic!=null?userContactModel.profilePic:'assets/user_profile.png',

                    notificationLayout: NotificationLayout.Messaging,
                    category: NotificationCategory.Message),
              );

              print('notification start displayed');
            }
          } else {
            DatabaseReference reference = FirebaseDatabase.instance.reference();
            UserContactModel userContactModel = await authRepository
                .getDetailsOfSelectedUser(data['sender_id'], 'any');
            reference
                .child(data['message_room_type'] == 'channel'
                    ? 'ChannelRooms'
                    : 'ChatRooms')
                .child(data['message_room_id'])
                .child('info')
                .once()
                .then((value) {
              var map = value.value;
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                    channelKey: 'basic_channel',
                    id: getAlphabetOrderNumberFromString(
                        data['message_room_id']),
                    groupKey: data['message_room_id'],
                    summary: map['name'],
                    title: userContactModel.name,
                    body: data['body_message'],
                    roundedLargeIcon: true,
                    payload: data,
                    largeIcon:data['icon_url']!=null? Urls().serverAddress+data['icon_url']:'',
                    // largeIcon:
                    //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiB88zjt7Xh0zNX6WIi_LBVjklAhUBzhRZtg&usqp=CAU',
                    notificationLayout: NotificationLayout.MessagingGroup,
                    category: NotificationCategory.Message),
              );
              print('notification start displayed');
            });
          }
        }
      } else{
        // if (data['type'] == 'comment' || data['type'] == 'comment')

          AwesomeNotifications().createNotification(
          content: NotificationContent(
              channelKey: 'basic_channel',
              id: getAlphabetOrderNumberFromString(data['connection_id']),
              title: data['user_name'],
              body: data['body_message'],
              payload: data,
              roundedLargeIcon: true,
              // largeIcon: chatRoomModel.imageUrl,
              largeIcon:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiB88zjt7Xh0zNX6WIi_LBVjklAhUBzhRZtg&usqp=CAU',
              notificationLayout: NotificationLayout.Default,
              category: NotificationCategory.Social),
        );
      }
    }
  });
}

notificationAction(Map<String, dynamic> messageData, int delay) async {
  if (messageData != null && messageData['type'] != null) {
    String messageType = messageData['type'];
    if (messageType == 'message_room') {
      homeBloc.add(ChangeTab(0));
      if (messageData['messageRoomType'] == 'channel') {
        messageHomeBloc.add(ChangeTab(1));
      } else {
        messageHomeBloc.add(ChangeTab(1));
      }
      Navigator.pushNamed(
        MyApp.navigatorKey.currentContext,
        '/messageRoom',
        arguments: {
          'parentPage': messageData['message_room_type'] == 'channel'
              ? 'notificationChannel'
              : 'notificationAllChat',
          'chatRoomModel': ChatRoomModel(id: messageData['message_room_id'])
        },
      );
    } else  {
      // if (messageType == 'comment' || messageType == 'like')
      Navigator.pushNamed(
        MyApp.navigatorKey.currentContext,
        '/feedSingleView',
        arguments: {
          'parentPage': 'notification',
          'feedID': messageData['feed_id']
        },
      );
      if (messageType == 'comment') {
        // Navigator.pushNamed(
        //   MyApp.navigatorKey.currentContext,
        //   '/feedSingleView',
        //   arguments: {
        //     'parentPage': 'notification',
        //     'feedID': messageData['feed_id']
        //   },
        // );
      }
    }
  }
}
