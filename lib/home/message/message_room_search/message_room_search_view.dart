import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/check_ready_message_to_user.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room_list/message_room_adapter.dart';
import 'package:queschat/home/message/message_room_search/message_room_search_event.dart';
import 'package:queschat/home/message/message_room_search/message_room_search_state.dart';
import 'package:queschat/main.dart';
import 'package:queschat/models/chat_room_model.dart';

import 'message_room_search_bloc.dart';

class MessageRoomSearchView extends StatefulWidget {
  @override
  State<MessageRoomSearchView> createState() => _MessageRoomSearchViewState();
}

class _MessageRoomSearchViewState extends State<MessageRoomSearchView>
    with AutomaticKeepAliveClientMixin<MessageRoomSearchView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageRoomSearchBloc(),
      child: Scaffold(
        appBar: appBar(),
        body: BlocListener<MessageRoomSearchBloc, MessageRoomSearchState>(
          listener: (context, state) async {
            Exception e = state.actionErrorMessage;
            if (e != null && e.toString().length != 0) {
              showSnackBar(context, e);
            }
          },
          child: Column(
            children: [
              Flexible(
                child:
                    BlocBuilder<MessageRoomSearchBloc, MessageRoomSearchState>(
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
                                    value:
                                        context.read<MessageRoomSearchBloc>(),
                                    child: InkWell(
                                        onTap: () {
                                          if (state.displayModels[index]
                                                  .messageRoomType ==
                                              'chat') {
                                            checkAlreadyMessagedToUser(
                                                context: context,
                                                id: state.displayModels[index]
                                                    .messengerId,
                                                name: state
                                                    .displayModels[index].name,
                                                profilePic: state
                                                    .displayModels[index]
                                                    .imageUrl);
                                          } else {
                                            Navigator.pushReplacementNamed(
                                                MyApp.navigatorKey
                                                    .currentContext,
                                                '/messageRoom',
                                                arguments: {
                                                  'parentPage': state
                                                              .displayModels[
                                                                  index]
                                                              .messageRoomType ==
                                                          'channel'
                                                      ? 'channelRoomsView'
                                                      : 'chatRoomsView',
                                                  'chatRoomModel':
                                                      ChatRoomModel(
                                                          id: state
                                                              .displayModels[
                                                                  index]
                                                              .id)
                                                });
                                          }
                                        },
                                        child: MessageRoomAdapter(
                                          chatRoomModel:
                                              state.displayModels[index],
                                          parentPage: 'searchPage',
                                        )));
                              },
                              // separatorBuilder:
                              //     (BuildContext context, int index) {
                              //   return dividerDefault;
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
                                "Nothing To Display",
                                style: TextStyles.bodyTextSecondary,
                              ),
                            );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: AppColors.PrimaryColorLight,
      shadowColor: Colors.transparent,
      title: BlocBuilder<MessageRoomSearchBloc, MessageRoomSearchState>(
          builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.text,
          style: TextStyles.subTitle2White,
          maxLines: 1,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          controller:
              context.read<MessageRoomSearchBloc>().textEditingController,
          decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(0),
            filled: false,
            alignLabelWithHint: true,
            suffixIcon:
                state.searchQuery != null && state.searchQuery.length != 0
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.White,
                        ),
                        onPressed: () {
                          context
                              .read<MessageRoomSearchBloc>()
                              .add(SearchQueryCleared());
                        })
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
            hintText: 'Search...',
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintStyle: TextStyles.subTitle2WhiteSecondary,
          ),
        );
      }),
    );
  }
}
