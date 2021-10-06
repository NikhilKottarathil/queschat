import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:queschat/constants/styles.dart';

class CustomTextField3 extends StatefulWidget {
  String hint;
  TextInputType textInputType;
  var validator;
  var onChange;
  var text;

  CustomTextField3(
      {Key key,
        this.hint,
        this.validator,
        this.text,
        this.onChange,
        this.textInputType})
      : super(key: key);

  @override
  _CustomTextField3State createState() => _CustomTextField3State();
}

class _CustomTextField3State extends State<CustomTextField3> {
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
        contentPadding: EdgeInsets.only(top: 17,bottom: 7),
        hintText: widget.hint,
        labelText: widget.hint,
        labelStyle: TextStyles.smallRegularTextTertiary,
        fillColor: AppColors.SecondaryLight,
        filled: true,
        hintStyle: TextStyles.smallRegularTertiary,
        errorStyle: TextStyle(
            fontSize: 13,
            color: AppColors.TextError,
            height: 1.1,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w400),
        border: AppBorders.transparentBorder,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        disabledBorder: AppBorders.transparentBorder,
        enabledBorder: AppBorders.transparentBorder,
        errorBorder: AppBorders.transparentBorder,
        focusedErrorBorder: AppBorders.transparentBorder,
      ),
    );
  }
}
