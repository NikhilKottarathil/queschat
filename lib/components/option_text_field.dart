// import 'package:flutter/material.dart';
// import 'package:queschat/constants/styles.dart';// class OptionTexctField extends StatefulWidget {
//   TextEditingController textEditingController;
//
//   OptionTextField({Key key, this.optionKey, this.textEditingController})
//       : super(key: key);
//
//   @override
//   _OptionTextFieldState createState() => _OptionTextFieldState();
// }
//
// class _OptionTexftFieldState extends State<OptionTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 10, bottom: 10),
//       child: Container(
//         height: MediaQuery.of(context).size.height * .09,
//         width: MediaQuery.of(context).size.width,
//         color: AppColors.ShadowColor,
//         padding: EdgeInsets.only(left: 5),
//         child: Center(
//           child: TextField(
//             // maxLines: null,
//             decoration: InputDecoration(
//               hintText: "Enter here",
//               border: InputBorder.none,
//               prefixIcon: Container(
//                 width: MediaQuery.of(context).size.height * .045,
//                 height: MediaQuery.of(context).size.height * .045,
//                 margin: EdgeInsets.only(right: 10),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(clor: AppColors.BorderColor),
//                 ),
//                 child: Center(
//                   child: Text(
//                     widget.optionKey,
//                     style: TextStyle(color: AppColors.TextSecondary),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class OptionTextField extends StatefulWidget {
  String hint;
  TextInputType textInputType;
  var validator;
  var onChange;
  var text;
  String optionKey;
  String errorText;


  OptionTextField({Key key,
    this.hint,
    this.validator,
    this.text,
    this.errorText,
    this.onChange,
    this.optionKey,
    this.textInputType})
      : super(key: key);

  @override
  _OptionTextFieldState createState() => _OptionTextFieldState();
}

class _OptionTextFieldState extends State<OptionTextField> {
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.BorderColor),
        borderRadius: BorderRadius.circular(8)

      ),
      // padding: EdgeInsets.only(bottom: 10,top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      margin: EdgeInsets.only(bottom: 16),
      child: new TextFormField(
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

          prefixIcon: Container(
            width: 32,
            height: 32,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.BorderColor),
            ),

            child: Center(
              child: Text(
                widget.optionKey,
                style: TextStyles.smallMediumTextSecondary,
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          hintText: widget.hint,
          // filled: true,
          // fillColor: AppColors.RedSecondary,

          hintStyle: TextStyles.smallRegularTextTertiary,
          errorText: widget.errorText==''?null:widget.errorText,
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
    );
  }
}
