import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_view.dart';
import 'package:queschat/authentication/profile/my_feeds.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';
import 'package:queschat/authentication/profile/profile_events.dart';
import 'package:queschat/authentication/profile/profile_state.dart';
import 'package:queschat/authentication/profile/saved_feeds.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/main.dart';
import 'package:queschat/router/app_router.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => profileBloc,

      child: Scaffold(
        // appBar: appBarWithBackButton(
        //     context: context,
        //     titleString: 'Profile',
        //     isCenterTitle: false,
        //     prefixIcon: Icon(Icons.close, color: AppColors.IconColor),
        //     // tailActions: [
        //     //   TextButton(
        //     //       onPressed: () {
        //     //         Navigator.of(context).push(MaterialPageRoute(
        //     //           builder: (_) => EditProfileOptionView(),
        //     //         ));
        //     //       },
        //     //       child: Text('Edit',
        //     //           style: TextStyle(
        //     //               color: Color(0xFF004C93),
        //     //               fontFamily: 'NunitoSans',
        //     //               fontWeight: FontWeight.w700,
        //     //               fontSize: 14))),
        //     // ],
        //     action: () {
        //       profileBloc.add(FetchInitialFeeds());
        //       Navigator.of(context).pop();
        //     }),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColoredBox(
                  // color: AppColors.TextFifth,
                  color: AppColors.PrimaryColorLight,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        height: MediaQuery.of(context).size.width * .3,
                        child: Stack(
                          children: [
                            state.imageUrl != null
                                ? CircleAvatar(
                                    backgroundColor: AppColors.White,
                                    radius:
                                        MediaQuery.of(context).size.width * .3,
                                    backgroundImage:
                                        NetworkImage(state.imageUrl.toString()),
                                  )
                                : CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                      size:
                                          MediaQuery.of(context).size.width * .15,
                                      color: AppColors.IconColor,
                                    ),
                                    backgroundColor: AppColors.White,
                                    radius:
                                        MediaQuery.of(context).size.width * .15,
                                  ),
                            Align(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      profileBloc.add(
                                          ChangeProfilePicture(context: context));
                                    },
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: AppColors.White,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 20,
                                        color: AppColors.PrimaryColorLight,
                                      ),
                                    )),
                              ),
                              alignment: Alignment.bottomRight,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 14.0),
                    child: Text(
                      state.name,
                      style: TextStyles.subTitle1TextPrimary,
                    ),
                  ),
                ),
                Flexible(
                  child: Visibility(
                    visible: state.bio != null,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8.0, bottom: 4),
                      child: Text(
                        state.bio != null ? state.bio : '',
                        style: TextStyles.bodyTextSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(MyApp.navigatorKey.currentContext).push(
                          MaterialPageRoute(
                            builder: (_) => EditProfileView(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side:
                            BorderSide(width: 1.0, color: AppColors.PrimaryColor),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'EDIT PROFILE',
                              style: TextStyles.buttonPrimary,
                            ),
                          ),
                        ),
                      )),
                ),

                SizedBox(height: 10,),
                dividerDefault,

                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'images/feed_nav_icon.png',
                            width: 24,
                            height: 24,
                            color: AppColors.IconColor,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            'My Feeds',
                            style: TextStyles.smallMediumTextSecondary,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.IconColor,
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(MyApp.navigatorKey.currentContext).push(
                      MaterialPageRoute(builder: (_) => MyFeeds()),
                    );
                  },
                ),
                dividerDefault,
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: AppColors.IconColor,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            'Saved Feeds',
                            style: TextStyles.smallMediumTextSecondary,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.IconColor,
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(MyApp.navigatorKey.currentContext).push(
                      MaterialPageRoute(builder: (_) => SavedFeeds()),
                    );
                  },
                ),
                dividerDefault,

                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, padding: EdgeInsets.all(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'images/reward.png',
                            width: 22,
                            height: 22,
                            color: AppColors.IconColor,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            'Rewards & Points',
                            style: TextStyles.smallMediumTextSecondary,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.IconColor,
                      )
                    ],
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
