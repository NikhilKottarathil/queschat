

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queschat/components/alert_grid.dart';
import 'package:queschat/components/drawer.dart';
import 'package:queschat/pages/ask_a_doubt.dart';
import 'package:queschat/pages/post_a_MCQ.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';

import 'messages.dart';
import 'feedpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _currentIndex = 0;

  List<Widget> _tabList = [Feeds(), Messages()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);

    _tabController.animateTo(_currentIndex);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color fabColor = AppColors.PrimaryColor;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: const Color(0xFF144169),
        statusBarIconBrightness: Brightness.light));
    return SafeArea(
      child: Scaffold(
        appBar: homeAppBar(context),
        drawer: CustomDrawer(),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: _tabList,
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          hoverColor: AppColors.PrimaryColorLight,
          backgroundColor: Colors.blue,
          onPressed: () {
            fabColor = Colors.white;
            setState(() {
              print("success");
            });

            showDialog(context);

          },
          child: Container(
            height: MediaQuery.of(context).size.height * .085,
            width: MediaQuery.of(context).size.height * .085,
            decoration: BoxDecoration(shape: BoxShape.circle, color: fabColor),
            child: Icon(Icons.add, size: 40),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
              print("Index $_currentIndex");
              _tabController.animateTo(_currentIndex);
            },
            items: [
              BottomNavigationBarItem(
                icon:Image.asset("images/feed_icon_inactive.png",scale:1.6,),
                    activeIcon:Image.asset("images/feed_icon.png",scale:1.4,) ,
                    // size: MediaQuery.of(context).size.height * .035),
                label: "Feed",
              ),
              BottomNavigationBarItem(
                  icon:Image.asset("images/ic_chat_inactive.png",scale:1.6,),

                  activeIcon:Image.asset("images/ic_chat.png",scale:1.4) ,
                  label: "Message"),
            ],
          ),
        ),
      ),
    );
  }

  void showDialog(BuildContext buildContext) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.025),

          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
                alignment: Alignment.bottomCenter,

                child: Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AlertGrid(
                          heading: "Ask a Doubt",
                          description: "Feeling stuck, let us help",
                          action: () {
                            // print("passed sueess");
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => AskADoubt()));
                          }),
                      AlertGrid(
                          heading: "Post an MCQ",
                          description: "Challenge your fellow beings",
                          action: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => PostAMCQ()));
                          }),
                      AlertGrid(
                          heading: "Share Info",
                          description: "Share what you know",
                          action: () {}),
                    ],
                  ),
                )),
            floatingActionButton: FloatingActionButton(

              onPressed: () {

                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .085,
                width: MediaQuery.of(context).size.height * .085,
                decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.close,color: Colors.black, size: 40),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

}

