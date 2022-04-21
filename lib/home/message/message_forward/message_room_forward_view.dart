import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_forward/message_room_formward_state.dart';
import 'package:queschat/home/message/message_forward/message_room_forward_bloc.dart';
import 'package:queschat/home/message/message_forward/message_room_forward_event.dart';
import 'package:queschat/home/message/message_room_list/message_room_adapter.dart';

class MessageRoomForwardView extends StatefulWidget {
  @override
  State<MessageRoomForwardView> createState() => _MessageRoomForwardViewState();
}

class _MessageRoomForwardViewState extends State<MessageRoomForwardView>
    with AutomaticKeepAliveClientMixin<MessageRoomForwardView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageRoomForwardBloc, MessageRoomForwardState>(
      listener: (context, state) async {
        Exception e = state.actionErrorMessage;
        if (e != null && e.toString().length != 0) {
          showSnackBar(context, e);
        }
      },
      child: BlocBuilder<MessageRoomForwardBloc, MessageRoomForwardState>(
          builder: (context, state) {
        return Scaffold(
          appBar: appBar(),
          floatingActionButton: state.models.any((element) => element.isSelected)?FloatingActionButton(
            child: Icon(
              Icons.send,
              color: AppColors.White,
            ),
            backgroundColor: AppColors.PrimaryColorLight,
            onPressed: () {
              context.read<MessageRoomForwardBloc>().add(ForwardButtonPressed());
            },
          ):null,
          body: state.isLoading
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
                            value: context.read<MessageRoomForwardBloc>(),
                            child: InkWell(
                                onTap: () {
                                  state.displayModels[index].isSelected =
                                      !state.displayModels[index].isSelected;
                                  context
                                      .read<MessageRoomForwardBloc>()
                                      .add(UpdateList());
                                },
                                child: MessageRoomAdapter(
                                  chatRoomModel: state.displayModels[index],
                                  parentPage: 'searchPage',
                                )));
                      },
                      // separatorBuilder:
                      //     (BuildContext context, int index) {
                      //   return SizedBox(height: 0,);
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
                    ),
        );
      }),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: AppColors.PrimaryColorLight,
      shadowColor: Colors.transparent,
      title: BlocBuilder<MessageRoomForwardBloc, MessageRoomForwardState>(
          builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.text,
          style: TextStyles.subTitle2White,
          maxLines: 1,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          controller:
              context.read<MessageRoomForwardBloc>().textEditingController,
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
                              .read<MessageRoomForwardBloc>()
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
