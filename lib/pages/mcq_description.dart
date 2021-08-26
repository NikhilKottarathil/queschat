import 'package:flutter/material.dart';
import 'package:queschat/components/media_picker.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class MCQDescription extends StatefulWidget {
  @override
  _MCQDescriptionState createState() => _MCQDescriptionState();
}

class _MCQDescriptionState extends State<MCQDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context, "MCQ Description"),
      body: Container(
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: TextField(
                  maxLines: null,
                  decoration:
                      InputDecoration(hintText: "Enter your description"),
                )),
            Expanded(flex: 3, child: MediaPicker()),
            CustomButton(
              text: "POST",
              action: () {},
            ),
          ],
        ),
      ),
    );
  }
}
