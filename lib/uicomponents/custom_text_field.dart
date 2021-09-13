import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:queschat/constants/styles.dart';

class CustomTextField extends StatefulWidget {
  String hint;
  Icon icon;
  TextInputType textInputType;
  var validator;
  var onChange;

  CustomTextField(
      {Key key,
      this.hint,
      this.icon,
      this.validator,
      this.onChange,
      this.textInputType})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      keyboardType: widget.textInputType,
      style:  TextStyles.smallRegularTextSecondary,
      validator: widget.validator,
      onChanged: widget.onChange,
      decoration: new InputDecoration(
        prefixIcon: widget.icon,
        contentPadding: EdgeInsets.all(17),
        hintText: widget.hint,
        fillColor: AppColors.SecondaryLight,
        filled: true,
        hintStyle: TextStyles.smallRegularTertiary,
        errorStyle: TextStyle(fontSize:12,color: AppColors.TextError,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400),

        border:AppBorders.transparentBorder,
        focusedBorder: AppBorders.transparentBorder,
        disabledBorder:AppBorders.transparentBorder,
        enabledBorder: AppBorders.transparentBorder,
        errorBorder: AppBorders.transparentBorder,
        focusedErrorBorder: AppBorders.transparentBorder,
      ),
    );
  }
}
