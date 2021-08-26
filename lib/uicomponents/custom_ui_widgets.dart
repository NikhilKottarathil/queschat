import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/pages/create_group_stage_1.dart';

import 'AppColors.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController textEditingController;
  String hint;
  Icon icon;
  TextInputType textInputType;

  CustomTextField(
      {Key key,
      this.textEditingController,
      this.hint,
      this.icon,
      this.textInputType})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(top: 10),
      child: new TextField(
        keyboardType: widget.textInputType,
        style: new TextStyle(color: Colors.black),
        decoration: new InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color:AppColors.SecondaryColorLight),
          prefixIcon: widget.icon,
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  @override
  _CustomButtonState createState() => _CustomButtonState();
  String text;
  Function action;

  CustomButton({Key key, this.text, this.action}) : super(key: key);
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: MediaQuery.of(context).size.height * .07,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.lightBlue.shade900,
        onPressed: widget.action,
        shape:
            new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white,fontFamily: 'NunitoSans_SemiBold'),
        ),
      ),
    );
  }
}

class AppName extends StatefulWidget {
  TextAlign textAlign;
  double size;

  AppName({Key key, this.textAlign, this.size}) : super(key: key);

  @override
  _AppNameState createState() => _AppNameState();
}

class _AppNameState extends State<AppName> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[AppColors.PrimaryColorLight, AppColors.PrimaryColor],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Text(
      "Queschat",
      style: TextStyle(
          foreground: Paint()..shader = linearGradient, fontSize: widget.size),
      textAlign: widget.textAlign,
    );
  }
}

class ActiveInactiveButton extends StatefulWidget {
  Image icon;
  String text;
  bool isActive;
  Function action;

  ActiveInactiveButton(
      {Key key, this.icon, this.text, this.isActive, this.action})
      : super(key: key);

  @override
  _ActiveInactiveButtonState createState() => _ActiveInactiveButtonState();
}

class _ActiveInactiveButtonState extends State<ActiveInactiveButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.action();
      },
      child: Container(
        decoration: widget.isActive
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.SecondaryColorLight)
            : null,
        height: MediaQuery.of(context).size.height * .05,
        child: Row(
          children: <Widget>[
            SizedBox(width: 15),
            Container(
              child: widget.icon,
              width: MediaQuery.of(context).size.height * .025,
            ),
            SizedBox(width: 15),
            Text(
              widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatefulWidget {
  String text;
  IconData icon;
  Function action;

  CustomButtonWithIcon({Key key, this.icon, this.text, this.action})
      : super(key: key);

  @override
  _CustomButtonWithIconState createState() => _CustomButtonWithIconState();
}

class _CustomButtonWithIconState extends State<CustomButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.action,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .06,
        decoration:
            BoxDecoration(boxShadow: [BoxShadow(color: AppColors.ShadowColor)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: AppColors.SecondaryColorLight,
            ),
            Text(
              "  " + widget.text,
              style: TextStyle(color: AppColors.SecondaryColorLight),
            ),
          ],
        ),
      ),
    );
  }
}

class FlatButtonWithIcon extends StatelessWidget {
  Icon icon;
  String text;
  Function action;
  FlatButtonWithIcon(this.icon, this.text,this.action);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
          child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: AppColors.BorderColor),
              ),
              height: 50,
              width: 50,
              child: icon,
            ),
          ),
          Expanded(
              flex: 4,
              child: Text(
                text,
                style: TextStyle(color: AppColors.TextSecondary, fontSize: 18),
              ))
        ],
      )),
    );
  }
}
