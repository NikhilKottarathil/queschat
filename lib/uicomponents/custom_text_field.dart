import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:queschat/constants/styles.dart';

class CustomTextField extends StatefulWidget {
  String hint;
  Icon icon;
  TextInputType textInputType;
  var validator;
  var onChange;
  var text;

  CustomTextField(
      {Key key,
      this.hint,
      this.icon,
      this.validator,
      this.text,
      this.onChange,
      this.textInputType})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text != null) {
      controller.text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      controller: controller,
      keyboardType: widget.textInputType,
      style: TextStyles.smallRegularTextSecondary,
      validator: widget.validator,
      obscureText:
          widget.textInputType == TextInputType.visiblePassword ? true : false,
      enableSuggestions:
          widget.textInputType == TextInputType.visiblePassword ? false : true,
      autocorrect:
          widget.textInputType == TextInputType.visiblePassword ? false : true,
      onChanged: widget.onChange,
      decoration: new InputDecoration(
        prefixIcon: widget.icon,
        contentPadding: EdgeInsets.all(17),
        hintText: widget.hint,
        fillColor: AppColors.SecondaryLight,
        filled: true,
        hintStyle: TextStyles.smallRegularTertiary,
        errorStyle: TextStyle(
            fontSize: 12,
            color: AppColors.TextError,
            height: 1.1,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w400),
        border: AppBorders.transparentBorder,
        focusedBorder: AppBorders.transparentBorder,
        disabledBorder: AppBorders.transparentBorder,
        enabledBorder: AppBorders.transparentBorder,
        errorBorder: AppBorders.transparentBorder,
        focusedErrorBorder: AppBorders.transparentBorder,
      ),
    );
  }
}

class CustomTextField2 extends StatefulWidget {
  String hint;
  Icon icon;
  TextInputType textInputType;
  var validator;
  var onChange;
  var text;

  CustomTextField2(
      {Key key,
      this.hint,
      this.icon,
      this.validator,
      this.text,
      this.onChange,
      this.textInputType})
      : super(key: key);

  @override
  _CustomTextField2State createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text != null) {
      controller.text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      controller: controller,
      keyboardType: widget.textInputType,
      style: TextStyles.smallRegularTextSecondary,
      validator: widget.validator,
      obscureText:
          widget.textInputType == TextInputType.visiblePassword ? true : false,
      enableSuggestions:
          widget.textInputType == TextInputType.visiblePassword ? false : true,
      autocorrect:
          widget.textInputType == TextInputType.visiblePassword ? false : true,
      onChanged: widget.onChange,
      maxLines: null,

      decoration: new InputDecoration(
        prefixIcon: widget.icon,
        contentPadding: EdgeInsets.only(top: 17, bottom: 17),
        hintText: widget.hint,
        hintStyle: TextStyles.mediumRegularTextTertiary,
        errorStyle: TextStyle(
            fontSize: 12,
            color: AppColors.TextError,
            height: 1.1,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w400),
        border: AppBorders.transparentBorder,
        focusedBorder: AppBorders.transparentBorder,
        disabledBorder: AppBorders.transparentBorder,
        enabledBorder: AppBorders.transparentBorder,
        errorBorder: AppBorders.transparentBorder,
        focusedErrorBorder: AppBorders.transparentBorder,
      ),
    );
  }
}

class TextFieldWithBoxBorder extends StatefulWidget {
  String heading;
  double height;
  String hint;
  Icon icon;
  TextInputType textInputType;
  var validator;
  var errorText;
  var onChange;
  var text;

  TextFieldWithBoxBorder(
      {Key key,
      this.hint,
      this.icon,
      this.validator,
      this.text,
      this.heading,
        this.errorText,
      this.height,
      this.onChange,
      this.textInputType})
      : super(key: key);

  @override
  _TextFieldWithBoxBorderState createState() => _TextFieldWithBoxBorderState();
}

class _TextFieldWithBoxBorderState extends State<TextFieldWithBoxBorder> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text != null) {
      controller.text = widget.text;
    }else{
      controller.text='';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.heading!=null?Text(
            widget.heading!=null?widget.heading:'',
            style: TextStyle(color: AppColors.TextFourth, fontSize: 18),
          ):Container(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.IconColor),
                  borderRadius: BorderRadius.circular(4)),
              child: new TextFormField(
                controller: controller,
                keyboardType: widget.textInputType,
                style: TextStyles.smallRegularTextSecondary,

                obscureText:
                    widget.textInputType == TextInputType.visiblePassword
                        ? true
                        : false,
                enableSuggestions:
                    widget.textInputType == TextInputType.visiblePassword
                        ? false
                        : true,
                autocorrect:
                    widget.textInputType == TextInputType.visiblePassword
                        ? false
                        : true,
                onChanged: widget.onChange,
                maxLines: null,
                validator: widget.validator,
                decoration: new InputDecoration(

                  errorText: widget.errorText,
                  prefixIcon: widget.icon,
                  contentPadding: EdgeInsets.only(top: 17, bottom: 17,left: 17,right: 17),
                  hintText: widget.hint,
                  hintStyle: TextStyles.mediumRegularTextTertiary,
                  errorStyle: TextStyle(
                      fontSize: 12,
                      color: AppColors.TextError,
                      height: 1.1,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w400),
                  border: AppBorders.transparentBorder,
                  focusedBorder: AppBorders.transparentBorder,
                  disabledBorder: AppBorders.transparentBorder,
                  enabledBorder: AppBorders.transparentBorder,
                  errorBorder: AppBorders.transparentBorder,
                  focusedErrorBorder: AppBorders.transparentBorder,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
