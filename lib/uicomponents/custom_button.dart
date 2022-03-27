import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class CustomButton extends StatelessWidget {
  String text;
  Function action;

  CustomButton({Key key, this.text, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: AppColors.PrimaryColorDark,
            padding: EdgeInsets.all(18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: action,
        child: Text(
          text.toUpperCase(),

          style: TextStyles.buttonWhite,
        ),
      ),
    );
  }
}
