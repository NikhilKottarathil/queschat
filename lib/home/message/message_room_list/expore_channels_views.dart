import 'package:flutter/material.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_view.dart';
import 'package:queschat/uicomponents/appbars.dart';

class ExploreChannelsView extends StatelessWidget {
  const ExploreChannelsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWithBackButton(
            context: context, titleString: 'Explore Channels'),
        body: MessageRoomListView());
  }
}
