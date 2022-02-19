import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_cubit.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_view_select_users.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/profile/edit_profile_options_view.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';
import 'package:queschat/authentication/profile/profile_events.dart';
import 'package:queschat/authentication/profile/profile_state.dart';
import 'package:queschat/authentication/profile/profile_view.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => profileBloc,
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
            child: SizedBox(
              width: width * .8,
              child: Drawer(
                elevation: 10,
                child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                  return Container(
                    height: height,
                    padding: EdgeInsets.all(20),
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            AppColors.PrimaryColor,
                            AppColors.TextPrimary
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.White,
                                size: 28,
                              )),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 32, left: 20, bottom: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(state.imageUrl),
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(height: 14),
                              Text(state.name, style: TextStyles.largeBoldWhite)
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              ActiveInactiveButton(
                                  icon: Image.asset(
                                    "images/user_profile.png",
                                    color: AppColors.White,
                                  ),
                                  text: "Profile",
                                  isActive: true,
                                  action: () {
                                    Navigator.pushNamed(context, '/profile');
                                  }),
                              ActiveInactiveButton(
                                  icon: Image.asset(
                                    "images/multiple.png",
                                    color: AppColors.White,
                                  ),
                                  text: "Create Group",
                                  isActive: false,
                                  action: () async {
                                    if (await Permission.contacts.isGranted) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                              create: (context) =>
                                                  NewGroupCubit(
                                                      authRepo: authRepository,
                                                      isGroupOrChannel:
                                                          'group'),
                                              child: NewGroupViewSelectUsers(),
                                            ),
                                          ));
                                    } else {
                                      await [Permission.contacts].request();
                                    }
                                  }),
                              ActiveInactiveButton(
                                  icon: Image.asset(
                                    "images/group.png",
                                    color: AppColors.White,
                                  ),
                                  text: "Create Channel",
                                  isActive: false,
                                  action: () async {
                                    if (await Permission.contacts.isGranted) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                              create: (context) =>
                                                  NewGroupCubit(
                                                      authRepo: authRepository,
                                                      isGroupOrChannel:
                                                          'channel'),
                                              child: NewGroupViewSelectUsers(),
                                            ),
                                          ));
                                    } else {
                                      await [Permission.contacts].request();
                                    }
                                  }),
                              ActiveInactiveButton(
                                  icon: Image.asset(
                                    "images/notifications.png",
                                    color: AppColors.White,
                                  ),
                                  text: "Notification",
                                  isActive: false,
                                  action: () {
                                    Navigator.pushNamed(
                                        context, '/inAppNotifications');
                                  }),
                              ActiveInactiveButton(
                                  icon: Image.asset(
                                    "images/settings_gear.png",
                                    color: AppColors.White,
                                  ),
                                  text: "Settings",
                                  isActive: false,
                                  action: () {}),
                              // TextButton(
                              //   onPressed: () async {
                              //
                              //     String channelKey='basic_channel';
                              //
                              //     List<NotificationPermission> permissionsNeeded =[
                              //       NotificationPermission.Alert,
                              //       NotificationPermission.Sound,
                              //       NotificationPermission.Badge,
                              //       NotificationPermission.Vibration,
                              //       NotificationPermission.Light,
                              //     ];
                              //     // Request the permission through native resources. Only one page redirection is done at this point.
                              //     await AwesomeNotifications().requestPermissionToSendNotifications(
                              //         channelKey:channelKey,
                              //         permissions: permissionsNeeded
                              //     );
                              //
                              //     // After the user come back, check if the permissions has successfully enabled
                              //     // permissionsNeeded = await AwesomeNotifications().checkPermissionList(
                              //     //     channelKey: channelKey,
                              //     //     permissions: permissionsNeeded
                              //     // );
                              //
                              //     Navigator.pop(context);
                              //   },
                              //   child: Text(
                              //     'Allow',
                              //     style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        ActiveInactiveButton(
                            text: "Log Out",
                            icon: Image.asset("images/logout.png"),
                            isActive: false,
                            action: () async {
                              AuthRepository authRepo = AuthRepository();
                              await authRepo.logOut();
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/');
                            }),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
