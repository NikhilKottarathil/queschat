import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/popups/show_custom_bottom_sheet.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/firebase_dynamic_link.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_cubit.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_view.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_edit_view.dart';
import 'package:queschat/home/message/message_room/message_room_icon_view.dart';
import 'package:queschat/home/message/message_room/message_room_member_contact_view.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:share_plus/share_plus.dart';

class MessageRoomInfoView extends StatelessWidget {
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    context.read<MessageRoomCubit>().reloadStates();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.IconColor),
        actions: [
          if (context.read<MessageRoomCubit>().userRole != 'user')
            IconButton(
              splashColor: Colors.transparent,
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => AddMembersToMessageRoomCubit(
                          isGroupOrChannel: context
                              .read<MessageRoomCubit>()
                              .chatRoomModel
                              .messageRoomType,
                          messageRoomId:
                              context.read<MessageRoomCubit>().chatRoomModel.id,
                          existingUsers: context
                              .read<MessageRoomCubit>()
                              .userContactModels),
                      child: AddMembersToMessageRoomView(),
                    ),
                  ),
                );
              },
            )
        ],
      ),
      body: BlocListener<MessageRoomCubit, MessageRoomState>(
        listener: (context, state) async {
          if (state is ErrorMessageState) {
            showSnackBar(context, state.e);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              messageRoomInfo(),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: BlocBuilder<MessageRoomCubit, MessageRoomState>(
                    buildWhen: (prevState, state) {
                  return state is MembersState;
                }, builder: (context, state) {
                  if (state is MembersState) {
                    return state.userContactModels.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context
                                        .read<MessageRoomCubit>()
                                        .userContactModels
                                        .length
                                        .toString() +
                                    '\tMembers ',
                                style: TextStyles.mediumBoldTextSecondary,
                              ),
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  itemCount: state.userContactModels.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MessageRoomMemberContactView(
                                        state.userContactModels[index],
                                        context);
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                'No members in this ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}',
                                style: TextStyles.smallRegularTextTertiary,
                              ),
                            ),
                          );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerRectangle(
                        height: 10,
                        width: 100,
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemCount: 20,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageRoomMemberContactViewDummy();
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  bottomNavigationBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0), // here the desired height
      child: BlocBuilder<MessageRoomCubit, MessageRoomState>(
        buildWhen: (prevState, state) {
          return state is TextMessageState;
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: context.read<MessageRoomCubit>().messageRoomStatus ==
                        MessageRoomStatus.Active &&
                    context.read<MessageRoomCubit>().messageRoomUserStatus ==
                        MessageRoomUserStatus.Active &&
                    context.read<MessageRoomCubit>().userRole != 'user',
                child: InkWell(
                  onTap: () async {
                  await generateMessageRoomDynamicLink(
                        messageRoomType: context
                            .read<MessageRoomCubit>()
                            .chatRoomModel
                            .messageRoomType,
                        id: context.read<MessageRoomCubit>().chatRoomModel.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Center(
                              child: Text(
                            'Invite via link',
                            style: TextStyles.mediumBoldTextTertiary,
                          ))),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: context.read<MessageRoomCubit>().userRole != 'owner' &&
                    context.read<MessageRoomCubit>().messageRoomUserStatus ==
                        MessageRoomUserStatus.Active,
                child: InkWell(
                  onTap: () {
                    showCustomBottomSheet(
                        context: context,
                        positiveText: 'EXIT',
                        positiveAction: () {
                          context
                              .read<MessageRoomCubit>()
                              .removeUserFromMessageRoom(AppData().userId);
                          if (context
                                  .read<MessageRoomCubit>()
                                  .chatRoomModel
                                  .messageRoomType ==
                              'channel') {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                        content:
                            'Exit From ${context.read<MessageRoomCubit>().chatRoomModel.name} ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Center(
                              child: Text(
                            '${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Exit from Group' : 'Leave Channel'}',
                            style: TextStyles.mediumBoldTextTertiary,
                          ))),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: context.read<MessageRoomCubit>().userRole != 'owner' &&
                    context.read<MessageRoomCubit>().messageRoomUserStatus ==
                        MessageRoomUserStatus.Removed,
                child: InkWell(
                  onTap: () {
                    showCustomBottomSheet(
                        context: context,
                        positiveText: 'DELETE',
                        positiveAction: () {
                          context
                              .read<MessageRoomCubit>()
                              .deleteUserFromGroup();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        content:
                            'Delete ${context.read<MessageRoomCubit>().chatRoomModel.name} ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Center(
                              child: Text(
                            'Delete ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}',
                            style: TextStyles.mediumBoldTextTertiary,
                          ))),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: context.read<MessageRoomCubit>().userRole == 'owner',
                child: InkWell(
                  onTap: () {
                    showCustomBottomSheet(
                        context: context,
                        positiveText: 'DELETE',
                        positiveAction: () {
                          context.read<MessageRoomCubit>().deleteMessageRoom();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        content:
                            'Do you want to delete the ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}, All messages and media removed permanently,\nWill you like to continue ',
                        heading:
                            'Delete ${context.read<MessageRoomCubit>().chatRoomModel.name} ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Center(
                              child: Text(
                            'Delete ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}',
                            style: TextStyles.mediumBoldTextTertiary,
                          ))),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  messageRoomInfo() {
    return BlocBuilder<MessageRoomCubit, MessageRoomState>(
        buildWhen: (previousState, state) {
      return state is InfoDetails;
    }, builder: (context, state) {
      return state is InfoDetails
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.SecondaryColorLight,
                        shape: BoxShape.circle,
                        // border: Border.all(color: AppColors.BorderColor),
                      ),
                      height: 64,
                      width: 64,
                      child: state.chatRoomModel.imageUrl != null
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<MessageRoomCubit>(),
                                      child: MessageRoomIconView(),
                                    ),
                                  ),
                                );
                              },
                              child: ClipOval(
                                  child: Image.network(
                                state.chatRoomModel.imageUrl,
                                fit: BoxFit.cover,
                              )),
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (context.read<MessageRoomCubit>().userRole !=
                                    'user') {
                                  context
                                      .read<MessageRoomCubit>()
                                      .changeGroupIcon(context);
                                }
                              },
                            ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.chatRoomModel.name,
                            style: TextStyles.xMediumBoldTextSecondary,
                          ),
                          Text(
                            'Created at ${getDisplayDateOrTime(state.chatRoomModel.createdTime)}',
                            style: TextStyles.smallRegularTextTertiary,
                          ),
                        ],
                      ),
                    ),
                    if (context.read<MessageRoomCubit>().userRole != 'user')
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<MessageRoomCubit>(),
                                child: MessageRoomEditView(),
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.IconColor,
                        ),
                      ),
                  ],
                ),
                if (state.chatRoomModel.messageRoomType == 'channel' &&
                    state.chatRoomModel.description != null &&
                    state.chatRoomModel.description.trim().isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Description',
                        style: TextStyles.mediumMediumTextTertiary,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        state.chatRoomModel.description,
                        style: TextStyles.smallRegularTextTertiary,
                      ),
                    ],
                  )
              ],
            )
          : Row(
              children: [
                ShimmerCircle(
                  radius: 32,
                ),
                SizedBox(
                  width: 8,
                ),
                ShimmerRectangle(
                  height: 10,
                  width: MediaQuery.of(context).size.width * .5,
                )
              ],
            );
    });
  }
}
