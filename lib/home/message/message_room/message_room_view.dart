import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/audio/record_button.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/multiple_multi_format_file_picker.dart';
import 'package:queschat/components/popups/show_new_feed_alert.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/message_adapter.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_info_view.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomView extends StatefulWidget {
  @override
  _MessageRoomViewState createState() => _MessageRoomViewState();
}

class _MessageRoomViewState extends State<MessageRoomView>
    with WidgetsBindingObserver {
  ScrollController scrollController = new ScrollController();
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  Timer _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addActiveMessageRoom(context.read<MessageRoomCubit>().chatRoomModel.id);
    WidgetsBinding.instance.addObserver(this);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<MessageRoomCubit>().loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    // read context issue
    // if (context.read<MessageRoomCubit>().messageRoomStatus ==
    //     MessageRoomStatus.Active) {
    //   reference
    //       .child(context.read<MessageRoomCubit>().detailsNode)
    //       .child(context.read<MessageRoomCubit>().chatRoomModel.id)
    //       .child('is_typing')
    //       .child(AppData().userId)
    //       .remove();
    // }
    _debounce.cancel();

    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    removeActiveMessageRoom(context.read<MessageRoomCubit>().chatRoomModel.id);

    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    if (context.read<MessageRoomCubit>().messageRoomStatus ==
        MessageRoomStatus.Active) {
      reference
          .child('TypingListener')
          .child(context.read<MessageRoomCubit>().chatRoomModel.id)
          .child('is_typing')
          .child(AppData().userId)
          .remove();
    }
    removeActiveMessageRoom(context.read<MessageRoomCubit>().chatRoomModel.id);

    super.deactivate();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   super.didChangeAppLifecycleState(state);
  //
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       addActiveMessageRoom(context.read<MessageRoomCubit>().chatRoomModel.id);
  //
  //       // print(' AppLifecycleState ${ currentMessageRoomId=context.read<MessageRoomCubit>().chatRoomModel.id}  resumed');
  //       // currentMessageRoomId=context.read<MessageRoomCubit>().chatRoomModel.id;
  //
  //       break;
  //     case AppLifecycleState.inactive:
  //       removeActiveMessageRoom(context.read<MessageRoomCubit>().chatRoomModel.id);
  //
  //       // print(' AppLifecycleState ${ currentMessageRoomId=context.read<MessageRoomCubit>().chatRoomModel.id}  inactive');
  //
  //       break;
  //     case AppLifecycleState.paused:
  //       removeActiveMessageRoom(context.read<MessageRoomCubit>().chatRoomModel.id);
  //
  //       // print(' AppLifecycleState ${ currentMessageRoomId=context.read<MessageRoomCubit>().chatRoomModel.id}  paused');
  //
  //       break;
  //     case AppLifecycleState.detached:
  //       // print('AppLifecycleState ${ currentMessageRoomId=context.read<MessageRoomCubit>().chatRoomModel.id}  detached');
  //
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: appBar(),
      body: BlocListener<MessageRoomCubit, MessageRoomState>(
        listener: (context, state) async {
          if (state is ErrorMessageState) {
            showSnackBar(context, state.e);
          }
        },
        child: Column(
          children: [
            loader(),
            Expanded(
              child: BlocBuilder<MessageRoomCubit, MessageRoomState>(
                  buildWhen: (prevState, state) {
                return state is LoadList;
              }, builder: (context, state) {
                print('LoadList');
                return state is LoadList
                    ? state.messageModels.length != 0
                        ? ListView.separated(
                            reverse: true,
                            addAutomaticKeepAlives: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: state.messageModels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MessageAdapter(
                                key: ObjectKey(state.messageModels[index].id),
                                messageModel: state.messageModels[index],
                                buildContext: context,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 14,
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'You have no messages',
                              style: TextStyles.smallRegularTextSecondary,
                            ),
                          )
                    : Container();
              }),
            ),
            bottomWidget(buildContext),
          ],
        ),
      ),
    );
  }

  _onTextChanged(String value) {
    if (context.read<MessageRoomCubit>().messageRoomStatus ==
        MessageRoomStatus.Active) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      reference
          .child('TypingListener')
          .child(context.read<MessageRoomCubit>().chatRoomModel.id)
          .child('is_typing')
          .child(AppData().userId)
          .set('typing');
      // context.read<MessageRoomCubit>().add(MessageChanged(value: value));

      _debounce = Timer(const Duration(milliseconds: 1000), () {
        reference
            .child('TypingListener')
            .child(context.read<MessageRoomCubit>().chatRoomModel.id)
            .child('is_typing')
            .child(AppData().userId)
            .remove();
        print('      // do something with query');
      });
    }
  }

  appBar() {
    return AppBar(
      // foregroundColor: AppColors.ChatPrimaryColor,
      backgroundColor: AppColors.TextSixth,
      //
      // foregroundColor: AppColors.White,
      // backgroundColor: AppColors.White,
      shadowColor: Colors.transparent,

      elevation: .5,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.IconColor),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<MessageRoomCubit, MessageRoomState>(
            buildWhen: (previousState, state) {
              return state is InfoDetails;
            },
            builder: (context, state) {
              if (state is InfoDetails) {
                return InkWell(
                  onTap: () {
                    if (!state.chatRoomModel.isSingleChat) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: context.read<MessageRoomCubit>(),
                                    child: MessageRoomInfoView(),
                                  )));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10),
                    child: state.chatRoomModel.imageUrl != null
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                state.chatRoomModel.imageUrl.toString()),
                          )
                        : CircleAvatar(
                            radius: 20,
                            child: Image.asset(state.chatRoomModel.messageRoomType == 'chat'
                                ? 'images/user_profile.png'
                                : state.chatRoomModel.messageRoomType == 'group'
                                ? 'images/group_profile.png'
                                : 'images/channel_profile.png',),
                          ),
                  ),
                );
              }
              return ShimmerCircle(
                radius: 18,
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<MessageRoomCubit, MessageRoomState>(
                  buildWhen: (previousState, state) {
                return state is InfoDetails;
              }, builder: (context, state) {
                if (state is InfoDetails) {
                  return Text(state.chatRoomModel.name,
                      style: TextStyles.subTitle1TextPrimary);
                }
                return ShimmerRectangle(
                  height: 10,
                  width: 100,
                );
              }),
              BlocBuilder<MessageRoomCubit, MessageRoomState>(
                buildWhen: (previousState, state) {
                  return state is StatusAndLastSeenState ||
                      state is TypingUserState;
                },
                builder: (context, state) {
                  if (state is StatusAndLastSeenState) {
                    print('last seen ${state.statusAndLastSeen}');

                    return Text(
                      state.statusAndLastSeen,
                      style: TextStyles.subBodyTextSecondary,
                    );
                  }
                  if (state is TypingUserState) {
                    print('valueModels lingth ${state.valueModels.length} ');

                    return Wrap(
                      direction: Axis.horizontal,
                      children:
                          List.generate(state.valueModels.length, (index) {
                        return FutureBuilder(
                            future: authRepository.getDetailsOfSelectedUser(
                                state.valueModels[index].key, 'any'),
                            builder: (context, snapShot) {
                              if (snapShot.hasData) {
                                print('2222 ${state.valueModels[index].value}');
                                return Text(
                                    state.valueModels.length > 1 &&
                                            index < state.valueModels.length - 1
                                        ? snapShot.data.toString() + ', '
                                        : snapShot.data.toString() +
                                            ' ' +
                                            state.valueModels[index].value,
                                    style: TextStyles.subBodyTextSecondary);
                              }
                              return Text(
                                  context
                                      .read<MessageRoomCubit>()
                                      .lastSeenAndStatus,
                                  style: TextStyles.subBodyTextSecondary);
                            });
                      }),
                    );
                  }
                  return SizedBox(
                    height: 0,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.IconColor,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  bottomWidget(BuildContext buildContext) {
    return BlocBuilder<MessageRoomCubit, MessageRoomState>(
      buildWhen: (previousState, state) {
        return state is TextMessageState;
      },
      builder: (context, state) {
        bool isSendButtonVisible = false;
        if (state is TextMessageState) {
          isSendButtonVisible = state.message.trim().isNotEmpty;

          if (state.messageRoomStatus == MessageRoomStatus.Deleted) {
            return Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              color: AppColors.TextSeven,
              child: Center(
                child: Text(
                    "You can't send message to this${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? ' group' : 'channel'}, Because the  ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'group' : 'channel'} no longer exists",
                    style: TextStyles.subTitle2TextSecondary,
                    textAlign: TextAlign.center),
              ),
            );
          }
          if (state.messageRoomUserStatus == MessageRoomUserStatus.Removed) {
            return Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: AppColors.TextSeven,
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  "You can't send message to this${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}, Because you're no longer a member",
                  style: TextStyles.subTitle2TextSecondary,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (state.messageRoomUserStatus == MessageRoomUserStatus.NotJoined) {
            return InkWell(
              onTap: () {
                context
                    .read<MessageRoomCubit>()
                    .addUserFromMessageRoom(AppData().userId);
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: AppColors.TextSeven,
                child: Center(
                  child: Text(
                    "Join ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'}",
                    style: TextStyles.subTitle2TextSecondary,
                  ),
                ),
              ),
            );
          }

          return state.userRole == 'user' &&
                  context
                          .read<MessageRoomCubit>()
                          .chatRoomModel
                          .messageRoomType ==
                      'channel'
              ? Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  color: AppColors.TextSeven,
                  child: Center(
                    child: Text(
                        "You can't send message to this${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? ' group' : 'channel'}, Only admin can message",
                        style: TextStyles.subTitle2TextSecondary,
                        textAlign: TextAlign.center),
                  ),
                )
              : Container(
                  color: AppColors.TextSeven,

                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: context
                              .read<MessageRoomCubit>()
                              .textEditingController,
                          onChanged: _onTextChanged,
                          decoration: InputDecoration(
                            hintText: "Write your message…",
                            prefixIconConstraints: BoxConstraints(),

                            prefixIcon:
                                // context
                                //     .read<MessageRoomCubit>()
                                //     .chatRoomModel
                                //     .messageRoomType ==
                                //     'channel'?
                                IconButton(
                              onPressed: () {
                                showNewFeedAlert(context);
                              },
                              icon: Icon(
                                Icons.attach_file,
                                color: AppColors.IconColor,
                              ),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.only(left: 14, right: 10),
                            ),
                            // :SizedBox(width: 20,),
                            suffixIcon: IconButton(
                              onPressed: () {
                                multipleMultiFormatFilePicker(
                                    buildContext: buildContext,
                                    roomName: context
                                        .read<MessageRoomCubit>()
                                        .chatRoomModel
                                        .name);
                              },
                              icon: Icon(
                                Icons.perm_media,
                                color: AppColors.IconColor,
                              ),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0),
                            ),
                            border: AppBorders.transparentBorder,
                            errorBorder: AppBorders.transparentBorder,
                            disabledBorder: AppBorders.transparentBorder,
                            enabledBorder: AppBorders.transparentBorder,
                            focusedBorder: AppBorders.transparentBorder,
                            focusedErrorBorder: AppBorders.transparentBorder,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Visibility(
                            visible: !isSendButtonVisible,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: RecordButton(
                              parentContext: context,
                            ),
                          ),
                          Visibility(
                            visible: isSendButtonVisible,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                context
                                    .read<MessageRoomCubit>()
                                    .sendMessage(messageType: MessageType.text);
                              },
                              child: Container(
                                child: const Icon(
                                  Icons.send,
                                  color: AppColors.White,
                                ),
                                height: 40,
                                width: 40,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.PrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        }

        return ShimmerRectangle(
          height: 60,
          width: MediaQuery.of(context).size.width,
        );
      },
    );
  }

  loader() {
    return BlocBuilder<MessageRoomCubit, MessageRoomState>(
        buildWhen: (prevState, state) {
      return state is LoadList || state is LoadMoreState;
    }, builder: (context, state) {
      return state is LoadMoreState
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomProgressIndicator(),
            )
          : Container();
    });
  }
}
