
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class CustomTextButton2 extends StatelessWidget {
  String text, errorText;
  Function action;
  bool active = true;
  Color textColor;

  CustomTextButton2(
      {Key key,
        this.text,
        this.errorText,
        this.action,
        this.active,
        this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (active == null) {
      active = true;
    }
    return InkWell(
      onTap: () {
        action();
      },
      child: Text(
        text,
        style: TextStyle(
            color: textColor == null
                ? AppColors.PrimaryColor
                : textColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'DMSans',
            fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
