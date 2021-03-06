import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class CustomTextField extends StatefulWidget {
  String hint;
  Icon icon;
  TextInputType textInputType;
  var validator;
  var onChange;
  var text;
  int maxLength;
  bool enabled;


  CustomTextField(
      {Key key,
      this.hint,
      this.icon,
      this.validator,
      this.text,
        this.maxLength,
      this.onChange,this.enabled=true,
      this.textInputType})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController controller = new TextEditingController();

  bool isVisible=false;
  bool enabled=true;
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
      cursorColor: AppColors.SecondaryColor,

      enabled: widget.enabled,
      controller: controller,
      keyboardType: widget.textInputType,
      style: TextStyles.bodyTextPrimary,
      validator: widget.validator,
      maxLength: widget.maxLength!=null?widget.maxLength:widget.textInputType==TextInputType.phone?10:null,

      obscureText:
          widget.textInputType == TextInputType.visiblePassword ?isVisible? false : true : false,
      enableSuggestions:
          widget.textInputType == TextInputType.visiblePassword ? false : true,
      autocorrect:
          widget.textInputType == TextInputType.visiblePassword ? false : true,
      onChanged: widget.onChange,
      decoration: new InputDecoration(
        counterText: '',
        prefixIcon: widget.icon,

        suffixIcon:Visibility(
          visible: widget.textInputType == TextInputType.visiblePassword,
          child:IconButton(icon:Icon(isVisible?Icons.visibility_off:Icons.visibility,color: AppColors.IconColor),
          onPressed: (){
            setState(() {
              isVisible=!isVisible;
            });
          },)),
        contentPadding: EdgeInsets.all(17),
        hintText: widget.hint,
        // labelText: widget.hint,

        prefixIconColor: AppColors.SecondaryColor,


        hintStyle: TextStyles.smallRegularTextTertiary,
        errorStyle:TextStyles.smallRegularTextError,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.BorderColor)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.SecondaryColor)
        ),
        disabledBorder:OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.BorderColor)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.BorderColor)
        ),
        errorBorder:OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.BorderColor)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.BorderColor)
        ),
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
            style: TextStyles.mediumMediumTextSecondary,
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
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
