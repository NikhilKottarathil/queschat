import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:queschat/home/home/home_events.dart';
import 'package:queschat/main.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/router/app_router.dart';
import 'package:share_plus/share_plus.dart';

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

Future generateMessageRoomDynamicLink({String id, String messageRoomType}) {
  String queryParameters =
      'linkType=messageRoom&id=$id&messageRoomType=$messageRoomType';
  return generateDynamicLink(queryParameters: queryParameters);
}

Future generateFeedDynamicLink({String id}) {
  String queryParameters = 'linkType=feed&id=$id';
  return generateDynamicLink(queryParameters: queryParameters);
}

Future generateDynamicLink({String queryParameters}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    // The Dynamic Link URI domain. You can view created URIs on your Firebase console
    uriPrefix: 'https://queschat.page.link',
    // The deep Link passed to your application which you can use to affect change
    link: Uri.parse('https://queschat.com?$queryParameters'),

    // Android application details needed for opening correct app on device/Play Store
    androidParameters: const AndroidParameters(
      packageName: 'com.hamrut.queschat',
      minimumVersion: 1,
    ),
    // iOS application details needed for opening correct app on device/App Store
    // iosParameters: const IOSParameters(
    //   bundleId: iosBundleId,
    //   minimumVersion: '2',
    // ),
  );

  final Uri uri = await dynamicLinks.buildLink(parameters);
  Share.share(uri.toString());
}

listenDynamicLink(BuildContext context) async {
  var data;
  if (Platform.isIOS) {
    await Future.delayed(Duration(seconds: 2), () async {
      data = await FirebaseDynamicLinks.instance.getInitialLink();
    });
  } else {
    data = await FirebaseDynamicLinks.instance.getInitialLink();
  }
  print('DynamicLinks   $data');
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    print('DynamicLinks data  ${dynamicLinkData.link.queryParameters}');
    Map<String, String> queryParameters = dynamicLinkData.link.queryParameters;
    if (queryParameters['linkType'] == 'messageRoom') {
      homeBloc.add(ChangeTab(0));
      if (queryParameters['messageRoomType'] == 'channel') {
        messageHomeBloc.add(ChangeTab(1));
      } else {
        messageHomeBloc.add(ChangeTab(1));
      }
      Navigator.pushNamed(
        context,
        '/messageRoom',
        arguments: {
          'parentPage': queryParameters['messageRoomType'] == 'channel'
              ? 'dynamicLinkChannel'
              : 'dynamicLinkGroup',
          'chatRoomModel': ChatRoomModel(id: queryParameters['id'])
        },
      );
    }
    if (queryParameters['linkType'] == 'feed') {

      Navigator.pushNamed(
        context,
        '/feedSingleView',
        arguments: {
          'parentPage': 'dynamicLink',
          'feedId':  queryParameters['id']
        },
      );
    }
  }).onError((error) {
    // Handle errors
    print('DynamicLinks error $error');
  });
}
