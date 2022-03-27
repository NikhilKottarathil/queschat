import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors{
  // 0xFF154179
  static const PrimaryColor =  Color(0xff1F4869);
  static const PrimaryColorDark =  Color(0xff0B3455);
  static const PrimaryColorLight =  Color(0xff3D6687);

  static const SecondaryColor =  Color(0xff367CB5);

  static const PrimaryLighter =  Color(0xffBCE0FD);
  static const PrimaryLightest =  Color(0xffF5FAFF);



  static const TextPrimary =  Color(0xff151617);
  static const TextSecondary =  Color(0xff4F4F4F);
  static const TextTertiary=  Color(0xff8B8C8C);
  static const TextFourth=  Color(0xffCCCCCC);
  static const TextFifth=  Color(0xffEAEAEA);
  static const TextSixth=  Color(0xffF9F8F9);
  static const TextSeven=  Color(0xffF8F6F5);
  static const TextError=  Colors.red;

  static const BorderColor =  Color(0xffEAEAEA);
  static const IconColor =  Color(0xff8B8C8C);
  static const ShadowColor =  Color(0xffedeef0);
  static const StatusBar =  Color(0xffF5F5F5);



  static const RedPrimary =  Color(0xffED5B6C);
  static const RedSecondary =  Color(0xffF49FA9);
  static const GreenPrimary =  Color(0xff45B97C);
  static const GreenSecondary =  Color(0xff51B177);

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


  static const TextStyle heading1Primary=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle heading2Primary=const TextStyle(fontSize:22,color: AppColors.PrimaryColor,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle subTitle1Primary=const TextStyle(fontSize:17,color: AppColors.PrimaryColor,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subTitle2Primary=const TextStyle(fontSize:15,color: AppColors.PrimaryColor,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle bodyPrimary=const TextStyle(fontSize:15,color: AppColors.PrimaryColor,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subBodyPrimary=const TextStyle(fontSize:13,color: AppColors.PrimaryColor,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle buttonPrimary=const TextStyle(fontSize:15,color: AppColors.PrimaryColor,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);


  static const TextStyle heading1White=const TextStyle(fontSize:26,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle heading2White=const TextStyle(fontSize:22,color: AppColors.White,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle subTitle1White=const TextStyle(fontSize:17,color: AppColors.White,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subTitle2White=const TextStyle(fontSize:15,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle bodyWhite=const TextStyle(fontSize:15,color: AppColors.White,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subBodyWhite=const TextStyle(fontSize:13,color: AppColors.White,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle buttonWhite=const TextStyle(fontSize:15,color: AppColors.White,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);


  static const TextStyle heading1TextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle heading2TextPrimary=const TextStyle(fontSize:22,color: AppColors.TextPrimary,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle subTitle1TextPrimary=const TextStyle(fontSize:17,color: AppColors.TextPrimary,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subTitle2TextPrimary=const TextStyle(fontSize:15,color: AppColors.TextPrimary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle bodyTextPrimary=const TextStyle(fontSize:15,color: AppColors.TextPrimary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subBodyTextPrimary=const TextStyle(fontSize:13,color: AppColors.TextPrimary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle buttonTextPrimary=const TextStyle(fontSize:15,color: AppColors.TextPrimary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);


  static const TextStyle heading1TextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle heading2TextSecondary=const TextStyle(fontSize:22,color: AppColors.TextSecondary,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle subTitle1TextSecondary=const TextStyle(fontSize:17,color: AppColors.TextSecondary,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subTitle2TextSecondary=const TextStyle(fontSize:15,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle bodyTextSecondary=const TextStyle(fontSize:15,color: AppColors.TextSecondary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subBodyTextSecondary=const TextStyle(fontSize:13,color: AppColors.TextSecondary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle buttonTextSecondary=const TextStyle(fontSize:15,color: AppColors.TextSecondary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);







  static const TextStyle heading1TextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle heading2TextTertiary=const TextStyle(fontSize:22,color: AppColors.TextTertiary,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle subTitle1TextTertiary=const TextStyle(fontSize:17,color: AppColors.TextTertiary,height:1.15,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subTitle2TextTertiary=const TextStyle(fontSize:15,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle bodyTextTertiary=const TextStyle(fontSize:15,color: AppColors.TextTertiary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle subBodyTextTertiary=const TextStyle(fontSize:13,color: AppColors.TextTertiary,height:1.25,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle ButtonTextTertiary=const TextStyle(fontSize:15,color: AppColors.TextTertiary,height:1.2,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);


  // static const TextStyle mediumRegularTextPrimary=const TextStyle(fontSize:17,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  // static const TextStyle mediumMediumTextPrimary=const TextStyle(fontSize:17,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  // static const TextStyle mediumBoldTextPrimary=const TextStyle(fontSize:17,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  // static const TextStyle xMediumRegularTextPrimary=const TextStyle(fontSize:22,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  // static const TextStyle xMediumMediumTextPrimary=const TextStyle(fontSize:22,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  // static const TextStyle xMediumBoldTextPrimary=const TextStyle(fontSize:22,color: AppColors.TextPrimary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  // static const TextStyle largeRegularTextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  // static const TextStyle largeMediumTextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  // static const TextStyle largeBoldTextPrimary=const TextStyle(fontSize:26,color: AppColors.TextPrimary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);






  static const TextStyle tinyRegularTextSecondary=const TextStyle(fontSize:12,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextSecondary=const TextStyle(fontSize:12,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextSecondary=const TextStyle(fontSize:12,color: AppColors.TextSecondary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextSecondary=const TextStyle(fontSize:15,color: AppColors.TextSecondary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextSecondary=const TextStyle(fontSize:15,color: AppColors.TextSecondary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextSecondary=const TextStyle(fontSize:15,color: AppColors.TextSecondary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextSecondary=const TextStyle(fontSize:17,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextSecondary=const TextStyle(fontSize:17,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextSecondary=const TextStyle(fontSize:17,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

 static const TextStyle xMediumRegularTextSecondary=const TextStyle(fontSize:22,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextSecondary=const TextStyle(fontSize:22,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextSecondary=const TextStyle(fontSize:22,color: AppColors.TextSecondary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextSecondary=const TextStyle(fontSize:26,color: AppColors.TextSecondary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);





  static const TextStyle tinyRegularTextTertiary=const TextStyle(fontSize:12,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextTertiary=const TextStyle(fontSize:12,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextTertiary=const TextStyle(fontSize:12,color: AppColors.TextTertiary,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextTertiary=const TextStyle(fontSize:15,color: AppColors.TextTertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextTertiary=const TextStyle(fontSize:15,color: AppColors.TextTertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextTertiary=const TextStyle(fontSize:15,color: AppColors.TextTertiary,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextTertiary=const TextStyle(fontSize:17,color: AppColors.TextTertiary,height:1.4,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextTertiary=const TextStyle(fontSize:17,color: AppColors.TextTertiary,height:1.4,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextTertiary=const TextStyle(fontSize:17,color: AppColors.TextTertiary,height:1.4,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTextTertiary=const TextStyle(fontSize:22,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextTertiary=const TextStyle(fontSize:22,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextTertiary=const TextStyle(fontSize:22,color: AppColors.TextTertiary,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextTertiary=const TextStyle(fontSize:26,color: AppColors.TextTertiary,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);






  static const TextStyle tinyRegularTertiary=const TextStyle(fontSize:12,color: AppColors.SecondaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTertiary=const TextStyle(fontSize:12,color: AppColors.SecondaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTertiary=const TextStyle(fontSize:12,color: AppColors.SecondaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTertiary=const TextStyle(fontSize:15,color: AppColors.SecondaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTertiary=const TextStyle(fontSize:15,color: AppColors.SecondaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTertiary=const TextStyle(fontSize:15,color: AppColors.SecondaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTertiary=const TextStyle(fontSize:17,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTertiary=const TextStyle(fontSize:17,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTertiary=const TextStyle(fontSize:17,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTertiary=const TextStyle(fontSize:22,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTertiary=const TextStyle(fontSize:22,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTertiary=const TextStyle(fontSize:22,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTertiary=const TextStyle(fontSize:26,color: AppColors.SecondaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTertiary=const TextStyle(fontSize:26,color: AppColors.SecondaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTertiary=const TextStyle(fontSize:26,color: AppColors.SecondaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);





  static const TextStyle tinyRegularWhite=const TextStyle(fontSize:12,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumWhite=const TextStyle(fontSize:12,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldWhite=const TextStyle(fontSize:12,color: AppColors.White,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularWhite=const TextStyle(fontSize:15,color: AppColors.White,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumWhite=const TextStyle(fontSize:15,color: AppColors.White,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldWhite=const TextStyle(fontSize:15,color: AppColors.White,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularWhite=const TextStyle(fontSize:17,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumWhite=const TextStyle(fontSize:17,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldWhite=const TextStyle(fontSize:17,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

 static const TextStyle xMediumRegularWhite=const TextStyle(fontSize:22,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumWhite=const TextStyle(fontSize:22,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldWhite=const TextStyle(fontSize:22,color: AppColors.White,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularWhite=const TextStyle(fontSize:26,color: AppColors.White,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumWhite=const TextStyle(fontSize:26,color: AppColors.White,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldWhite=const TextStyle(fontSize:26,color: AppColors.White,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);




  static const TextStyle tinyRegularPrimaryColor=const TextStyle(fontSize:12,color: AppColors.PrimaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumPrimaryColor=const TextStyle(fontSize:12,color: AppColors.PrimaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldPrimaryColor=const TextStyle(fontSize:12,color: AppColors.PrimaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularPrimaryColor=const TextStyle(fontSize:15,color: AppColors.PrimaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumPrimaryColor=const TextStyle(fontSize:15,color: AppColors.PrimaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldPrimaryColor=const TextStyle(fontSize:15,color: AppColors.PrimaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularPrimaryColor=const TextStyle(fontSize:17,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumPrimaryColor=const TextStyle(fontSize:17,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldPrimaryColor=const TextStyle(fontSize:17,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

 static const TextStyle xMediumRegularPrimaryColor=const TextStyle(fontSize:22,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumPrimaryColor=const TextStyle(fontSize:22,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldPrimaryColor=const TextStyle(fontSize:22,color: AppColors.PrimaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldPrimaryColor=const TextStyle(fontSize:26,color: AppColors.PrimaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);



  static const TextStyle tinyRegularSecondaryColor=const TextStyle(fontSize:12,color: AppColors.SecondaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumSecondaryColor=const TextStyle(fontSize:12,color: AppColors.SecondaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldSecondaryColor=const TextStyle(fontSize:12,color: AppColors.SecondaryColor,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularSecondaryColor=const TextStyle(fontSize:15,color: AppColors.SecondaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumSecondaryColor=const TextStyle(fontSize:15,color: AppColors.SecondaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldSecondaryColor=const TextStyle(fontSize:15,color: AppColors.SecondaryColor,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularSecondaryColor=const TextStyle(fontSize:17,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumSecondaryColor=const TextStyle(fontSize:17,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldSecondaryColor=const TextStyle(fontSize:17,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularSecondaryColor=const TextStyle(fontSize:22,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumSecondaryColor=const TextStyle(fontSize:22,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldSecondaryColor=const TextStyle(fontSize:22,color: AppColors.SecondaryColor,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularSecondaryColor=const TextStyle(fontSize:26,color: AppColors.SecondaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumSecondaryColor=const TextStyle(fontSize:26,color: AppColors.SecondaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldSecondaryColor=const TextStyle(fontSize:26,color: AppColors.SecondaryColor,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);


  static const TextStyle tinyRegularTextFourth=const TextStyle(fontSize:12,color: AppColors.TextFourth,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextFourth=const TextStyle(fontSize:12,color: AppColors.TextFourth,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextFourth=const TextStyle(fontSize:12,color: AppColors.TextFourth,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextFourth=const TextStyle(fontSize:15,color: AppColors.TextFourth,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextFourth=const TextStyle(fontSize:15,color: AppColors.TextFourth,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextFourth=const TextStyle(fontSize:15,color: AppColors.TextFourth,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextFourth=const TextStyle(fontSize:17,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextFourth=const TextStyle(fontSize:17,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextFourth=const TextStyle(fontSize:17,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTextFourth=const TextStyle(fontSize:22,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextFourth=const TextStyle(fontSize:22,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextFourth=const TextStyle(fontSize:22,color: AppColors.TextFourth,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextFourth=const TextStyle(fontSize:26,color: AppColors.TextFourth,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextFourth=const TextStyle(fontSize:26,color: AppColors.TextFourth,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextFourth=const TextStyle(fontSize:26,color: AppColors.TextFourth,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);





  static const TextStyle tinyRegularTextError=const TextStyle(fontSize:12,color: AppColors.TextError,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle tinyMediumTextError=const TextStyle(fontSize:12,color: AppColors.TextError,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle tinyBoldTextError=const TextStyle(fontSize:12,color: AppColors.TextError,height:1.1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle smallRegularTextError=const TextStyle(fontSize:15,color: AppColors.TextError,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle smallMediumTextError=const TextStyle(fontSize:15,color: AppColors.TextError,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle smallBoldTextError=const TextStyle(fontSize:15,color: AppColors.TextError,height:1.43,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle mediumRegularTextError=const TextStyle(fontSize:17,color: AppColors.TextError,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle mediumMediumTextError=const TextStyle(fontSize:17,color: AppColors.TextError,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle mediumBoldTextError=const TextStyle(fontSize:17,color: AppColors.TextError,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle xMediumRegularTextError=const TextStyle(fontSize:22,color: AppColors.TextError,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle xMediumMediumTextError=const TextStyle(fontSize:22,color: AppColors.TextError,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle xMediumBoldTextError=const TextStyle(fontSize:22,color: AppColors.TextError,height:1,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

  static const TextStyle largeRegularTextError=const TextStyle(fontSize:26,color: AppColors.TextError,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w400);
  static const TextStyle largeMediumTextError=const TextStyle(fontSize:26,color: AppColors.TextError,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w500);
  static const TextStyle largeBoldTextError=const TextStyle(fontSize:26,color: AppColors.TextError,height:1.33,fontFamily: 'NunitoSans',fontWeight: FontWeight.w700);

}