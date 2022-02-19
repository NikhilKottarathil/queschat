import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:queschat/constants/styles.dart';

class CustomTextField3 extends StatefulWidget {
  String hint,label;
  TextInputType textInputType;
  var validator;
  var onChange;
  var text;

  CustomTextField3(
      {Key key,
        this.hint,
        this.validator,
        this.text,
        this.label,
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
      style:TextStyles.smallRegularTextSecondary,
      validator: widget.validator,
      obscureText:
      widget.textInputType == TextInputType.visiblePassword ? true : false,
      enableSuggestions:
      widget.textInputType == TextInputType.visiblePassword ? false : true,
      autocorrect:
      widget.textInputType == TextInputType.visiblePassword ? false : true,
      onChanged: widget.onChange,
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.only(top: 14),
        hintText: widget.hint,
        labelText: widget.label,

        labelStyle: TextStyles.smallRegularTextTertiary,
        fillColor: AppColors.SecondaryLight,
        filled: true,
        hintStyle: TextStyles.smallRegularTertiary,
        errorStyle: TextStyle(
            fontSize: 13,
            color: AppColors.TextError,
            height: 1.00,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w400),
        border:InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        enabledBorder:InputBorder.none,
        errorBorder:InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        // focusedErrorBorder: AppBorders.transparentBorder,
      ),
    );
  }
}
