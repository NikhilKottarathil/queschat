import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room_list/message_room_adapter.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_bloc.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_event.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_state.dart';
import 'package:queschat/main.dart';
import 'package:queschat/models/chat_room_model.dart';

class MessageRoomListView extends StatefulWidget {
  @override
  State<MessageRoomListView> createState() => _MessageRoomListViewState();
}

class _MessageRoomListViewState extends State<MessageRoomListView>
    with AutomaticKeepAliveClientMixin<MessageRoomListView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MessageRoomListBloc, MessageRoomListState>(
        listener: (context, state) async {
          Exception e = state.actionErrorMessage;
          if (e != null && e.toString().length != 0) {
            showSnackBar(context, e);
          }
        },
        child: Column(
          children: [
            if(context.read<MessageRoomListBloc>().parentPage == 'exploreChannel')
            searchBar(),
            Flexible(
              child: BlocBuilder<MessageRoomListBloc, MessageRoomListState>(
                  builder: (context, state) {
                print(state.displayModels.length);

                return state.isLoading
                    ? ListView.separated(
                        itemCount: 20,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return MessageRoomAdapterDummy();
                        },
                      )
                    : state.displayModels.length != 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            shrinkWrap: true,
                            itemCount: state.displayModels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BlocProvider.value(
                                  value: context.read<MessageRoomListBloc>(),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            MyApp.navigatorKey.currentContext,
                                            '/messageRoom',
                                            arguments: {
                                              'parentPage': context
                                                          .read<
                                                              MessageRoomListBloc>()
                                                          .parentPage ==
                                                      'channel'
                                                  ? 'channelRoomsView'
                                                  : context
                                                              .read<
                                                                  MessageRoomListBloc>()
                                                              .parentPage ==
                                                          'exploreChannel'
                                                      ? 'exploreChannelRoomsView'
                                                      : 'chatRoomsView',
                                              'chatRoomModel': ChatRoomModel(
                                                  id: state
                                                      .displayModels[index].id)
                                            });
                                      },
                                      child: MessageRoomAdapter(
                                        chatRoomModel:
                                            state.displayModels[index],
                                        parentPage: context
                                            .read<MessageRoomListBloc>()
                                            .parentPage,
                                      )));
                            },
                            // separatorBuilder:
                            //     (BuildContext context, int index) {
                            //   return SizedBox(height: 0,width: 0,);
                            // },
                            // separatorBuilder:
                            //     (BuildContext context, int index) {
                            //   return Divider(
                            //     height: 8,
                            //     color: AppColors.TextSixth,
                            //   );
                            // },
                          )
                        : Center(
                            child: Text(
                              context.read<MessageRoomListBloc>().parentPage ==
                                      'channel'
                                  ? "You don't have any channels"
                                  : context
                                              .read<MessageRoomListBloc>()
                                              .parentPage ==
                                          'allChat'
                                      ? "You don't have any chats"
                                      : "No Channels To Display",
                              style: TextStyles.bodyTextSecondary,
                            ),
                          );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton:
          context.read<MessageRoomListBloc>().parentPage == 'channel'
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        MyApp.navigatorKey.currentContext, '/exploreChannels');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      border: Border.all(
                          color: AppColors.PrimaryColorLight, width: 1.3),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.ShadowColor,
                            offset: Offset(1, 3),
                            spreadRadius: 4,
                            blurRadius: 6)
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.userPlus,
                          size: 18,
                          color: AppColors.PrimaryColorLight,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'JOIN CHANNEL',
                          style: TextStyles.buttonPrimaryColorLight,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
      // floatingActionButton: context.read<MessageRoomListBloc>().parentPage=='channel'?FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/exploreChannels');
      //   },
      //   elevation: 2,
      //
      //   label: Container(
      //     decoration: BoxDecoration(
      //       border: Border.all(color: AppColors.BorderColor)
      //     ),
      //     child: Text(
      //       'JOIN CHANNEL',
      //       style: TextStyles.buttonWhite,
      //     ),
      //   ),
      //   backgroundColor: AppColors.White,
      // ):null,
    );
  }

  searchBar() {
    return BlocBuilder<MessageRoomListBloc, MessageRoomListState>(
        builder: (context, state) {
      // context
      //     .read<MessageRoomListBloc>().textEditingController.addListener(() {
      //   print('listning texxt controller');
      //   context
      //       .read<MessageRoomListBloc>().state.searchQuery=context
      //       .read<MessageRoomListBloc>().textEditingController.text;
      //   context
      //       .read<MessageRoomListBloc>().add(UpdateList());
      // });
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.White,
          border: Border.all(color: AppColors.BorderColor),
        ),
        child: TextField(
          keyboardType: TextInputType.text,
          style: TextStyles.subTitle2TextPrimary,
          maxLines: 1,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          controller: context.read<MessageRoomListBloc>().textEditingController,
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(0),
            filled: true,
            fillColor: AppColors.White,
            alignLabelWithHint: true,
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.IconColor,
            ),
            suffixIcon:
                state.searchQuery != null && state.searchQuery.length != 0
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.IconColor,
                        ),
                        onPressed: () {
                          context
                              .read<MessageRoomListBloc>()
                              .add(SearchQueryCleared());
                        })
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
            hintText:
                context.read<MessageRoomListBloc>().parentPage == 'channel'
                    ? "Search Channel's"
                    : context.read<MessageRoomListBloc>().parentPage ==
                            'exploreChannel'
                        ? "Search Channel's to join"
                        : "Search Chat's",
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintStyle: TextStyles.subTitle2TextSecondary,
          ),
        ),
      );
    });
  }
}
