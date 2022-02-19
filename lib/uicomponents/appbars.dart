import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_cubit.dart';
import 'package:queschat/home/in_app_notification/notification_count_widget.dart';
import 'package:queschat/home/message/new_chat/new_chat_cubit.dart';
import 'package:queschat/home/message/new_chat/new_chat_view.dart';
import 'package:queschat/router/app_router.dart';
import 'custom_ui_widgets.dart';


Widget homeAppBar(BuildContext context) {
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
        onPressed: () async {

          if (await Permission.contacts.isGranted) {

            Navigator.push(context, MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => NewChatCubit(authRepo: authRepository),
                child: NewChatView(),
              ),
            ));
          } else {
            await [Permission.contacts].request();
          }
        },
        icon: new Image.asset("images/open.png",height: 24,width: 24,),
        padding: EdgeInsets.all(10),
      ),
      NotificationCountWidget(),

    ],
  );
}


Widget appBarWithBackButton({BuildContext context,String titleString,Function action,var tailActions,bool isCenterTitle}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: .5,
    shadowColor: AppColors.ShadowColor,
    centerTitle: isCenterTitle!=null?isCenterTitle:true,
    actions:tailActions,
    iconTheme: IconThemeData(color: AppColors.IconColor),
    title: Text(titleString,style: TextStyle(fontSize: 20,color: AppColors.TextSecondary),),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.IconColor),
      onPressed:(){
        action!=null?action():Navigator.of(context).pop();
      },
    ),

  );
}

// for default leading button function
// Widget appBarWithBackButton({BuildContext context,String titleString,Function action}) {
//   return AppBar(
//     backgroundColor: Colors.white,
//     elevation: 1,
//     centerTitle: true,
//     iconTheme: IconThemeData(color: AppColors.IconColor),
//     title: Text(titleString,style: TextStyle(fontSize: 20,color: AppColors.TextSecondary),),
//     automaticallyImplyLeading: true,
//
//     leading:action!=null? IconButton(
//       icon: Icon(Icons.arrow_back, color: AppColors.IconColor),
//
//       onPressed:(){
//         action();
//       },
//     ):null,
//   );
// }


Widget appBarForProfile({BuildContext context,String titleString,String imageUrl}) {
  return
    AppBar(
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
                  imageUrl!=null?imageUrl:Urls().personUrl),
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
