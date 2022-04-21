import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/home/home_state.dart';
import 'package:queschat/home/message/message_home/message_home_bloc.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_view.dart';
import 'package:queschat/router/app_router.dart';

class MessageHomeView extends StatefulWidget {
  @override
  State<MessageHomeView> createState() => _MessageHomeViewState();
}

class _MessageHomeViewState extends State<MessageHomeView>
    with AutomaticKeepAliveClientMixin<MessageHomeView>
{
  var tabs = [
    BlocProvider(
      create: (context) => allChatMessageRoomListBloc,
      child: MessageRoomListView(),
    ),
    BlocProvider(
      create: (context) => channelMessageRoomListBloc,
      child: MessageRoomListView(),
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageHomeBloc(),
      child: Scaffold(
        body: BlocBuilder<MessageHomeBloc, HomeState>(
          builder: (context, state) {
            print('HOME message BUILDED ${state.tabIndex}');
            return DefaultTabController(
              length: 2,
              initialIndex: state.tabIndex,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: TabBar(
                    unselectedLabelColor:
                        AppColors.TextSecondary.withOpacity(.5),
                    labelColor: AppColors.TextSecondary,
                    indicatorColor: AppColors.PrimaryColor,
                    indicatorSize: TabBarIndicatorSize.values[1],
                    tabs: [
                      Tab(
                        icon: Text(
                          "All Chats",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Tab(
                          icon: Text(
                        "Channels",
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  ),
                ),
                body: TabBarView(children: tabs),
              ),
            );
          },
        ),
      ),
    );
  }
}
