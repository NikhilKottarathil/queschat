import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_model.dart';

class InAppNotificationAdapter extends StatelessWidget {
  InAppNotificationModel model;
  Function onPressed;

  InAppNotificationAdapter({Key key, this.model, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      tileColor: AppColors.White,
      leading: leading(),
      title: title(),
    );
  }

  leading() {
    return Stack(
      children: [
        if (model.userProfilePics.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            child: CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(model.userProfilePics.first),
              backgroundColor: Colors.transparent,
            ),
          ),
        if (model.userProfilePics.length >= 2)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: CircleAvatar(
                radius: 21,
                backgroundImage: NetworkImage(model.userProfilePics[1]),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        if (model.userProfilePics.length >= 3)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: CircleAvatar(
                radius: 21,
                backgroundImage: NetworkImage(model.userProfilePics.last),
                backgroundColor: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  title() {
    String title = '';
    String names = model.userNames.length == 1
        ? model.userNames.first
        : model.userNames.length == 2
        ? model.userNames.first + ' and ' + model.userNames[1]
        : model.userNames.first +
        ', ' +
        model.userNames[1] +
        ' and ' +
        (model.userNames.length - 2).toString() +
        ' others';

    title = names + ' ' + model.content;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.smallRegularTextSecondary),
        Align(
            alignment: Alignment.bottomLeft,
            child: Text(getDisplayDateOrTime(model.createdTime),
                style: TextStyles.tinyRegularTextTertiary)),
      ],
    );
  }
}
