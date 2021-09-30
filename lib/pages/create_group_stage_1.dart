import 'package:flutter/material.dart';
import 'package:queschat/components/search_user_adapter.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'create_group_stage_2.dart';
class CreateGroupStage1 extends StatefulWidget {
  @override
  _CreateGroupStage1State createState() => _CreateGroupStage1State();
}

class _CreateGroupStage1State extends State<CreateGroupStage1> {
  List<SearchUserGS> searchUserGSs=new List<SearchUserGS>();
  @override
  Widget build(BuildContext context) {
    searchUserGSs.add(new SearchUserGS("add","userName", "name", "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    searchUserGSs.add(new SearchUserGS("add","userName", "name", "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    searchUserGSs.add(new SearchUserGS("add","userName", "name", "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    return Scaffold(
      appBar: appBarWithBackButton(context:context, titleString:"New Group"),

      body: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search here"
              ),
            ),
            SizedBox(height: 10,),
            Text("Suggested",style: TextStyle(fontSize: 18),),
            Expanded(
              child: Container(

                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: searchUserGSs.length,
                    itemBuilder: (BuildContext context,int index){
                  return SearchUserAdapter(searchUserGSs[index]);
                }),
              ),
            ),
            CustomButton(text: "NEXT",action: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroupStage2()));
            },)
          ],
        ),
      ),
    );
  }
}
