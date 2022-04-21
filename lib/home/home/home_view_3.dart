import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/app_exit_alert.dart';
import 'package:queschat/components/drawer.dart';
import 'package:queschat/firebase_dynamic_link.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/home/home/home_bloc.dart';
import 'package:queschat/home/home/home_state.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_view.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';

class HomeView3 extends StatefulWidget {
  @override
  _HomeView3State createState() => _HomeView3State();
}

class _HomeView3State extends State<HomeView3>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {

  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Likes',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Search',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Profile',
  //     style: optionStyle,
  //   ),
  // ];
  List<Widget> _buildScreens =<Widget>
     [
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


  // List<PersistentBottomNavBarItem> _navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon:  Image.asset(
  //         'images/message_nav_icon.png',
  //         color: AppColors.White,
  //
  //
  //         height: 22,
  //         width: 22,
  //       ),
  //       title: ("Home"),
  //       activeColorSecondary: AppColors.White,
  //       inactiveIcon:  Image.asset(
  //         'images/channel_nav_icon.png',
  //         color: AppColors.IconColor,
  //         height: 22,
  //         width: 22,
  //       ),
  //       activeColorPrimary: AppColors.PrimaryColorLight,
  //       inactiveColorPrimary:AppColors.IconColor,
  //     ), PersistentBottomNavBarItem(
  //       icon:  Image.asset(
  //         'images/message_nav_icon.png',
  //         color: AppColors.White,
  //
  //
  //         height: 22,
  //         width: 22,
  //       ),
  //       title: ("Home"),
  //       activeColorSecondary: AppColors.White,
  //       inactiveIcon:  Image.asset(
  //         'images/channel_nav_icon.png',
  //         color: AppColors.IconColor,
  //         height: 22,
  //         width: 22,
  //       ),
  //
  //       activeColorPrimary: AppColors.PrimaryColorLight,
  //       inactiveColorPrimary:AppColors.IconColor,
  //     ), PersistentBottomNavBarItem(
  //       icon:  Image.asset(
  //         'images/channel_nav_icon.png',
  //         color: AppColors.White,
  //
  //
  //         height: 22,
  //         width: 22,
  //       ),
  //       title: ("Home"),
  //       activeColorSecondary: AppColors.White,
  //       inactiveIcon:  Image.asset(
  //         'images/channel_nav_icon.png',
  //         color: AppColors.IconColor,
  //         height: 22,
  //         width: 22,
  //       ),
  //       activeColorPrimary: AppColors.PrimaryColorLight,
  //       inactiveColorPrimary:AppColors.IconColor,
  //     ),
  //
  //   ];
  // }

  // List<BottomNavigationBarItem> _navBarsItems = [
  //   BottomNavigationBarItem(
  //     icon: Image.asset(
  //       'images/message_nav_icon.png',
  //       color: AppColors.IconColor,
  //       height: 22,
  //       width: 22,
  //     ),
  //     label: '',
  //     activeIcon: Image.asset(
  //       'images/message_nav_icon.png',
  //       color: AppColors.SecondaryColor,
  //       height: 22,
  //       width: 22,
  //     ),
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Image.asset(
  //       'images/channel_nav_icon.png',
  //       color: AppColors.IconColor,
  //       height: 22,
  //       width: 22,
  //     ),
  //     activeIcon: Image.asset(
  //       'images/channel_nav_icon.png',
  //       color: AppColors.SecondaryColor,
  //       height: 22,
  //       width: 22,
  //     ),
  //     label: '',
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Image.asset(
  //       'images/feed_nav_icon.png',
  //       color: AppColors.IconColor,
  //       height: 22,
  //       width: 22,
  //     ),
  //     label: '',
  //     activeIcon: Image.asset(
  //       'images/feed_nav_icon.png',
  //       color: AppColors.SecondaryColor,
  //       height: 22,
  //       width: 22,
  //     ),
  //   ),
  // ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

            return Center(
              child: _buildScreens.elementAt(0),
            );
          },
        ),


        bottomNavigationBar:   GNav(
            rippleColor: Colors.grey[800], // tab button ripple color when pressed
            hoverColor: Colors.grey[700], // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 15,tabMargin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
            tabBorder: Border.all(color: Colors.white, width: 1), // tab button border
            curve: Curves.easeOutExpo, // tab animation curves
            duration: Duration(milliseconds: 300),
            // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.grey[800], // unselected icon color
            activeColor: Colors.purple, // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                backgroundColor: Colors.white,

              ),
              GButton(
                icon: Icons.favorite,
                text: 'Likes',
                backgroundColor: Colors.white,

              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
                backgroundColor: Colors.white,

              ),

            ]
        ),
      ),
    );
  }
}

