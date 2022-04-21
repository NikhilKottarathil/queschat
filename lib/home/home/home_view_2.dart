import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/profile/profile_view.dart';
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

class HomeView2 extends StatefulWidget {
  @override
  _HomeView2State createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (context) => channelMessageRoomListBloc,
        child: MessageRoomListView(),
      ),
      BlocProvider(
        create: (context) => allChatMessageRoomListBloc,
        child: MessageRoomListView(),
      ),
      BlocProvider(
        create: (context) => homeFeedBloc,
        child: FeedsView(),
      ),
      // FeedsView(),
      ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: FaIcon(
          FontAwesomeIcons.chromecast,
          size: 22,
        ),
        title: ("Channels"),
        activeColorSecondary: AppColors.White,
        textStyle: TextStyles.bodyWhite,
        activeColorPrimary: AppColors.PrimaryColorLight,
        inactiveColorPrimary: AppColors.IconColor,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(
          FontAwesomeIcons.message,
          size: 22,
        ),
        title: ("All Chats"),
        activeColorSecondary: AppColors.White,
        textStyle: TextStyles.bodyWhite,
        activeColorPrimary: AppColors.PrimaryColorLight,
        inactiveColorPrimary: AppColors.IconColor,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(
          FontAwesomeIcons.rectangleList,
          size: 22,
        ),
        title: ("Feeds"),
        activeColorSecondary: AppColors.White,
        textStyle: TextStyles.bodyWhite,
        activeColorPrimary: AppColors.PrimaryColorLight,
        inactiveColorPrimary: AppColors.IconColor,
      ),
      PersistentBottomNavBarItem(
        icon: FaIcon(
          FontAwesomeIcons.user,
          size: 22,
        ),
        title: ("Profile"),
        textStyle: TextStyles.bodyWhite,
        activeColorSecondary: AppColors.White,
        activeColorPrimary: AppColors.PrimaryColorLight,
        inactiveColorPrimary: AppColors.IconColor,
      ),
    ];
  }

  PersistentTabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
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
        backgroundColor: Colors.transparent,
        appBar: homeAppBar(context),
        drawer: CustomDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            _controller.jumpToTab(
              state.tabIndex,
            );
            print('HOME BUILDED ${state.tabIndex}');
            return PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),

              items: _navBarsItems(),
              confineInSafeArea: true,
              navBarHeight: 65,

              onItemSelected: (index) {
                context.read<HomeBloc>().add(ChangeTab(index));
              },
              backgroundColor: Colors.white,
              // Default is Colors.white.
              handleAndroidBackButtonPress: true,
              // Default is true.
              resizeToAvoidBottomInset: true,
              // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true,
              // Default is true.
              hideNavigationBarWhenKeyboardShows: true,
              // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  colorBehindNavBar: Colors.white,
                  boxShadow: appShadow),

              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),

              navBarStyle: NavBarStyle
                  .style7, // Choose the nav bar style with this property.
            );
          },
        ),
      ),
    );
  }
}
