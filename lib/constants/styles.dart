import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors{
  // 0xFF144169
  static const PrimaryColor =  Color(0xff004C93);
  static const PrimaryColorLight =  Color(0xff0d64b5);
  static const SecondaryColorLight =  Color(0xff6694c0);
  static const Tertiary = Color(0xff6694c0);
  static const PrimaryLightest =  Color(0xffBCE0FD);
  static const IconColor =  Color(0xff727C8E);
  static const WhiteBlueShade =  Color(0xffF5FAFF);

  static const SecondaryLight =  Color(0xffF9FAFC);
  static const ShadowColor =  Color(0xffedeef0);
  static const BorderColor =  Color(0xffDBDBDB);
  static const RedPrimary =  Color(0xffED5B6C);
  static const RedSecondary =  Color(0xffF49FA9);
  static const GreenPrimary =  Color(0xff45B97C);
  static const GreenSecondary =  Color(0xff51B167);
  static const StatusBar =  Color(0xffF5F5F5);

  static const TextPrimary=  Color(0xff00264A);
  static const TextPrimary2=  Color(0xff004C93);
  static const TextSecondary =  Color(0xff333333);
  static const TextFourth=  Color(0xff606060);
  static const TextTertiary=  Color(0xff82878A);
  static const TextError=  Colors.red;


  static const ChatPrimaryColor= Color(0xffFFFFFF);
  // static const ChatPrimaryColor= Color(0xffc0dffc);
  static const ChatSecondaryColor= Color(0xffF5F5F5);



  // Color ChatPrimaryColor = Color(0xff6694c0).withOpacity(.2);



  static const White=  Color(0xFFFFFFFF);

  static const Color DividerBase=const Color(0xFFF2F4F5);

}

class AppBorders {
  static const OutlineInputBorder transparentBorder= const OutlineInputBorder(
  borderSide: BorderSide(
  color:Colors.transparent));
}
const  dividerDefault=const Divider(
  thickness: 1,
  color: AppColors.DividerBase,
);
const  dividerDefaultBold=const Divider(
  thickness: 1,
  color: AppColors.TextTertiary,
);
class TextStyles{



  static const TextStyle tinyRegularTextPrimary=const TextStyle(fontSize:12,color: AppColors.TextPrimary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextPrimary=const TextStyle(fontSize:12,color: AppColors.TextPrimary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextPrimary=const TextStyle(fontSize:12,color: AppColors.TextPrimary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextPrimary=const TextStyle(fontSize:14,color: AppColors.TextPrimary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextPrimary=const TextStyle(fontSize:14,color: AppColors.TextPrimary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextPrimary=const TextStyle(fontSize:14,color: AppColors.TextPrimary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextPrimary=const TextStyle(fontSize:16,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextPrimary=const TextStyle(fontSize:16,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextPrimary=const TextStyle(fontSize:16,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTextPrimary=const TextStyle(fontSize:20,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextPrimary=const TextStyle(fontSize:20,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextPrimary=const TextStyle(fontSize:20,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);






  static const TextStyle tinyRegularTextSecondary=const TextStyle(fontSize:12,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextSecondary=const TextStyle(fontSize:12,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextSecondary=const TextStyle(fontSize:12,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextSecondary=const TextStyle(fontSize:14,color: AppColors.TextSecondary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextSecondary=const TextStyle(fontSize:14,color: AppColors.TextSecondary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextSecondary=const TextStyle(fontSize:14,color: AppColors.TextSecondary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextSecondary=const TextStyle(fontSize:16,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextSecondary=const TextStyle(fontSize:16,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextSecondary=const TextStyle(fontSize:16,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

 static const TextStyle xMediumRegularTextSecondary=const TextStyle(fontSize:20,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextSecondary=const TextStyle(fontSize:20,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextSecondary=const TextStyle(fontSize:20,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);





  static const TextStyle tinyRegularTextTertiary=const TextStyle(fontSize:12,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextTertiary=const TextStyle(fontSize:12,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextTertiary=const TextStyle(fontSize:12,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextTertiary=const TextStyle(fontSize:14,color: AppColors.TextTertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextTertiary=const TextStyle(fontSize:14,color: AppColors.TextTertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextTertiary=const TextStyle(fontSize:14,color: AppColors.TextTertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextTertiary=const TextStyle(fontSize:16,color: AppColors.TextTertiary,height:1.4,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextTertiary=const TextStyle(fontSize:16,color: AppColors.TextTertiary,height:1.4,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextTertiary=const TextStyle(fontSize:16,color: AppColors.TextTertiary,height:1.4,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTextTertiary=const TextStyle(fontSize:20,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextTertiary=const TextStyle(fontSize:20,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextTertiary=const TextStyle(fontSize:20,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);






  static const TextStyle tinyRegularTertiary=const TextStyle(fontSize:12,color: AppColors.Tertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTertiary=const TextStyle(fontSize:12,color: AppColors.Tertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTertiary=const TextStyle(fontSize:12,color: AppColors.Tertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTertiary=const TextStyle(fontSize:14,color: AppColors.Tertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTertiary=const TextStyle(fontSize:14,color: AppColors.Tertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTertiary=const TextStyle(fontSize:14,color: AppColors.Tertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTertiary=const TextStyle(fontSize:16,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTertiary=const TextStyle(fontSize:16,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTertiary=const TextStyle(fontSize:16,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTertiary=const TextStyle(fontSize:20,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTertiary=const TextStyle(fontSize:20,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTertiary=const TextStyle(fontSize:20,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTertiary=const TextStyle(fontSize:26,color: AppColors.Tertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTertiary=const TextStyle(fontSize:26,color: AppColors.Tertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTertiary=const TextStyle(fontSize:26,color: AppColors.Tertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);





  static const TextStyle tinyRegularWhite=const TextStyle(fontSize:12,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumWhite=const TextStyle(fontSize:12,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldWhite=const TextStyle(fontSize:12,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularWhite=const TextStyle(fontSize:14,color: AppColors.White,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumWhite=const TextStyle(fontSize:14,color: AppColors.White,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldWhite=const TextStyle(fontSize:14,color: AppColors.White,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularWhite=const TextStyle(fontSize:16,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumWhite=const TextStyle(fontSize:16,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldWhite=const TextStyle(fontSize:16,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

 static const TextStyle xMediumRegularWhite=const TextStyle(fontSize:20,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumWhite=const TextStyle(fontSize:20,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldWhite=const TextStyle(fontSize:20,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularWhite=const TextStyle(fontSize:26,color: AppColors.White,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumWhite=const TextStyle(fontSize:26,color: AppColors.White,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldWhite=const TextStyle(fontSize:26,color: AppColors.White,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);




  static const TextStyle tinyRegularPrimaryColor=const TextStyle(fontSize:12,color: AppColors.PrimaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumPrimaryColor=const TextStyle(fontSize:12,color: AppColors.PrimaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldPrimaryColor=const TextStyle(fontSize:12,color: AppColors.PrimaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularPrimaryColor=const TextStyle(fontSize:14,color: AppColors.PrimaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumPrimaryColor=const TextStyle(fontSize:14,color: AppColors.PrimaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldPrimaryColor=const TextStyle(fontSize:14,color: AppColors.PrimaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularPrimaryColor=const TextStyle(fontSize:16,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumPrimaryColor=const TextStyle(fontSize:16,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldPrimaryColor=const TextStyle(fontSize:16,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

 static const TextStyle xMediumRegularPrimaryColor=const TextStyle(fontSize:20,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumPrimaryColor=const TextStyle(fontSize:20,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldPrimaryColor=const TextStyle(fontSize:20,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);



  static const TextStyle tinyRegularSecondaryColorLight=const TextStyle(fontSize:12,color: AppColors.SecondaryColorLight,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumSecondaryColorLight=const TextStyle(fontSize:12,color: AppColors.SecondaryColorLight,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldSecondaryColorLight=const TextStyle(fontSize:12,color: AppColors.SecondaryColorLight,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularSecondaryColorLight=const TextStyle(fontSize:14,color: AppColors.SecondaryColorLight,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumSecondaryColorLight=const TextStyle(fontSize:14,color: AppColors.SecondaryColorLight,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldSecondaryColorLight=const TextStyle(fontSize:14,color: AppColors.SecondaryColorLight,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularSecondaryColorLight=const TextStyle(fontSize:16,color: AppColors.SecondaryColorLight,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumSecondaryColorLight=const TextStyle(fontSize:16,color: AppColors.SecondaryColorLight,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldSecondaryColorLight=const TextStyle(fontSize:16,color: AppColors.SecondaryColorLight,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularSecondaryColorLight=const TextStyle(fontSize:20,color: AppColors.SecondaryColorLight,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumSecondaryColorLight=const TextStyle(fontSize:20,color: AppColors.SecondaryColorLight,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldSecondaryColorLight=const TextStyle(fontSize:20,color: AppColors.SecondaryColorLight,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularSecondaryColorLight=const TextStyle(fontSize:26,color: AppColors.SecondaryColorLight,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumSecondaryColorLight=const TextStyle(fontSize:26,color: AppColors.SecondaryColorLight,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldSecondaryColorLight=const TextStyle(fontSize:26,color: AppColors.SecondaryColorLight,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);


  static const TextStyle tinyRegularTextFourth=const TextStyle(fontSize:12,color: AppColors.TextFourth,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextFourth=const TextStyle(fontSize:12,color: AppColors.TextFourth,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextFourth=const TextStyle(fontSize:12,color: AppColors.TextFourth,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextFourth=const TextStyle(fontSize:14,color: AppColors.TextFourth,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextFourth=const TextStyle(fontSize:14,color: AppColors.TextFourth,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextFourth=const TextStyle(fontSize:14,color: AppColors.TextFourth,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextFourth=const TextStyle(fontSize:16,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextFourth=const TextStyle(fontSize:16,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextFourth=const TextStyle(fontSize:16,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTextFourth=const TextStyle(fontSize:20,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextFourth=const TextStyle(fontSize:20,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextFourth=const TextStyle(fontSize:20,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextFourth=const TextStyle(fontSize:26,color: AppColors.TextFourth,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextFourth=const TextStyle(fontSize:26,color: AppColors.TextFourth,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextFourth=const TextStyle(fontSize:26,color: AppColors.TextFourth,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

}