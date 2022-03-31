// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/app_exit_alert.dart';
import 'package:queschat/components/drawer.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/firebase_dynamic_link.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/home/home/home_bloc.dart';
import 'package:queschat/home/home/home_events.dart';
import 'package:queschat/home/home/home_state.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_view.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (context) => allChatMessageRoomListBloc,
        child: MessageRoomListView(),
      ),
      BlocProvider(
        create: (context) => channelMessageRoomListBloc,
        child: MessageRoomListView(),
      ),
      FeedsView(),
    ];
  }

  // List<BottomNavyBarItem> _navBarsItems = [
  //   BottomNavyBarItem(
  //     icon: Image.asset(
  //       'images/message_nav_icon.png',
  //       height: 22,
  //       width: 22,
  //     ),
  //     title: Text('All Chat'),
  //     activeColor: AppColors.PrimaryColorLight,
  //     inactiveColor:AppColors.IconColor,
  //   ),
  //   BottomNavyBarItem(
  //     icon: Image.asset(
  //       'images/message_nav_icon.png',
  //       height: 22,
  //       width: 22,
  //     ),
  //     title: Text('Channels'),
  //     activeColor: AppColors.PrimaryColorLight,
  //     inactiveColor:AppColors.IconColor,
  //   ),
  //   BottomNavyBarItem(
  //     icon: Image.asset(
  //       'images/message_nav_icon.png',
  //       height: 22,
  //       width: 22,
  //     ),
  //     title: Text('Feeds'),
  //     activeColor: AppColors.PrimaryColorLight,
  //     inactiveColor:AppColors.IconColor,
  //   ),
  // ];

  List<BottomNavigationBarItem> _navBarsItems = [
    BottomNavigationBarItem(
      icon: Image.asset(
        'images/message_nav_icon.png',
        color: AppColors.IconColor,
        height: 22,
        width: 22,
      ),
      label: '',
      activeIcon: Image.asset(
        'images/message_nav_icon.png',
        color: AppColors.SecondaryColor,
        height: 22,
        width: 22,
      ),
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'images/channel_nav_icon.png',
        color: AppColors.IconColor,
        height: 22,
        width: 22,
      ),
      activeIcon: Image.asset(
        'images/channel_nav_icon.png',
        color: AppColors.SecondaryColor,
        height: 22,
        width: 22,
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'images/feed_nav_icon.png',
        color: AppColors.IconColor,
        height: 22,
        width: 22,
      ),
      label: '',
      activeIcon: Image.asset(
        'images/feed_nav_icon.png',
        color: AppColors.SecondaryColor,
        height: 22,
        width: 22,
      ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    //
    WidgetsBinding.instance.addObserver(this);
    DatabaseReference infoReference =
        FirebaseDatabase.instance.reference().child('.info/connected');
    DatabaseReference userReference = FirebaseDatabase.instance
        .reference()
        .child('presence/${AppData().userId}');

    infoReference.onValue.listen((event) {
      userReference.onDisconnect().set(ServerValue.timestamp);

      userReference.set('online');
    });

    listenDynamicLink(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return appExitAlert(context);
      },
      child: Scaffold(
        appBar: homeAppBar(context),
        drawer: CustomDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            _tabController.animateTo(state.tabIndex,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
            print('HOME BUILDED ${state.tabIndex}');
            return TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: _buildScreens(),
            );
          },
        ),

        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.white,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.red,
              shadowColor: AppColors.ShadowColor,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.yellow))),
          child: BottomNavigationBar(
            // backgroundColor: AppColors.White,
            currentIndex: context.read<HomeBloc>().state.tabIndex,
            onTap: (index) => setState(() {
              context.read<HomeBloc>().add(ChangeTab(index));
            }),
            elevation: 5,
            type: BottomNavigationBarType.fixed,

            fixedColor: AppColors.White,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: _navBarsItems,
          ),
        ),
        // bottomNavigationBar: BottomNavyBar(
        //   backgroundColor: AppColors.White,
        //
        //   selectedIndex: context.read<HomeBloc>().state.tabIndex,
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   itemCornerRadius: 10,
        //   showElevation: true,
        //
        //   // use this to remove appBar's elevation
        //   onItemSelected: (index) => setState(() {
        //     context.read<HomeBloc>().add(ChangeTab(index));
        //   }),
        //   items: _navBarsItems,
        // ),
      ),
    );
  }
}
// bottomNavigationBar: BottomAppBar(
// shape: CircularNotchedRectangle(),
// notchMargin: 6,
// clipBehavior: Clip.antiAlias,
// child: BlocBuilder<HomeBloc, HomeState>(
// builder: (context, state) {
// return BottomNavigationBar(
//
// selectedFontSize: 0,
// elevation: 4,
// unselectedFontSize: 0,
// enableFeedback: false,
// landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
// currentIndex: state.tabIndex,
// showSelectedLabels: false,
// showUnselectedLabels: false,
// type: BottomNavigationBarType.fixed,
// onTap: (int index) {
// print('on homt tab tap');
// homeBloc.add(ChangeTab(index));
// },
// items: [
// BottomNavigationBarItem(
// icon: Image.asset(
// "images/feed_icon_inactive.png",
// height: 22,
// ),
// activeIcon: Image.asset(
// "images/feed_icon.png",
// height: 22,
// ),
// //  activeIcon: Container(
// //    color: AppColors().ChatPrimaryColor,
// //    child: Padding(
// //      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
// //
// //      child: Row(
// //        mainAxisSize: MainAxisSize.min,
// //        children: [
// //          Image.asset(
// //            "images/feed_icon_inactive.png",
// //            height: 22,
// //          ),
// //          SizedBox(
// //            width: 10,
// //          ),
// //          Text('Feeds')
// //        ],
// //      ),
// //    ),
// //  ),
// // size: MediaQuery.of(context).size.height * .035),
// label: "Feeds",
// ),
// BottomNavigationBarItem(
// icon: Image.asset(
// "images/ic_chat_inactive.png",
// height: 22,
// ),
// activeIcon: Image.asset(
// "images/ic_chat.png",
// height: 22,
// ),
// // activeIcon: Card(
// //   color: AppColors().ChatPrimaryColor,
// //   clipBehavior: Clip.hardEdge,
// //   child: Padding(
// //     padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
// //     child: Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Image.asset(
// //           "images/ic_chat_inactive.png",
// //           height: 22,
// //         ),
// //         SizedBox(
// //           width: 10,
// //         ),
// //         Text('Message')
// //       ],
// //     ),
// //   ),
// // ),
// label: "Message",
// ),
// ],
// );
// },
// ),
// ),
