import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/home/report_a_content/report_view.dart';
import 'package:queschat/models/message_model.dart';

messageSelectionAppBar(
    {BuildContext buildContext, MessageModel messageModel}) async {
  // textEditingController.text = buildContext.read<ProductFilterBloc>().state.searchString;

  await showDialog(
      context: buildContext,
      useSafeArea: false,
      barrierColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
            value: buildContext.read<MessageRoomCubit>(),
            child: BlocBuilder<MessageRoomCubit, MessageRoomState>(
                builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.black12,
                  appBar: PreferredSize(
                    preferredSize: AppBar().preferredSize,
                    child: Container(
                      color: AppColors.White,
                      height: AppBar().preferredSize.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.IconColor,
                              )),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (messageModel.senderID == AppData().userId)
                                IconButton(
                                    onPressed: () {
                                      context
                                          .read<MessageRoomCubit>()
                                          .deleteMessage(messageModel);
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.IconColor,
                                    )),
                              // if (messageModel.senderID == AppData().userId && messageModel.messageType==MessageType.feed)
                              //   IconButton(
                              //       onPressed: () {
                              //         context
                              //             .read<MessageRoomCubit>()
                              //             .deleteMessage(messageModel);
                              //         Navigator.of(context).pop();
                              //       },
                              //       icon: Icon(
                              //         Icons.edit,
                              //         color: AppColors.IconColor,
                              //       )),
                              if (messageModel.senderID != AppData().userId)
                                IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: Image.asset(
                                        'images/three_dot_vertical.png',
                                        color: AppColors.TextTertiary),
                                    onPressed: () {
                                      showReportAlert(
                                          buildContext: context,
                                          reportedModel:
                                              messageModel.feedId != null
                                                  ? 'feed'
                                                  : 'user',
                                          reportedModelId:
                                              messageModel.feedId != null
                                                  ? messageModel.feedId
                                                  : AppData().userId);
                                      print(
                                          'Wrong  feed in my Feeds or id not matching');
                                    }),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              // return AppBar(
              //   automaticallyImplyLeading: false,
              //   backgroundColor: Colors.transparent,
              //
              //   titleSpacing: 0,
              //   title: Material(
              //     color: AppColors.White,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         IconButton(
              //             onPressed: () {
              //
              //               Navigator.of(context).pop();
              //             },
              //             icon: Icon(
              //               Icons.arrow_back,
              //               color: AppColors.IconColor,
              //             )),
              //         IconButton(
              //             onPressed: () {
              //               context
              //                   .read<MessageRoomCubit>()
              //                   .deleteMessage(messageModel);
              //               Navigator.of(context).pop();
              //             },
              //             icon: Icon(
              //               Icons.delete,
              //               color: AppColors.IconColor,
              //             ))
              //       ],
              //     ),
              //   ),
              // );
            }),
          ));
}
