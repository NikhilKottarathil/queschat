import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/message_model.dart';

class MessageRoomAdapter extends StatelessWidget {
  ChatRoomModel chatRoomModel;
  String parentPage;

  MessageRoomAdapter({this.chatRoomModel, this.parentPage});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
          chatRoomModel.isSelected ? Colors.grey.shade300 : Colors.transparent,
      child: Column(
        children: [
          // Divider(
          //   thickness: 1.5,
          //   height: 0,
          //   color: AppColors.DividerBase,
          // ),
          SizedBox(
            height: 6,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            leading: chatRoomModel.imageUrl != null
                ? CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.White,
                    backgroundImage: NetworkImage(
                      chatRoomModel.imageUrl,
                    ))
                : ClipOval(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.TextTertiary,
                      child: Image.asset(
                        chatRoomModel.messageRoomType == 'chat'
                            ? 'images/user_profile.png'
                            : chatRoomModel.messageRoomType == 'group'
                                ? 'images/group_profile.png'
                                : 'images/channel_profile.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  chatRoomModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.subTitle2TextPrimary,
                ),
                SizedBox(
                  height: 2,
                ),
                if (parentPage != 'exploreChannel' &&
                    chatRoomModel.lastMessage != null)
                  Row(
                    children: [
                      // Visibility(
                      //   visible: chatRoomModel.lastMessage.senderID ==
                      //       AppData().userId,
                      //   child: Row(
                      //     children: [
                      //       sendSeenIcons(chatRoomModel.lastMessage),
                      //       SizedBox(
                      //         width: 4,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Flexible(
                        child: Text(
                          chatRoomModel.lastMessage.messageType ==
                                  MessageType.text
                              ? chatRoomModel.lastMessage.message
                              : chatRoomModel.lastMessage.messageType ==
                                      MessageType.deleted
                                  ? 'deleted the message':chatRoomModel.lastMessage.messageType ==
                                      MessageType.forward
                                  ? 'forwarded message'
                                  : chatRoomModel.lastMessage.messageMediaType
                                      .toString(),
                          style: TextStyles.bodyTextSecondary,
                          maxLines: 1,
                          overflow:TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (parentPage == 'exploreChannel')
                  Text(
                     chatRoomModel != null
                        ? chatRoomModel.membersCount.toString()+' Members'
                        : '0' +' Members',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.subBodyTextSecondary,
                  ),
                if (parentPage == 'exploreChannel')
                  Text(
                    chatRoomModel.description != null
                        ? chatRoomModel.description
                        : '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.subBodyTextSecondary,
                  ),
              ],
            ),
            trailing: parentPage != 'exploreChannel'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (chatRoomModel.lastMessage != null &&
                          chatRoomModel.createdTime != null)
                        Text(
                          getDisplayDateOrTime(chatRoomModel.lastMessage != null
                              ? chatRoomModel.lastMessage.createdAt
                              : chatRoomModel.createdTime),
                          style: TextStyles.subBodyTextSecondary,
                        ),
                      Visibility(
                        visible: chatRoomModel.unreadMessageCount > 0,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                          decoration: BoxDecoration(
                              color: AppColors.TextSecondary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            chatRoomModel.unreadMessageCount > 999
                                ? '999+'
                                : chatRoomModel.unreadMessageCount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          SizedBox(
            height: 6,
          ),
          Divider(
            thickness: 1.5,
            height: 0,
            color: AppColors.DividerBase,
          ),
        ],
      ),
    );
  }
}

class MessageRoomAdapterDummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListTile(
      leading: ShimmerCircle(radius: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerRectangle(
            height: 10,
            width: width / 2,
          ),
          SizedBox(
            height: 8,
          ),
          ShimmerRectangle(
            height: 8,
            width: width / 2,
          ),
        ],
      ),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerRectangle(
              height: 8,
              width: 50,
            ),
          ]),
    );
  }
}
