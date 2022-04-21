import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/check_ready_message_to_user.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_cubit.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_cubit.dart';
import 'package:queschat/models/user_contact_model.dart';

Widget userContactViewSelectable(
    UserContactModel contact, BuildContext context) {
  String phones = '';
  print('app builf ${contact.isSelected}');
  contact.phoneNumbers.forEach((element) {
    // print(element.label +element.value);

    if (phones.length == 0) {
      phones = element;
    } else {
      phones = phones + ',' + element;
    }
  });
  return ListTile(
      leading: CircleAvatar(
        radius: 24,
        child: ClipOval(
          child: contact.profilePic != null
              ? Image.network(
                  contact.profilePic,
                  fit: BoxFit.cover,
                )
              : Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  color: AppColors.IconColor,
                  size: 48,
                ),
        ),
        backgroundColor: Colors.white,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: TextStyles.mediumBoldTextSecondary,
          ),
          Text(
            phones,
            style: TextStyles.smallRegularTextTertiary,
          ),
        ],
      ),
      trailing: InkWell(
        onTap: () {
          try {
            if (context.read<NewGroupCubit>() != null) {
              context.read<NewGroupCubit>().userSelected(id: contact.id);
            }
          }catch (e){

          }
          try {
            if(context.read<AddMembersToMessageRoomCubit>()!=null) {
              context.read<AddMembersToMessageRoomCubit>().userSelected(id: contact.id);
            }
          }catch (e){

          }

          print('pressed');
        },
        splashColor: Colors.transparent,
        child: contact.isSelected
            ? Icon(Icons.radio_button_checked, color: Colors.blue)
            : Icon(
                Icons.radio_button_unchecked,
                color: AppColors.IconColor,
              ),
      ));
}

Widget userContactView(UserContactModel contact, BuildContext context) {
  String phones = '';
  // print('app builf');
  contact.phoneNumbers.forEach((element) {
    // print(element.label +element.value);

    if (phones.length == 0) {
      phones = element;
    } else {
      phones = phones + ',' + element;
    }
  });
  return ListTile(
    onTap: () {
      if (contact.isUser) {
        checkAlreadyMessagedToUser(context:context,id:contact.id,name:contact.name,profilePic: contact.profilePic);
      }
    },
    leading: CircleAvatar(
      radius: 24,
      child: ClipOval(
        child: contact.profilePic != null
            ? Image.network(
                contact.profilePic,
                fit: BoxFit.cover,
              )
            : Icon(
                CupertinoIcons.person_alt_circle_fill,
                color: AppColors.IconColor,
                size: 48,
              ),
      ),
      backgroundColor: Colors.white,
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.name,
          style: TextStyles.mediumBoldTextSecondary,
        ),
        Text(
          phones,
          style: TextStyles.smallRegularTextTertiary,
        ),
      ],
    ),
    trailing: contact.isUser
        ? SizedBox(
            height: 1,
            width: 1,
          )
        : Text(
            'Invite',
            style: TextStyles.smallRegularTertiary,
          ),
  );
}


