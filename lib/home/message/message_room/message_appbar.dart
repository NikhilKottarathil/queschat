import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/message_forward/message_room_forward_bloc.dart';
import 'package:queschat/home/message/message_forward/message_room_forward_view.dart';
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
                  backgroundColor: Colors.black38,
                  appBar: PreferredSize(
                    preferredSize: AppBar().preferredSize,
                    child: Container(
                      color: AppColors.PrimaryColorLight,
                      height: AppBar().preferredSize.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                context
                                    .read<MessageRoomCubit>()
                                    .selectUnselectMessage(messageModel);

                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.White,
                              )),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .read<MessageRoomCubit>()
                                        .selectUnselectMessage(messageModel);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                                  create: (context) =>
                                                      MessageRoomForwardBloc(
                                                          chatRoomModel: buildContext
                                                              .read<
                                                                  MessageRoomCubit>()
                                                              .chatRoomModel,
                                                          messageModel:
                                                              messageModel),
                                                  child:
                                                      MessageRoomForwardView(),
                                                )));
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        CupertinoIcons.arrowshape_turn_up_right,
                                        // FontAwesomeIcons.share,
                                        color: AppColors.White,
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  )),
                              if (messageModel.senderID == AppData().userId)
                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<MessageRoomCubit>()
                                          .selectUnselectMessage(messageModel);

                                      context
                                          .read<MessageRoomCubit>()
                                          .deleteMessage(messageModel);
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: AppColors.White,
                                        ),
                                        // SizedBox(width: 8,),
                                        // Text('DELETE',style: TextStyles.buttonWhite,)
                                      ],
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
                                GestureDetector(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                            'images/three_dot_vertical.png',
                                            height: 20,
                                            color: AppColors.White),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'REPORT',
                                          style: TextStyles.buttonWhite,
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      context
                                          .read<MessageRoomCubit>()
                                          .selectUnselectMessage(messageModel);

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
          )).then((value) => {
        buildContext
            .read<MessageRoomCubit>()
            .selectUnselectMessage(messageModel)
      });
}
