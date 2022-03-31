import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_cubit.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_state.dart';
import 'package:queschat/router/app_router.dart';

class NotificationCountWidget extends StatelessWidget {
  NotificationCountWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => inAppNotificationCubit,
        child: Row(
          children: [
            BlocBuilder<InAppNotificationCubit, InAppNotificationState>(
                builder: (context, state) {
              if (state is NewNotificationCount) {
                return state.count == 0
                    ? notificationIcon(context)
                    : SizedBox(
                        height: 40,
                        width: 55,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: notificationIcon(context)),
                            Positioned(
                              top: 0,
                              left: 33,
                              child: Text(
                                state.count > 99
                                    ? '99+'
                                    : state.count.toString(),
                                style: TextStyles.smallBoldTextFourth,
                              ),
                            )
                          ],
                        ),
                      );
              }
              return notificationIcon(context);
            }),
            SizedBox(
              width: 20,
            )
          ],
        ));
  }

  Widget notificationIcon(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints(),
      iconSize: 28,
      onPressed: () {
        Navigator.pushNamed(context, '/inAppNotifications');
      },
      icon: FaIcon(
        FontAwesomeIcons.bell,
        size: 24,
        color: AppColors.White,
      ),
      //   icon: Image.asset(
      //   "images/notifications.png",
      //   height: 24,
      //   width: 24,
      //   color: AppColors.IconColor,
      // ),
    );
  }
}
