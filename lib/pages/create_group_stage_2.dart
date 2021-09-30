import 'package:flutter/material.dart';
import 'package:queschat/components/search_user_adapter.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class CreateGroupStage2 extends StatefulWidget {
  @override
  _CreateGroupStage2State createState() => _CreateGroupStage2State();
}

class _CreateGroupStage2State extends State<CreateGroupStage2> {
  List<SearchUserGS> searchUserGSs = new List<SearchUserGS>();

  @override
  Widget build(BuildContext context) {
    searchUserGSs.add(new SearchUserGS("delete", "userName", "name",
        "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    searchUserGSs.add(new SearchUserGS("delete", "userName", "name",
        "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    searchUserGSs.add(new SearchUserGS("delete", "userName", "name",
        "https://i.pinimg.com/474x/98/4b/38/984b389f259826eb5fa38dc06bf915e8.jpg"));
    return Scaffold(
      appBar: appBarWithBackButton(context:context, titleString: "New Group"),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWithImagePicker("Enter group name"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Members",
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                    itemCount: searchUserGSs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SearchUserAdapter(searchUserGSs[index]);
                    }),
              ),
            ),
            CustomButton(
              text: "Create",
              action: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroupStage2()));
              },
            )
          ],
        ),
      ),
    );
  }
}


class TextFieldWithImagePicker extends StatefulWidget {

  String hintText;
  TextFieldWithImagePicker(this.hintText);
  @override
  _TextFieldWithImagePickerState createState() => _TextFieldWithImagePickerState();
}

class _TextFieldWithImagePickerState extends State<TextFieldWithImagePicker> {
  @override
  Widget build(BuildContext context) {
    return             Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(

        decoration: InputDecoration(

            border: InputBorder.none,
            hintText: widget.hintText,

            prefixIcon: Container(
              margin: EdgeInsets.only(right: 10),

              decoration: BoxDecoration(
                color: AppColors.SecondaryColorLight,
                shape: BoxShape.circle,
                // border: Border.all(color: AppColors.BorderColor),
              ),
              height: 50,
              width: 50,
              child:  IconButton(
                icon: Icon(Icons.camera_enhance,color: Colors.white,),
              ),
            )),
      ),
    );
  }
}
