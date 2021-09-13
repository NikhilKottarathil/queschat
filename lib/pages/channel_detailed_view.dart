import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/pages/Courses.dart';
import 'package:queschat/pages/ques_blog.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'all_chats.dart';
import 'channels.dart';

class ChannelDetailedView extends StatefulWidget {
  @override
  _ChannelDetailedViewState createState() => _ChannelDetailedViewState();
}

class _ChannelDetailedViewState extends State<ChannelDetailedView> {
  @override
  ScrollController _scrollController;

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = new ScrollController()
      ..addListener(() {
        setState(() {
          _isAppBarExpanded;
        });
      });
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.grey.shade50,
                  expandedHeight: MediaQuery.of(context).size.height*.3,
                  floating: false,
                  pinned: true,
                  centerTitle: true,
                  title: _isAppBarExpanded
                      ? Text("Experiences of Life",
                          style: TextStyle(
                              color: AppColors.TextSecondary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))
                      : null,
                  flexibleSpace: FlexibleSpaceBar(
                    
                    background: Container(
                      margin: EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height * .25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .1,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "https://i0.wp.com/linkedinheaders.com/wp-content/uploads/2018/02/laptop-editing-header.jpg?fit=1584%2C396&ssl=1"))),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text("Experiences of Life",
                                    style: TextStyle(
                                        color: AppColors.TextSecondary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I",
                                    style: TextStyle(
                                        color: AppColors.TextSecondary,
                                        fontSize: 15)),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: MediaQuery.of(context).size.height*.05,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            margin: EdgeInsets.all(5),

                                            child: Column(
                                              children: [
                                                Text(
                                                  "1k",
                                                  style: TextStyle(
                                                      color: AppColors.PrimaryColor.withOpacity(.8)),
                                                ),
                                                Text("Followers",style: TextStyle(
                                                    color: AppColors.PrimaryColor.withOpacity(.8))),
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          flex: 7,
                                          child: FlatButton(

                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.PrimaryColor,

                                                  borderRadius: BorderRadius.circular(25)
                                              ),
                                                height: double.infinity,
                                                width: double.infinity,
                                                child: Center(child: Text("Follow"),)),
                                          )),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(icon: Text("Courses")),
                        Tab(icon: Text("Quesblog")),
                        Tab(icon: Text("Uploads")),
                        Tab(icon: Text("MCQ")),
                      ],
                    ),
                  ),
                  // pinned: true,
                ),
              ];
            },
            body: Center(
              child: TabBarView(
                children: [
                  Courses(),
                  QuesBlog(),
                  AllChats(),
                  Channels(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
// SizedBox(height: 10,),
// Text("Experiences of Life",style: TextStyle(color: AppColors.TextSecondary,fontSize: 18,fontWeight: FontWeight.bold))
//
