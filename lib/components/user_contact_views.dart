import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/custom_alert_dialoug.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_cubit.dart';

import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_view.dart';
import 'package:queschat/home/message/new_chat/new_chat_cubit.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_cubit.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/router/app_router.dart';

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
        if (allChatMessageRoomListBloc.state.models.any((element) =>
            element.messengerId == contact.id && element.isSingleChat)) {


          Navigator.pushReplacementNamed(
            context,
            '/messageRoom',
            arguments: {
              'parentPage': 'newChatExisting',
              'chatRoomModel': ChatRoomModel(
                  id:allChatMessageRoomListBloc.state.models
                      .singleWhere((element) =>
                          element.messengerId == contact.id &&
                          element.isSingleChat)
                      .id),
            },
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            '/messageRoom',
            arguments: {
              'parentPage': 'newChat',
              'chatRoomModel': ChatRoomModel(
                  name: contact.name,
                  imageUrl: contact.profilePic,
                  messageRoomType: 'chat',
                  isSingleChat: true,
                  messengerId: contact.id),
            },
          );
        }
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


