import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors{

  static const PrimaryColor =  Color(0xff004C93);
  static const PrimaryColorLight =  Color(0xff0d64b5);
  static const SecondaryColorLight =  Color(0xff6694c0);
  static const Tertiary =  Color(0xff6694c0);
  static const IconColor =  Color(0xff727C8E);

  static const SecondaryLight =  Color(0xffF9FAFC);
  static const ShadowColor =  Color(0xffedeef0);
  static const BorderColor =  Color(0xffDBDBDB);
  static const RedPrimary =  Color(0xffED5B6C);
  static const RedSecondary =  Color(0xffF49FA9);
  static const GreenPrimary =  Color(0xff45B97C);
  static const GreenSecondary =  Color(0xff51B167);
  static const StatusBar =  Color(0xffF5F5F5);

  static const TextPrimary=  Color(0xff00264A);
  static const TextSecondary =  Color(0xff333333);
  static const TextTertiary=  Color(0xff82878A);
  static const TextError=  Colors.red;

  static const TextFourth=  Color(0xff606060);

  static const White=  Color(0xFFFFFFFF);

}

class AppBorders {
  static const OutlineInputBorder transparentBorder= const OutlineInputBorder(
  borderSide: BorderSide(
  color:Colors.transparent));
}
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

  static const TextStyle largeRegularTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);




  static const TextStyle tinyRegularTertiary=const TextStyle(fontSize:12,color: AppColors.Tertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTertiary=const TextStyle(fontSize:12,color: AppColors.Tertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTertiary=const TextStyle(fontSize:12,color: AppColors.Tertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTertiary=const TextStyle(fontSize:14,color: AppColors.Tertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTertiary=const TextStyle(fontSize:14,color: AppColors.Tertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTertiary=const TextStyle(fontSize:14,color: AppColors.Tertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTertiary=const TextStyle(fontSize:16,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTertiary=const TextStyle(fontSize:16,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTertiary=const TextStyle(fontSize:16,color: AppColors.Tertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

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

  static const TextStyle largeRegularPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

}