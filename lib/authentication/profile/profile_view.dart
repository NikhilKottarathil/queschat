import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_view.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_view.dart';
import 'package:queschat/authentication/profile/edit_profile_options_view.dart';
import 'package:queschat/authentication/profile/my_feeds.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';
import 'package:queschat/authentication/profile/profile_state.dart';
import 'package:queschat/authentication/profile/profile_events.dart';
import 'package:queschat/authentication/profile/saved_feeds.dart';
import 'package:queschat/bloc/session_cubit.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/uicomponents/appbars.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBarWithBackButton(
          context: context,
          titleString: 'Profile',
          tailActions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: EditProfileOptionView(),
                    ),
                  ));
                },
                child: Text('Edit',
                    style: TextStyle(
                        color: Color(0xFF004C93),
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14))),
          ],
          action: () {
            context.read<ProfileBloc>().add(FetchInitialFeeds());
            Navigator.of(context).pop();
          }),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: width,
                    color: AppColors.PrimaryLightest,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(state.imageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 14.0, bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        state.name,
                        style: TextStyles.xMediumBoldTextSecondary,
                      ),
                      Text(
                        state.phoneNumber,
                        style: TextStyles.smallRegularTextTertiary,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: state.bio != null,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20.0, bottom: 20),
                  color: AppColors.White,
                  width: width,
                  child: Text(
                    // state.name,
                    state.bio != null ? state.bio : '',
                    style: TextStyles.smallRegularTextSecondary,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: AppColors.White,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_outline_sharp,
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MyFeeds()
                          ),
                        );
                      },
                    ),
                    dividerDefault,
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_outline_sharp,
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => SavedFeeds()
                          ),
                        );
                      },
                    ),
                    dividerDefault,
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_outline_sharp,
                            color: AppColors.IconColor,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            'Subscribed Channels',
                            style: TextStyles.smallMediumTextSecondary,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    dividerDefault,
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_outline_sharp,
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
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
