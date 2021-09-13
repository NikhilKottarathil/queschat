import 'package:flutter/material.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/authentication/screens/LoginPage.dart';
import 'package:queschat/pages/create_group_stage_1.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[AppColors.PrimaryColorLight, AppColors.PrimaryColor],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(45),
        topRight: Radius.circular(45),
      ),
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * .8,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Drawer(
          elevation: 10,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * .8,
            height: MediaQuery
                .of(context)
                .size
                .height,
            padding: EdgeInsets.all(35),
            decoration: new BoxDecoration(
              // color: AppColors.PrimaryColor,
              // gradient: Gradient(colors: [AppColors.PrimaryColor,AppColors.TextSecondary],),
              gradient: new LinearGradient(
                  colors: [
                   AppColors.PrimaryColor,
                    AppColors.TextSecondary
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * .1, left: 15),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .20,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .1,
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * .1,
                        // color: Colors.green,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRuJdRZgCdojDsemBQqxOAg9UAGIYem6inQg&usqp=CAU"),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("User Name",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .48,
                  child: ListView(
                    children: [
                      ActiveInactiveButton(
                          icon: Image.asset("images/user_profile.png"),
                          text: "Profile",
                          isActive: true,
                          action: () {}),
                      ActiveInactiveButton(
                          icon: Image.asset("images/multiple.png"),
                          text: "Create Group",
                          isActive: false,
                          action: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CreateGroupStage1()));
                          }),
                      ActiveInactiveButton(
                          icon: Image.asset("images/group.png"),
                          text: "Create Channel",
                          isActive: false,
                          action: () {}),
                      ActiveInactiveButton(
                          icon: Image.asset("images/notifications.png"),
                          text: "Notification",
                          isActive: false,
                          action: () {}),
                      ActiveInactiveButton(
                          icon: Image.asset("images/settings_gear.png"),
                          text: "Settings",
                          isActive: false,
                          action: () {})
                    ],
                  ),
                ),
                Container(
                  child: ActiveInactiveButton(
                      text: "Log Out", isActive: false, action: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => LoginPage()));
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
