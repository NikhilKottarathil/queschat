import 'package:flutter/material.dart';
import 'package:queschat/components/search_user_adapter.dart';
import 'package:queschat/pages/new_channel.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'create_group_stage_1.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  List<SearchUserGS> searchUserGSs = new List<SearchUserGS>();

  @override
  Widget build(BuildContext context) {
    searchUserGSs.add(new SearchUserGS("search", "userName", "name",
        "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    searchUserGSs.add(new SearchUserGS("search", "userName", "name",
        "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    searchUserGSs.add(new SearchUserGS("search", "userName", "name",
        "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    return Scaffold(
      appBar: appBarWithBackButton(context:context, titleString: "New Message"),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            FlatButtonWithIcon(Icon(Icons.group,color: AppColors.IconColor,),"New Group",(){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CreateGroupStage1()));
            }),
            FlatButtonWithIcon(Icon(Icons.group_add,color: AppColors.IconColor,),"New Channel",(){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NewChannel()));
            }),
            Container(
              color: AppColors.StatusBar,

              height: MediaQuery.of(context).size.height*.04,
              width: MediaQuery.of(context).size.width,
              child: Align(
                  alignment:Alignment.centerLeft,child: Text("Sorted by name",textAlign: TextAlign.start,style: TextStyle(color: AppColors.TextTertiary,fontSize: 16),)),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: searchUserGSs.length,
                    itemBuilder: (BuildContext context,int index){
                  return SearchUserAdapter(searchUserGSs[index]);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
