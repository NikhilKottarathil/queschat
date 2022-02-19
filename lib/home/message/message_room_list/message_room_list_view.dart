import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_view.dart';
import 'package:queschat/home/message/message_room_list/message_room_adapter.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_bloc.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_event.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_state.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:shimmer/shimmer.dart';

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
                        ? ListView.separated(
                            // padding: EdgeInsets.only(top: 20, bottom: 20),
                            shrinkWrap: true,
                            itemCount: state.displayModels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BlocProvider.value(
                                  value: context.read<MessageRoomListBloc>(),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/messageRoom',
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
                                      )));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 8,
                              );
                            },
                          )
                        : Center(
                            child: Text('You have no channels'),
                          );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: context.read<MessageRoomListBloc>().parentPage=='channel'?FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/exploreChannels');
        },
        label: Text(
          'Explore',
          style: TextStyles.smallRegularWhite,
        ),
        backgroundColor: AppColors.PrimaryColorLight,
      ):null,
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
      return Card(
        margin: EdgeInsets.all(10),
        elevation: 1,
        color: AppColors.White,
        shadowColor: AppColors.ShadowColor,
        child: TextField(
          keyboardType: TextInputType.text,
          style: TextStyles.smallRegularTextTertiary,
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
              color: AppColors.TextTertiary,
            ),
            suffixIcon:
                state.searchQuery != null && state.searchQuery.length != 0
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.TextTertiary,
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
            hintText: 'Search...',
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintStyle: TextStyles.smallRegularTextTertiary,
          ),
        ),
      );
    });
  }
}
