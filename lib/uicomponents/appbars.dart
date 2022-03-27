import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/home/home_bloc.dart';
import 'package:queschat/home/home/home_state.dart';
import 'package:queschat/home/in_app_notification/notification_count_widget.dart';
import 'package:queschat/home/message/new_chat/new_chat_cubit.dart';
import 'package:queschat/home/message/new_chat/new_chat_view.dart';
import 'package:queschat/router/app_router.dart';

Widget homeAppBar(BuildContext context) {
  return AppBar(
    leadingWidth: 44,

    backgroundColor: Colors.white,
    elevation: .3,
    shadowColor: AppColors.ShadowColor,
    iconTheme: IconThemeData(color: AppColors.IconColor),
    leading: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Image.asset(
          'images/user.png',
          fit: BoxFit.scaleDown,
        ),
      ),
    ),
    titleSpacing: 32,
    // title: AppName(
    //     textAlign: TextAlign.center,
    //     size: MediaQuery.of(context).size.height * .035),
    title: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Text(
        state.tabIndex == 0
            ? 'All Chats'
            : state.tabIndex == 1
            ? 'Channels'
            : 'Feeds',
        style: TextStyles.heading2TextPrimary,
      );
    }),

    actions: <Widget>[
      new IconButton(
        onPressed: () async {
          if (await Permission.contacts.isGranted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BlocProvider(
                        create: (context) =>
                            NewChatCubit(authRepo: authRepository),
                        child: NewChatView(),
                      ),
                ));
          } else {
            await [Permission.contacts].request();
          }
        },
        icon: Image.asset(
          "images/add_box.png",
          height: 24,
          width: 24,
          color: AppColors.IconColor,
        ),
      ),
      NotificationCountWidget(),
    ],
  );
}

Widget appBarWithBackButton({BuildContext context,
  String titleString,
  Function action,
  Icon prefixIcon,
  var tailActions,
  bool isCenterTitle}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: .5,
    shadowColor: AppColors.ShadowColor,
    centerTitle: isCenterTitle != null ? isCenterTitle : true,
    actions: tailActions,
    iconTheme: IconThemeData(color: AppColors.IconColor),
    title: Text(
      titleString,
      style: TextStyles.heading2TextPrimary,
    ),
    leading: IconButton(
      icon: prefixIcon != null ? prefixIcon : Icon(
          Icons.arrow_back, color: AppColors.IconColor),
      onPressed: () {
        action != null ? action() : Navigator.of(context).pop();
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

Widget appBarForProfile(
    {BuildContext context, String titleString, String imageUrl}) {
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

            child: imageUrl != null
                ? CircleAvatar(
              radius: MediaQuery
                  .of(context)
                  .size
                  .height * .025,
              backgroundImage: NetworkImage(
                  imageUrl.toString()),
            )
                : CircleAvatar(
              radius: MediaQuery
                  .of(context)
                  .size
                  .height * .025,

              child: Image.asset('images/user_profile.png'),
            ),         ),

        Text(titleString,
            style: TextStyle(fontSize: 20, color: AppColors.TextSecondary)),
      ],
    ),
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.IconColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}
