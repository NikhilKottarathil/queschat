import 'package:flutter/material.dart';
import 'package:queschat/uicomponents/AppColors.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'create_group_stage_2.dart';
class NewChannel extends StatefulWidget {
  @override
  _NewChannelState createState() => _NewChannelState();
}

class _NewChannelState extends State<NewChannel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context, "New Channel"),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFieldWithImagePicker("Enter channel name"),

            TextFieldWithBoxBorder("Description",MediaQuery.of(context).size.height*.3),

            TextFieldWithBoxBorder("Insta facebook Links",MediaQuery.of(context).size.height*.12),

            Expanded(child: Align(
                alignment:Alignment.bottomCenter,child: CustomButton(text: "Create",action: (){})))
          ],
        ),
      ),
    );
  }
}


class TextFieldWithBoxBorder extends StatelessWidget {
  String heading;
  double height;
  TextFieldWithBoxBorder(this.heading,this.height);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: height,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          Text(heading,style: TextStyle(color: AppColors.TextFourth,fontSize: 18),),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.IconColor),
                borderRadius: BorderRadius.circular(4)
              ),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
