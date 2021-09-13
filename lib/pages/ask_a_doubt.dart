import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/components/media_picker.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import '../Trash.dart';

class AskADoubt extends StatefulWidget {
  @override
  _AskADoubtState createState() => _AskADoubtState();
}

class _AskADoubtState extends State<AskADoubt> {
  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    double mHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBarWithBackButton(context,"Ask a Doubt"),
      body: Container(
        padding: EdgeInsets.only(top:20,left: 10,right: 10,bottom: 20),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type out your question & your fellow beings will soon help you out",

                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.IconColor),
                ),
              ),
            ),
            Expanded(
              flex: 3,
                child: MediaPicker(),
            ),
            // // Container(height: mHeight*,),
            // CustomButtonWithIcon(icon: Icons.camera,text: "Add an Image",action: (){
            // }),
            CustomButton(text: "POST",action: (){}),
          ],
        ),
      ),
    );
  }
}



