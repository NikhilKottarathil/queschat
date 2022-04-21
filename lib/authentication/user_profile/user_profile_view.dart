import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:queschat/authentication/user_profile/user_profile_bloc.dart';
import 'package:queschat/authentication/user_profile/user_profile_state.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/copy_text_from_field.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/router/app_router.dart';

class UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => profileBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.PrimaryColorLight,
          elevation: .5,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.White),
          title: BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
            return Text(
              state.name,
              style: TextStyles.heading2White,
            );
          }),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.White),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context,state) {
                return InkWell(
                  onTap: () {
                    if (allChatMessageRoomListBloc.state.models.any(
                            (element) =>
                        element.messengerId == state.userId &&
                            element.isSingleChat)) {
                      print('message exit');

                      try {
                        Navigator.pushNamed(
                          context,
                          '/messageRoom',
                          arguments: {
                            'parentPage': 'newChatExisting',
                            'chatRoomModel':
                            ChatRoomModel(id: state.userId),
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      print('message new');

                      Navigator.pushNamed(
                        context,
                        '/messageRoom',
                        arguments: {
                          'parentPage': 'newChat',
                          'chatRoomModel': ChatRoomModel(
                              name: state.name,
                              imageUrl: state.imageUrl,
                              messageRoomType: 'chat',
                              isSingleChat: true,
                              messengerId: state.userId),
                        },
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 12, right: 10, left: 0, bottom: 12),
                    padding: EdgeInsets.only(right: 16, left: 10),
                    decoration: BoxDecoration(
                        color: AppColors.White,
                        borderRadius: BorderRadius.circular(32)),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.message,
                          color: AppColors.PrimaryColorLight,
                          size: 18,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          'Message',
                          style: TextStyles.subBodyPrimaryColorLight,
                        ),
                      ],
                    ),
                  ),
                );
              }
            )

          ],
        ),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                                    backgroundImage:state.imageUrl.isNotEmpty!=null?
                                        NetworkImage(state.imageUrl.toString()):null,
                                  )
                                : CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                      size: MediaQuery.of(context).size.width *
                                          .15,
                                      color: AppColors.IconColor,
                                    ),
                                    backgroundColor: AppColors.White,
                                    radius:
                                        MediaQuery.of(context).size.width * .15,
                                  ),
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
                      state.phoneNumber,
                      style: TextStyles.subTitle2TextPrimary,
                    ),
                  ),
                ),
                Visibility(
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
                Visibility(
                  visible: state.facebookLink != null ||
                      state.instagramLink != null ||
                      state.linkedinLink != null,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: state.facebookLink != null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                copyTextFromField(state.facebookLink);
                              },
                              child: Image.asset(
                                'images/facebook_logo.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),Visibility(
                          visible: state.instagramLink != null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                copyTextFromField(state.instagramLink);
                              },
                              child: Image.asset(
                                'images/instagram_logo.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),Visibility(
                          visible: state.linkedinLink != null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                copyTextFromField(state.linkedinLink);
                              },
                              child: Image.asset(
                                'images/linkedin_logo.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //
                Flexible(
                  child: BlocProvider(
                    create: (context)=>FeedsBloc(feedRepository: feedRepository, parentPage: 'userProfileFeed',userProfileId: context.read<UserProfileBloc>().userId),
                    child: FeedsView(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
