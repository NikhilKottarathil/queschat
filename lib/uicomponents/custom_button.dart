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
      height: MediaQuery.of(context).size.height * .07,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.lightBlue.shade900,
        onPressed: action,
        shape:
            new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          text,
          style:TextStyles.mediumMediumWhite,
        ),
      ),
    );
  }
}
