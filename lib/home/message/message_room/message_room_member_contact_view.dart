import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/custom_alert_dialoug.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomMemberContactView extends StatelessWidget {
  UserContactModel contact;
  BuildContext parentContext;

  MessageRoomMemberContactView(this.contact, this.parentContext);

  @override
  Widget build(BuildContext context) {
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
    return BlocProvider.value(
      value: context.read<MessageRoomCubit>(),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(
          radius: 24,
          child: ClipOval(
            child: contact.profilePic != null
                ? Image.network(
                    contact.profilePic,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'images/user_profile.png',
                    width: 48,
                    height: 48,
                  ),
          ),
          backgroundColor: Colors.white,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.name,
              style: TextStyles.subTitle2TextSecondary,
            ),
            Text(
              phones,
              style: TextStyles.subBodyTextTertiary,
            ),
          ],
        ),
        trailing: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            contact.userType == 'owner'
                ? Text(
                    'Owner',
                    style: TextStyles.bodySecondary,
                  )
                : contact.userType == 'admin'
                    ? Text(
                        'Admin',
                        style: TextStyles.bodySecondary,
                      )
                    : SizedBox(
                        height: 1,
                        width: 1,
                      ),
            Visibility(
              visible: contact.id != AppData().userId,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: PopupMenuButton(
                padding: EdgeInsets.only(left: 0),
                iconSize: 24,
                itemBuilder: (_) {
                  List<PopupMenuItem<String>> menuItems = [];
                  menuItems.add(
                    PopupMenuItem<String>(
                      child: Text(
                        'Message ${contact.name}',
                        style: TextStyles.bodyTextSecondary,
                      ),
                      onTap: () {
                        print('message pressed');
                        if (allChatMessageRoomListBloc.state.models.any(
                            (element) =>
                                element.messengerId == contact.id &&
                                element.isSingleChat)) {
                          print('message exit');

                          try {
                            Navigator.pushNamed(
                              context,
                              '/messageRoom',
                              arguments: {
                                'parentPage': 'newChatExisting',
                                'chatRoomModel':
                                    ChatRoomModel(id: 'fjkghkfdjgh'),
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
                                  name: contact.name,
                                  imageUrl: contact.profilePic,
                                  messageRoomType: 'chat',
                                  isSingleChat: true,
                                  messengerId: contact.id),
                            },
                          );
                        }
                      },
                    ),
                  );
                  if (context.read<MessageRoomCubit>().userRole == 'admin' ||
                      context.read<MessageRoomCubit>().userRole == 'owner')
                    menuItems.add(PopupMenuItem<String>(
                      child: Text(
                        'Remove ${contact.name}',
                        style: TextStyles.bodyTextSecondary,
                      ),
                      onTap: () {
                        print('pressed');
                        customAlertDialog(
                            context: context,
                            heading:
                                'Remove ${contact.name} from ${context.read<MessageRoomCubit>().chatRoomModel.name}',
                            positiveText: 'Yes',
                            positiveAction: () {
                              context
                                  .read<MessageRoomCubit>()
                                  .removeUserFromMessageRoom(contact.id);
                            });
                      },
                    ));
                  if (context.read<MessageRoomCubit>().userRole == 'owner') {
                    contact.userType == 'user'
                        ? menuItems.add(PopupMenuItem<String>(
                            child: Text(
                              'Make As Admin',
                              style: TextStyles.bodyTextSecondary,
                            ),
                            onTap: () {
                              context
                                  .read<MessageRoomCubit>()
                                  .makeAsAdmin(contact.id);
                            },
                          ))
                        : menuItems.add(PopupMenuItem<String>(
                            child: Text(
                              'Dismiss as Admin',
                              style: TextStyles.bodyTextSecondary,
                            ),
                            onTap: () {
                              context
                                  .read<MessageRoomCubit>()
                                  .dismissAsAdmin(contact.id);
                            },
                          ));
                  }

                  return menuItems;
                },
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageRoomMemberContactViewDummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<MessageRoomCubit>(),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: ShimmerCircle(radius: 24),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerRectangle(
              height: 10,
              width: MediaQuery.of(context).size.width - 150,
            ),
            SizedBox(
              height: 4,
            ),
            ShimmerRectangle(
              height: 6,
              width: MediaQuery.of(context).size.width - 150,
            )
          ],
        ),
      ),
    );
  }
}
