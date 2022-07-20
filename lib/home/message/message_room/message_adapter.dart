import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/audio/audio_bubble.dart';
import 'package:queschat/components/custom_web_view.dart';
import 'package:queschat/components/media_components/image_viewer.dart';
import 'package:queschat/components/multi_format_file_viewer.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/check_ready_message_to_user.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/message/message_room/feed_message_view.dart';
import 'package:queschat/home/message/message_room/message_appbar.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/message_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:url_launcher/url_launcher.dart';
class MessageAdapter extends StatefulWidget {
  MessageModel messageModel;
  BuildContext buildContext;

  MessageAdapter({Key key, this.messageModel, this.buildContext});

  @override
  State<MessageAdapter> createState() => _MessageAdapterState();
}

class _MessageAdapterState extends State<MessageAdapter>
    with AutomaticKeepAliveClientMixin<MessageAdapter> {
  @override
  bool get wantKeepAlive => true;

  bool isSendMessage = false;

  bool isLongPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    isSendMessage = false;
    if (widget.messageModel.senderID == AppData().userId) {
      isSendMessage = true;
      // print('message adapter ${widget.messageModel.messageType} inside ');
    }
    // print(
    //     'message adapter ${widget.messageModel.messageType} ${widget.messageModel.senderID} ${AppData().userId} $isSendMessage');

    return GestureDetector(
      key: ObjectKey(widget.messageModel.id),
      onLongPress: () {
        if (widget.messageModel.messageType != MessageType.deleted &&
                widget.messageModel.messageType != MessageType.date ||
            widget.messageModel.messageType != MessageType.loading) {
          context
              .read<MessageRoomCubit>()
              .selectUnselectMessage(widget.messageModel);
          messageSelectionAppBar(
              messageModel: widget.messageModel,
              buildContext: widget.buildContext);
        }
      },
      child: ColoredBox(
        color: widget.messageModel.isSelected
            ? Colors.grey.shade300
            : Colors.transparent,
        child: widget.messageModel.messageType == MessageType.date
            ? _displayDate()
            : widget.messageModel.messageType == MessageType.loading
                ? _displayLoader(width)
                : widget.messageModel.messageType == MessageType.deleted
                    ? _displayDeletedMessage(width)
                    : isSendMessage
                        ? _displaySendMessage(width)
                        : _displayReceivedMessage(width),
      ),
    );
  }

  Widget _displaySendMessage(double width) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: EdgeInsets.only(left: width * .2),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.BorderColor),
          color: AppColors.White,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(0),
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.messageModel.forwardMessage != null)
              _displayForwardName(),
            contentView(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _displayMessageSendTime(),
                sendSeenIcons(widget.messageModel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayReceivedMessage(double width) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        margin: EdgeInsets.only(right: width * .2),
        decoration: BoxDecoration(
          color: AppColors.TextFifth,
          // border: Border.all(color: AppColors.BorderColor),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(8),
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _displaySenderName(),
                if (widget.messageModel.forwardMessage != null)
                  _displayForwardName(),
                contentView(context),
                SizedBox(
                  height: 24,
                  width: 100,
                )
              ],
            ),
            Positioned(
              child: _displayMessageSendTime(),
              bottom: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayMessageSendTime() {
    return Padding(
      padding: EdgeInsets.only(right: 6, left: 6, top: 4),
      child: Text(
        getDisplayTime(widget.messageModel.createdAt),
        style: TextStyles.subBodyTextSecondary,
      ),
    );
  }

  Widget _displaySenderName() {
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 5, bottom: 5, right: 6),
      child: widget.buildContext
              .read<MessageRoomCubit>()
              .userContactModels
              .any((element) => element.id == widget.messageModel.senderID)
          ? GestureDetector(
              onTap: () {
                checkAlreadyMessagedToUser(
                    id: widget.messageModel.senderID,
                    name: widget.buildContext
                        .read<MessageRoomCubit>()
                        .userContactModels
                        .singleWhere((element) =>
                            element.id == widget.messageModel.senderID)
                        .name,
                    profilePic: widget.buildContext
                        .read<MessageRoomCubit>()
                        .userContactModels
                        .singleWhere((element) =>
                            element.id == widget.messageModel.senderID)
                        .profilePic,
                    context: context);
              },
              child: Text(
                  widget.buildContext
                      .read<MessageRoomCubit>()
                      .userContactModels
                      .singleWhere((element) =>
                          element.id == widget.messageModel.senderID)
                      .name,
                  style: TextStyles.subBodySecondary),
            )
          : Text('Unknown User', style: TextStyles.subBodySecondary),
    );
  }

  Widget _displayForwardName() {
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 5, bottom: 5, right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.arrowshape_turn_up_right_fill,
            size: 16,
            // FontAwesomeIcons.share,
            color: AppColors.TextSecondary,
          ),
          SizedBox(
            width: 6,
          ),
          Text('Forwarded', style: TextStyles.subBodyTextSecondary),
        ],
      ),
    );
  }

  Widget _displayDate() {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          widget.messageModel.message,
          style: TextStyles.subTitle2TextSecondary,
        ),
      ),
    );
  }

  Widget _displayLoader(double width) {
    return Container(
      margin: EdgeInsets.only(left: width * .2),
      decoration: BoxDecoration(
        color: AppColors.White,
        border: Border.all(color: AppColors.BorderColor),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(0),
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.all(25),
      child: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: AppColors.IconColor,
        ),
      ),
    );
  }

  Widget _displayDeletedMessage(double width) {
    return Container(
      decoration: BoxDecoration(
        color: isSendMessage ? AppColors.White : AppColors.TextFifth,
        border: isSendMessage ? Border.all(color: AppColors.BorderColor) : null,
        borderRadius: BorderRadius.only(
          bottomLeft: !isSendMessage ? Radius.circular(0) : Radius.circular(8),
          bottomRight: isSendMessage ? Radius.circular(0) : Radius.circular(8),
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      margin: EdgeInsets.only(
          left: isSendMessage ? width * .2 : 0,
          right: !isSendMessage ? width * .2 : 0),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(
        'deleted the message',
        style: TextStyles.bodyTextPrimary,
      ),
    );
  }

  Widget contentView(BuildContext context) {
    return widget.messageModel.messageType == MessageType.text
        ? Padding(
            padding:
                const EdgeInsets.only(left: 6.0, right: 6, bottom: 2, top: 2),
            child: SelectableLinkify(
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },


              text: widget.messageModel.message,
              style: TextStyles.bodyTextPrimary,
              linkStyle: TextStyles.bodyTextPrimary
                  .copyWith(color: AppColors.PrimaryColor),
            ),
          )
        : widget.messageModel.messageType == MessageType.image
            ? InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ImageViewer(imageUrl: widget.messageModel.mediaUrl),
                    ),
                  );
                },
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: widget.messageModel.mediaUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerRectangle(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.width * .8,
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: AppColors.IconColor),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              )
            : widget.messageModel.messageType == MessageType.video
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MultiFormatFileViewer(
                              messageModel: widget.messageModel),
                        ),
                      );
                    },
                    child: FutureBuilder(
                        future: getThumbnail(widget.messageModel.mediaUrl),
                        builder: (context, snapshot) {
                          // print('snapshot');
                          // print(snapshot);
                          if (snapshot.hasError) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                  child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: AppColors.White,
                                size: 36,
                              )),
                            );
                          }
                          if (snapshot.data != null) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  child: Image.file(
                                    snapshot.data,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 36,
                                    color: AppColors.White,
                                  ),
                                ),
                              ],
                            );
                          }
                          return SizedBox(
                            height: 150,
                            child: Center(
                                child: Icon(
                              Icons.play_circle_outline_outlined,
                              color: AppColors.White,
                              size: 36,
                            )),
                          );
                        }),
                  )
                : widget.messageModel.messageType == MessageType.audio
                    ? Container(
                        child: AudioBubble(
                          filepath: widget.messageModel.mediaUrl,
                        ),
                      )
                    : widget.messageModel.messageType == MessageType.voice_note
                        ? Container(
                            child: AudioBubble(
                              filepath: widget.messageModel.mediaUrl,
                            ),
                          )
                        : widget.messageModel.messageType ==
                                MessageType.document
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CustomWebView(
                                          file: widget.messageModel.mediaUrl),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.insert_drive_file,
                                  color: AppColors.IconColor,
                                  size: 84,
                                ))
                            : widget.messageModel.messageType ==
                                    MessageType.feed
                                ? Flexible(
                                    child: FeedMessageView(
                                      key: widget.key,
                                      messageModel: widget.messageModel,
                                    ),
                                  )
                                : widget.messageModel.messageType ==
                                        MessageType.forward_deleted
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: Flexible(
                                            child:
                                                Text('The message is removed')),
                                      )
                                    : Container(
                                        child: Text('Not supported'),
                                      );
  }
}

Future<File> getThumbnail(String videoUrl) async {
  try {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );
    File file = File(fileName);
    // print('file name$fileName $file ');

    return file;
  } catch (e) {}
}

Widget sendSeenIcons(MessageModel messageModel) {
  return Padding(
      padding: EdgeInsets.only(right: 6),
      child: messageModel.messageStatus == MessageStatus.sending
          ? Icon(FontAwesomeIcons.clock, size: 18, color: AppColors.IconColor)
          : messageModel.messageStatus == MessageStatus.sent
              ? Icon(Icons.done, size: 18, color: AppColors.IconColor)
              : messageModel.messageStatus == MessageStatus.error
                  ? Icon(
                      FontAwesomeIcons.circleExclamation,
                      size: 18,
                      color: AppColors.RedPrimary,
                    )
                  : !messageModel.isSingleMessage
                      ? Icon(
                          Icons.done,
                          size: 18,
                          color: AppColors.IconColor,
                        )
                      : messageModel.messageStatus == MessageStatus.delivered ||
                              messageModel.messageStatus == MessageStatus.seen
                          ? Icon(
                              Icons.done_all,
                              size: 18,
                              color: AppColors.PrimaryColor,
                            )
                          : Icon(
                              FontAwesomeIcons.circleExclamation,
                              size: 18,
                              color: AppColors.PrimaryColor,
                            ));
}
