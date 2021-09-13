import 'package:flutter/material.dart';
import 'package:queschat/components/drawer.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/pages/new_message.dart';
import 'custom_ui_widgets.dart';


Widget appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.IconColor),
    title: AppName(
        textAlign: TextAlign.center,
        size: MediaQuery.of(context).size.height * .035),
    actions: <Widget>[
      new IconButton(
        onPressed: (){
          print("sdgjs");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewMessage()));
        },
        icon: new Image.asset("images/open.png"),
        padding: EdgeInsets.all(10),
      ),
      new IconButton(
        icon: new Icon(Icons.notifications_none_outlined,
            color: AppColors.IconColor),
        iconSize: MediaQuery.of(context).size.height * .035,

      ),
    ],
  );
}


Widget appBarWithBackButton(BuildContext context,String titleString) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.IconColor),
    title: Text(titleString,style: TextStyle(fontSize: 20,color: AppColors.TextSecondary),),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.IconColor),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}


Widget appBarForProfile(BuildContext context,String titleString) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: .5,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.IconColor),
    title: Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 10),

          height: MediaQuery.of(context).size.height *.05,
          width: MediaQuery.of(context).size.height * .05,
          // color: Colors.green,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "http://img-cdn.tid.al/o/6dc39fec4427c4f9f759c1f2c44137bec7366e4c.png"),
            ),
          ),
        ),
        Text(titleString,style: TextStyle(fontSize: 20,color: AppColors.TextSecondary)),
      ],
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.IconColor,),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}
