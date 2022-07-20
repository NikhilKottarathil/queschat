import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/app_text_selection_controler.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/audio/record_button.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/multiple_multi_format_file_picker.dart';
import 'package:queschat/components/popups/show_new_feed_alert.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/open_camera.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/message_adapter.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_info_view.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/models/message_model.dart';

class MessageRoomView extends StatefulWidget {
  @override
  _MessageRoomViewState createState() => _MessageRoomViewState();
}

class _MessageRoomViewState extends State<MessageRoomView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  ScrollController scrollController = new ScrollController();
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  FocusNode _textFieldFocusNode = FocusNode();
  Timer _debounce;

  TextSelectionControls _textSelectionControls;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isAndroid) {
      _textSelectionControls = AppMaterialTextSelectionControls(
          controller: context.read<MessageRoomCubit>().textEditingController);
    } else {
      _textSelectionControls = AppCupertinoTextSelectionControls(
          controller: context.read<MessageRoomCubit>().textEditingController);
    }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () {
      //         showNewFeedAlert(context);
      //       },
      //       child: Image.asset(
      //         'images/app_logo.png',
      //         fit: BoxFit.scaleDown,
      //       ),
      //     ),
      //     SizedBox(height: 80,)
      //   ],
      // ),
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
                    : Center(child: CircularProgressIndicator(color: AppColors.PrimaryColorLight,));
              }),
            ),
            bottomWidget(buildContext),
            BlocBuilder<MessageRoomCubit, MessageRoomState>(
                buildWhen: (previousState, state) {
              return state is TextMessageState;
            }, builder: (context, state) {
              return Offstage(
                offstage: !context.read<MessageRoomCubit>().emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        context.read<MessageRoomCubit>().onEmojiSelected(emoji);
                      },
                      onBackspacePressed:
                          context.read<MessageRoomCubit>().onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: 'No Recents',
                          noRecentsStyle: const TextStyle(
                              fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              );
            }),
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
      backgroundColor: AppColors.PrimaryColorLight,
      //
      // foregroundColor: AppColors.White,
      // backgroundColor: AppColors.White,
      shadowColor: Colors.transparent,

      elevation: .5,

      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.PrimaryColorLight),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<MessageRoomCubit, MessageRoomState>(
            buildWhen: (previousState, state) {
              return state is InfoDetails;
            },
            builder: (context, state) {
              if (state is InfoDetails) {
                return GestureDetector(
                  onTap: () {
                   gotoMessageRoomInfo(state);
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
                            child: Image.asset(
                              state.chatRoomModel.messageRoomType == 'chat'
                                  ? 'images/user_profile.png'
                                  : state.chatRoomModel.messageRoomType ==
                                          'group'
                                      ? 'images/group_profile.png'
                                      : 'images/channel_profile.png',
                            ),
                          ),
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 10),
                child: ShimmerCircle(
                  radius: 20,
                ),
              );
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<MessageRoomCubit, MessageRoomState>(
                    buildWhen: (previousState, state) {
                  return state is InfoDetails || state is InitialState;
                }, builder: (context, state) {
                  if (state is InfoDetails) {
                    return GestureDetector(
                      onTap: (){

                        gotoMessageRoomInfo(state);

                      },
                      child: Text(state.chatRoomModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.subTitle1White),
                    );
                  }
                  return ShimmerRectangle(
                    height: 12,
                    width: 100,
                  );
                }),
                BlocBuilder<MessageRoomCubit, MessageRoomState>(
                  buildWhen: (previousState, state) {
                    return state is StatusAndLastSeenState ||
                        state is TypingUserState ||
                        state is InitialState;
                  },
                  builder: (context, state) {
                    if (state is TypingUserState) {
                      print('typingUsers length ${state.typingUsers.length} ');
                      print('typingUsers  ${state.typingUsers} ');
                      print(
                          'userS  ${context.read<MessageRoomCubit>().userContactModels.map((e) => e.id).toList()} ');

                      return Wrap(
                        direction: Axis.horizontal,
                        children:
                            List.generate(state.typingUsers.length, (index) {
                          return Text(
                              state.typingUsers.length > 1 &&
                                      index < state.typingUsers.length - 1
                                  ? context
                                          .read<MessageRoomCubit>()
                                          .userContactModels
                                          .singleWhere((element) =>
                                              element.id ==
                                              state.typingUsers[index])
                                          .name
                                          .toString() +
                                      ', '
                                  : context
                                          .read<MessageRoomCubit>()
                                          .userContactModels
                                          .singleWhere((element) =>
                                              element.id.toString() ==
                                              state.typingUsers[index]
                                                  .toString())
                                          .name
                                          .toString() +
                                      ' Typing',
                              style: TextStyles.subBodyWhiteSecondary);
                        }),
                      );
                    }
                    if (state is StatusAndLastSeenState) {
                      print('last seen ${state.statusAndLastSeen}');

                      return state.statusAndLastSeen
                              .toString()
                              .trim()
                              .isNotEmpty
                          ? Text(
                              state.statusAndLastSeen,
                              style: TextStyles.subBodyWhiteSecondary,
                            )
                          : context
                                      .read<MessageRoomCubit>()
                                      .chatRoomModel
                                      .messageRoomType !=
                                  'chat'
                              ? Text(
                                  context
                                          .read<MessageRoomCubit>()
                                          .userContactModels
                                          .length
                                          .toString() +
                                      ' Members',
                                  style: TextStyles.subBodyWhiteSecondary,
                                )
                              : SizedBox(
                                  height: 0,
                                );
                    }
                    return SizedBox(
                      height: 0,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<MessageRoomCubit, MessageRoomState>(
            buildWhen: (previousState, currentState) {
          return currentState is TextMessageState;
        }, builder: (context, state) {
          if (state is TextMessageState) {
            return (!(state.userRole == 'user' &&
                        context
                                .read<MessageRoomCubit>()
                                .chatRoomModel
                                .messageRoomType ==
                            'channel') &&
                    state.messageRoomStatus == MessageRoomStatus.Active &&
                    state.messageRoomUserStatus == MessageRoomUserStatus.Active)
                ? InkWell(
                    onTap: () {
                      showNewFeedAlert(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 12, right: 10, left: 0, bottom: 12),
                      padding: EdgeInsets.only(right: 16, left: 10),
                      decoration: BoxDecoration(
                          color: AppColors.White,
                          borderRadius: BorderRadius.circular(32)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColors.PrimaryColorLight,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'NEW POST',
                            style: TextStyles.subBodyPrimaryColorLight,
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  );
          }
          return SizedBox(
            height: 0,
            width: 0,
          );
        }),
      ],
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.White,
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
              decoration: BoxDecoration(
                color: AppColors.White,
                boxShadow: appShadow,
              ),
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
              decoration: BoxDecoration(
                color: AppColors.White,
                boxShadow: appShadow,
              ),
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
                decoration: BoxDecoration(
                  color: AppColors.White,
                  boxShadow: appShadow,
                ),
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
                  decoration: BoxDecoration(
                    color: AppColors.White,
                    boxShadow: appShadow,
                  ),
                  child: Center(
                    child: Text(
                        "You can't send message to this${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? ' group' : 'channel'}, Only admin can message",
                        style: TextStyles.subTitle2TextSecondary,
                        textAlign: TextAlign.center),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: AppColors.White,
                    boxShadow: appShadow,
                  ),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    minHeight: 20.0,
                    maxHeight: 150.0,
                  ),
                  padding: EdgeInsets.only(right: 10,bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // IconButton(
                      //   iconSize: 40,
                      //   color: AppColors.PrimaryColorLight,
                      //   onPressed: () {
                      //     showNewFeedAlert(context);
                      //   },
                      //
                      //   icon: Image.asset('images/app_logo.png',fit: BoxFit.scaleDown,),
                      //
                      //   constraints: BoxConstraints(),
                      //   padding: EdgeInsets.only(left: 14, right: 10),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: IconButton(
                          onPressed: () {
                            context
                                .read<MessageRoomCubit>()
                                .showAndHideEmoji();
                          },
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: AppColors.PrimaryColorLight,
                          ),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.only(left: 8,right: 8),
                        ),
                      ),
                      Expanded(

                        child: TextFormField(
                          focusNode: _textFieldFocusNode,
                          selectionControls: _textSelectionControls,
                          enableInteractiveSelection: true,


                          controller: context
                              .read<MessageRoomCubit>()
                              .textEditingController,
                          onChanged: _onTextChanged,

                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          style: TextStyles.subTitle2TextPrimary,
                          showCursor: true,

                          decoration: InputDecoration(
                            hintText: "Write your message…",
                            hintStyle: TextStyles.subTitle2TextSecondary,



                            contentPadding: EdgeInsets.all(0),
                            constraints: BoxConstraints(),
                            border: AppBorders.transparentBorder,
                            errorBorder: AppBorders.transparentBorder,
                            disabledBorder: AppBorders.transparentBorder,
                            enabledBorder: AppBorders.transparentBorder,
                            focusedBorder: AppBorders.transparentBorder,
                            focusedErrorBorder: AppBorders.transparentBorder,
                          ),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: IconButton(
                          onPressed: () {
                            multipleMultiFormatFilePicker(
                                buildContext: buildContext,
                                roomName: context
                                    .read<MessageRoomCubit>()
                                    .chatRoomModel
                                    .name);
                          },
                          icon: Icon(
                            Icons.attachment,
                            color: AppColors.PrimaryColorLight,
                          ),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: IconButton(
                          onPressed: () {
                            getMediaFromCamera(context);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppColors.PrimaryColorLight,
                          ),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.only(left: 18, right: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Stack(
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
                                    color: AppColors.PrimaryColorLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  void gotoMessageRoomInfo(InfoDetails state) {
    if (!state.chatRoomModel.isSingleChat) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<MessageRoomCubit>(),
                child: MessageRoomInfoView(),
              )));
    } else {
      Navigator.pushNamed(context, '/userProfile', arguments: {
        'userId': context
            .read<MessageRoomCubit>()
            .chatRoomModel
            .messengerId
      });
    }
  }
}
