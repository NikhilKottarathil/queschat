import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/audio/audio_bubble.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/custom_web_view.dart';
import 'package:queschat/components/media_components/image_viewer.dart';
import 'package:queschat/components/multi_format_file_viewer.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/message/message_room/feed_message_view.dart';
import 'package:queschat/home/message/message_room/message_appbar.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/router/app_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MessageAdapter extends StatefulWidget {
  MessageModel messageModel;
  BuildContext buildContext;

  MessageAdapter({Key key,this.messageModel, this.buildContext});

  @override
  State<MessageAdapter> createState() => _MessageAdapterState();
}

class _MessageAdapterState extends State<MessageAdapter>
    // with AutomaticKeepAliveClientMixin<MessageAdapter>
{
  bool isSendMessage = false;

  bool isLongPressed = false;

  // @override
  // bool get wantKeepAlive => true;

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



    return InkWell(
      onLongPress: () {
        if (widget.messageModel.messageType != MessageType.deleted &&
                widget.messageModel.messageType != MessageType.date ||
            widget.messageModel.messageType != MessageType.loading) {
          messageSelectionAppBar(
              messageModel: widget.messageModel,
              buildContext: widget.buildContext);
        }
      },
      child: widget.messageModel.messageType == MessageType.date
          ? _displayDate()
          : widget.messageModel.messageType == MessageType.loading
              ? _displayLoader(width)
              : widget.messageModel.messageType == MessageType.deleted
                  ? _displayDeletedMessage(width)
                  : isSendMessage
                      ? _displaySendMessage(width)
                      : _displayReceivedMessage(width),
    );
  }

  Widget _displaySendMessage(double width) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        margin: EdgeInsets.only(left: width * .2),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.BorderColor),
          color: AppColors.ChatSecondaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(0),
            topRight: Radius.circular(18),
            topLeft: Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            contentView(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
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
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        margin: EdgeInsets.only(right: width * .2),
        decoration: BoxDecoration(
          color: AppColors.ChatPrimaryColor,
          border: Border.all(color: AppColors.BorderColor),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(18),
            topRight: Radius.circular(18),
            topLeft: Radius.circular(18),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _displaySenderName(),
                contentView(context),
                SizedBox(
                  height: 12,
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
      padding: EdgeInsets.only(right: 4),
      child: Text(
        get24HourFormatTime(widget.messageModel.createdAt),
        style: TextStyle(color: AppColors.TextTertiary),
      ),
    );
  }

  Widget _displaySenderName() {
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 0, bottom: 2),
      child: Text(
          widget.buildContext
                  .read<MessageRoomCubit>()
                  .userContactModels
                  .any((element) => element.id == widget.messageModel.senderID)
              ? widget.buildContext
                  .read<MessageRoomCubit>()
                  .userContactModels
                  .singleWhere(
                      (element) => element.id == widget.messageModel.senderID)
                  .name
              : 'Unknown User',
          style: TextStyles.smallRegularTextFourth),
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
          style: TextStyles.smallRegularTextTertiary,
        ),
      ),
    );
  }

  Widget _displayLoader(double width) {
    return Container(
      margin: EdgeInsets.only(left: width * .2),
      decoration: BoxDecoration(
        color: AppColors.ChatSecondaryColor,
        border: Border.all(color: AppColors.BorderColor),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(0),
          topRight: Radius.circular(18),
          topLeft: Radius.circular(18),
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
        color: isSendMessage
            ? AppColors.ChatSecondaryColor
            : AppColors.ChatPrimaryColor,
        border: Border.all(color: AppColors.BorderColor),
        borderRadius: BorderRadius.only(
          bottomLeft: !isSendMessage ? Radius.circular(0) : Radius.circular(18),
          bottomRight: isSendMessage ? Radius.circular(0) : Radius.circular(18),
          topRight: Radius.circular(18),
          topLeft: Radius.circular(18),
        ),
      ),
      margin: EdgeInsets.only(
          left: isSendMessage ? width * .2 : 0,
          right: !isSendMessage ? width * .2 : 0),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(
        'deleted the message',
        style: TextStyles.smallRegularTextSecondary,
      ),
    );
  }

  Widget contentView(BuildContext context) {
    return widget.messageModel.messageType == MessageType.text
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.messageModel.message,
              style: TextStyles.smallRegularTextSecondary,
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
                    errorWidget: (context, url, error) => Icon(Icons.error,color: AppColors.IconColor),
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
  return Container(
    child: !messageModel.isSingleMessage
        ? Icon(
            Icons.check,
            size: 18,
            color: AppColors.IconColor,
          )
        : messageModel.messageStatus == MessageStatus.sending
            ? Icon(Icons.access_time_outlined,
                size: 18, color: AppColors.IconColor)
            : messageModel.messageStatus == MessageStatus.sent
                ? Icon(Icons.check, size: 18, color: AppColors.IconColor)
                : messageModel.messageStatus == MessageStatus.delivered
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: AppColors.PrimaryColorLight,
                      )
                    : messageModel.messageStatus == MessageStatus.seen
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.PrimaryColorLight,
                          )
                        : Icon(
                            Icons.error_outline,
                            size: 18,
                            color: AppColors.RedPrimary,
                          ),
  );
}
