import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/alert_grid.dart';
import 'package:queschat/components/drawer.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_view.dart';
import 'package:queschat/home/home_bloc.dart';
import 'package:queschat/home/home_events.dart';
import 'package:queschat/home/home_state.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_view.dart';
import 'package:queschat/pages/ask_a_doubt.dart';
import 'package:queschat/pages/feedpage.dart';
import 'package:queschat/pages/messages.dart';
import 'package:queschat/pages/post_a_MCQ.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Widget> _tabList = [FeedsView(), Messages()];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Color fabColor = AppColors.PrimaryColor;

    return Scaffold(
      appBar: homeAppBar(context),
      drawer: CustomDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          _tabController.animateTo(state.tabIndex);
          return TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: _tabList,
          );
        },
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
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: state.tabIndex,
              onTap: (int index) {
                context.read<HomeBloc>().add(ChangeTab(index));
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    "images/feed_icon_inactive.png",
                    height: 22,
                  ),
                  activeIcon: Image.asset(
                    "images/feed_icon.png",
                    height: 24,
                  ),
                  // size: MediaQuery.of(context).size.height * .035),
                  label: "Feed",
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      "images/ic_chat_inactive.png",
                      height: 22,
                    ),
                    activeIcon: Image.asset(
                      "images/ic_chat.png",
                      height: 24,
                    ),
                    label: "Message"),
              ],
            );
          },
        ),
      ),
    );
  }
}

void showDialog(BuildContext buildContext) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.9),
    transitionDuration: Duration(milliseconds: 500),
    context: buildContext,
    pageBuilder: (context, __, ___) {
      return Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(buildContext).size.height * .025),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * .1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // AlertGrid(
                    //     heading: "Ask a Doubt",
                    //     description: "Feeling stuck, let us help",
                    //     action: () {
                    //       // print("passed sueess");
                    //       Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => AskADoubt()));
                    //     }),
                    AlertGrid(
                        heading: "Post A MCQ",
                        description: "Challenge your fellow beings",
                        action: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(providers: [
                                  BlocProvider.value(
                                    value: buildContext.read<PostMcqBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: buildContext.read<FeedsBloc>(),
                                  ),
                                ], child: PostAMCQView(),)
                              ),);

                        }),
                    AlertGrid(
                        heading: "Post A Blog",
                        description: "Share what you know",
                        action: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(providers: [
                                  BlocProvider.value(
                                    value: buildContext.read<PostBlogBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: buildContext.read<FeedsBloc>(),
                                  ),
                                ], child: PostBlogView(),)
                            ),);

                        }),
                    // AlertGrid(
                    //     heading: "Share Info",
                    //     description: "Share what you know",
                    //     action: () {}),
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
              child: Icon(Icons.close, color: Colors.black, size: 40),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
