import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/profile/edit_profile_options_view.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';
import 'package:queschat/authentication/profile/profile_events.dart';
import 'package:queschat/authentication/profile/profile_state.dart';
import 'package:queschat/authentication/profile/profile_view.dart';
import 'package:queschat/bloc/session_cubit.dart';
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
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) =>
            SessionCubit(authRepo: context.read<AuthRepository>()),
        child: BlocProvider(
          create: (context) =>
              AuthCubit(sessionCubit: context.read<SessionCubit>()),
          child: BlocProvider(
            create: (context) =>
                ProfileBloc(
                  authRepo: context.read<AuthRepository>(),
                  authCubit: context.read<AuthCubit>(),
                ),
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
                              Padding(
                                padding:
                                EdgeInsets.only(top: 56, left: 20, bottom: 50),
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height * .1,
                                      width: height * .1,
                                      // color: Colors.green,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              state.imageUrl),

                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(state.name,
                                        style: TextStyles.largeBoldWhite)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children: [
                                    ActiveInactiveButton(
                                        icon: Image.asset(
                                            "images/user_profile.png"),
                                        text: "Profile",
                                        isActive: true,
                                        action: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                    value: context.read<
                                                        ProfileBloc>(),
                                                    child: ProfileView(),
                                                  ),
                                            ),
                                          );
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ProfileView()));
                                        }),
                                    ActiveInactiveButton(
                                        icon: Image.asset(
                                            "images/multiple.png"),
                                        text: "Create Group",
                                        isActive: false,
                                        action: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateGroupStage1()));
                                        }),
                                    ActiveInactiveButton(
                                        icon: Image.asset("images/group.png"),
                                        text: "Create Channel",
                                        isActive: false,
                                        action: () {}),
                                    ActiveInactiveButton(
                                        icon: Image.asset(
                                            "images/notifications.png"),
                                        text: "Notification",
                                        isActive: false,
                                        action: () {}),
                                    ActiveInactiveButton(
                                        icon: Image.asset(
                                            "images/settings_gear.png"),
                                        text: "Settings",
                                        isActive: false,
                                        action: () {})
                                  ],
                                ),
                              ),
                              ActiveInactiveButton(
                                  text: "Log Out",
                                  isActive: false,
                                  action: () {
                                    // Navigator.of(context).pop();
                                    context.read<SessionCubit>().logOut();
                                  }),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );
                      }
                  ),
                ),
              ),
            ),
          ),
        ),
      ),


    );
  }
}
