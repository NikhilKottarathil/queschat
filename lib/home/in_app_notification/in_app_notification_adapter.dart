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
              backgroundImage: model.userProfilePics.first!=null?NetworkImage(model.userProfilePics.first):null,
              child: model.userProfilePics.first==null?Image.asset('assets/user_profile.png'):null,
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
                backgroundImage: model.userProfilePics[1]!=null?NetworkImage(model.userProfilePics[1]):null,
                child: model.userProfilePics[1]==null?Image.asset('assets/user_profile.png'):null,
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
                backgroundImage: model.userProfilePics.last!=null?NetworkImage(model.userProfilePics.last):null,
                child: model.userProfilePics.last==null?Image.asset('assets/user_profile.png'):null,
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

    title = names + ' ';
    String content = getContent(model.connectionType, model.associateType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(text: names, style: TextStyles.smallBoldTextSecondary),
            TextSpan(
                text: content, style: TextStyles.smallRegularTextSecondary),
          ]),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: Text(getDisplayDateOrTime(model.createdTime),
                style: TextStyles.tinyRegularTextTertiary)),
      ],
    );
  }

  getContent(String connectionType, String associateType) {
    String subject;
    String object;
    if (connectionType == 'comment') {
      subject =  'commented on your';
    } else if (connectionType == 'answer') {
      subject = 'attended your';
    } else {
      subject = connectionType + 'ed  your';
    }
    if(associateType=='mcq'){
      object='poll';
    }else{
      object=associateType;
    }

    return subject+' '+object;
  }
}
