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
import 'package:queschat/uicomponents/appbars.dart';

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.name,
                          style: TextStyles.subTitle1TextPrimary,
                        ),
                        // Text(
                        //   state.phoneNumber,
                        //   style: TextStyles.bodyTextSecondary,
                        // ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: state.bio != null,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 8.0, bottom: 4),
                    child: Flexible(
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
                // Visibility(
                //   visible: state.bio != null ||
                //       state.facebookLink != null ||
                //       state.instagramLink != null ||
                //       state.linkedinLink != null ||
                //       state.birthDate != null,
                //   child: Container(
                //     padding: const EdgeInsets.only(
                //         left: 20, right: 20, top: 20.0, bottom: 20),
                //     color: AppColors.White,
                //     width: width,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Visibility(
                //           visible: state.bio != null,
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 'About me :  ',
                //                 style: TextStyles.smallRegularTextTertiary,
                //               ),
                //               Flexible(
                //                 child: Text(
                //                   state.bio != null ? state.bio : '',
                //                   style: TextStyles.smallRegularTextSecondary,
                //                   textAlign: TextAlign.start,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         Visibility(
                //           visible: state.birthDate != null,
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 'DOB :  ',
                //                 style: TextStyles.smallRegularTextTertiary,
                //               ),
                //               Text(
                //                 // state.name,
                //                 state.birthDate != null
                //                     ? getDisplayDate(state.birthDate)
                //                     : '',
                //                 style: TextStyles.smallRegularTextSecondary,
                //                 textAlign: TextAlign.start,
                //               ),
                //             ],
                //           ),
                //         ),
                //         // Visibility(
                //         //   visible: state.facebookLink != null,
                //         //   child: Column(
                //         //     children: [
                //         //       SizedBox(
                //         //         height: 10,
                //         //       ),
                //         //       Row(
                //         //         crossAxisAlignment: CrossAxisAlignment.center,
                //         //         children: [
                //         //           Image.asset(
                //         //             'images/facebook_logo.png',
                //         //             width: 18,
                //         //             height: 18,
                //         //             fit: BoxFit.contain,
                //         //           ),
                //         //           SizedBox(
                //         //             width: 6,
                //         //           ),
                //         //           Flexible(
                //         //             child: Text(
                //         //               state.facebookLink != null
                //         //                   ? state.facebookLink
                //         //                   : '',
                //         //               style: TextStyles.smallRegularTextTertiary,
                //         //               textAlign: TextAlign.center,
                //         //               maxLines: 1,
                //         //               overflow: TextOverflow.ellipsis,
                //         //             ),
                //         //           ),
                //         //           SizedBox(
                //         //             width: 4,
                //         //           ),
                //         //           GestureDetector(
                //         //             child: Icon(
                //         //               Icons.copy,
                //         //               size: 14,
                //         //               color: AppColors.IconColor,
                //         //             ),
                //         //             onTap: () {
                //         //               copyTextFromField(state.facebookLink);
                //         //             },
                //         //           )
                //         //         ],
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // Visibility(
                //         //   visible: state.instagramLink != null,
                //         //   child: Column(
                //         //     children: [
                //         //       SizedBox(
                //         //         height: 10,
                //         //       ),
                //         //       Row(
                //         //         crossAxisAlignment: CrossAxisAlignment.center,
                //         //         children: [
                //         //           Image.asset(
                //         //             'images/instagram_logo.png',
                //         //             width: 18,
                //         //             height: 18,
                //         //             fit: BoxFit.contain,
                //         //           ),
                //         //           SizedBox(
                //         //             width: 6,
                //         //           ),
                //         //           Flexible(
                //         //             child: Text(
                //         //               state.instagramLink != null
                //         //                   ? state.instagramLink
                //         //                   : '',
                //         //               style: TextStyles.smallRegularTextTertiary,
                //         //               textAlign: TextAlign.center,
                //         //               maxLines: 1,
                //         //               overflow: TextOverflow.ellipsis,
                //         //             ),
                //         //           ),
                //         //           SizedBox(
                //         //             width: 4,
                //         //           ),
                //         //           GestureDetector(
                //         //             child: Icon(
                //         //               Icons.copy,
                //         //               size: 14,
                //         //               color: AppColors.IconColor,
                //         //             ),
                //         //             onTap: () {
                //         //               copyTextFromField(state.instagramLink);
                //         //             },
                //         //           )
                //         //         ],
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //         // Visibility(
                //         //   visible: state.linkedinLink != null,
                //         //   child: Column(
                //         //     children: [
                //         //       SizedBox(
                //         //         height: 10,
                //         //       ),
                //         //       Row(
                //         //         crossAxisAlignment: CrossAxisAlignment.center,
                //         //         children: [
                //         //           Image.asset(
                //         //             'images/linkedin_logo.png',
                //         //             width: 18,
                //         //             height: 18,
                //         //             fit: BoxFit.contain,
                //         //           ),
                //         //           SizedBox(
                //         //             width: 6,
                //         //           ),
                //         //           Flexible(
                //         //             child: Text(
                //         //               state.linkedinLink != null
                //         //                   ? state.linkedinLink
                //         //                   : '',
                //         //               style: TextStyles.smallRegularTextTertiary,
                //         //               textAlign: TextAlign.center,
                //         //               maxLines: 1,
                //         //               overflow: TextOverflow.ellipsis,
                //         //             ),
                //         //           ),
                //         //           SizedBox(
                //         //             width: 4,
                //         //           ),
                //         //           GestureDetector(
                //         //             child: Icon(
                //         //               Icons.copy,
                //         //               size: 14,
                //         //               color: AppColors.IconColor,
                //         //             ),
                //         //             onTap: () {
                //         //               copyTextFromField(state.linkedinLink);
                //         //             },
                //         //           )
                //         //         ],
                //         //       ),
                //         //     ],
                //         //   ),
                //         // ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //     primary: Colors.white,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.bookmark_outline_sharp,
                    //         color: AppColors.IconColor,
                    //       ),
                    //       SizedBox(
                    //         width: 22,
                    //       ),
                    //       Text(
                    //         'Subscribed Channels',
                    //         style: TextStyles.smallMediumTextSecondary,
                    //       ),
                    //     ],
                    //   ),
                    //   onPressed: () {},
                    // ),
                    // dividerDefault,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
