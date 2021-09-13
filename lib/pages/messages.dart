import 'package:flutter/material.dart';
import 'package:queschat/pages/all_chats.dart';
import 'package:queschat/pages/channels.dart';
import 'package:queschat/constants/styles.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: TabBar(
              unselectedLabelColor: AppColors.TextSecondary.withOpacity(.5),
              labelColor:AppColors.TextSecondary ,
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
                  style:
                      TextStyle( fontSize: 18),
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllChats(),
              Channels(),
            ],
          ),
        ),
      ),
    );
  }
}
