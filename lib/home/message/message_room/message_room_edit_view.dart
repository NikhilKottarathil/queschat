import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class MessageRoomEditView extends StatelessWidget {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (context.read<MessageRoomCubit>().messageRoomName != null) {
      nameTextEditingController.text =
          context.read<MessageRoomCubit>().messageRoomName;
    }
    if (context.read<MessageRoomCubit>().description != null) {
      descriptionTextEditingController.text =
          context.read<MessageRoomCubit>().description;
    }

    return Scaffold(
      appBar: appBarWithBackButton(context: context, titleString: 'Edit'),
      body: BlocListener<MessageRoomCubit, MessageRoomState>(
        listener: (context, state) async {
          if (state is ErrorMessageState) {
            showSnackBar(context, state.e);
          }
        },
        child: BlocBuilder<MessageRoomCubit, MessageRoomState>(
            builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'} name',
                  style: TextStyles.smallRegularTextTertiary,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.TextTertiary),
                      borderRadius: BorderRadius.circular(4)),
                  child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyles.smallRegularTextSecondary,
                      controller: nameTextEditingController,
                      maxLines: 1,
                      onChanged: (value) {
                        context
                            .read<MessageRoomCubit>()
                            .messageRoomNameChanged(value);
                      },
                      decoration: new InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.all(17),
                        hintText:
                            'Enter ${context.read<MessageRoomCubit>().chatRoomModel.messageRoomType == 'group' ? 'Group' : 'Channel'} Name',
                        fillColor: AppColors.White,
                        filled: true,
                        hintStyle: TextStyles.smallRegularTextTertiary,
                        errorStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.TextError,
                            height: 1.1,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w400),
                        border: AppBorders.transparentBorder,
                        focusedBorder: AppBorders.transparentBorder,
                        disabledBorder: AppBorders.transparentBorder,
                        enabledBorder: AppBorders.transparentBorder,
                        errorBorder: AppBorders.transparentBorder,
                        focusedErrorBorder: AppBorders.transparentBorder,
                      )
                      // decoration: new InputDecoration(
                      //   border: InputBorder.none,
                      //   hintStyle: TextStyles.smallRegularTextTertiary,
                      // ),
                      ),
                ),
                if (context
                        .read<MessageRoomCubit>()
                        .chatRoomModel
                        .messageRoomType ==
                    'channel')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Description',
                        style: TextStyles.smallRegularTextTertiary,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.TextTertiary),
                            borderRadius: BorderRadius.circular(4)),
                        child: TextField(
                          maxLines: 7,
                          maxLength: 250,
                          controller: descriptionTextEditingController,
                          onChanged: (value) {
                            context
                                .read<MessageRoomCubit>()
                                .descriptionChanged(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a description about your channel',
                            hintStyle: TextStyles.smallRegularTextTertiary,
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                Spacer(),
                BlocBuilder<MessageRoomCubit, MessageRoomState>(
                  buildWhen: (previousState, state) {
                    return state is MessageRoomNameChanged ||
                        state is InitialState;
                  },
                  builder: (BuildContext context, MessageRoomState state) {
                    bool isActive = true;
                    print(
                        'group name  build${context.read<MessageRoomCubit>().messageRoomName}');
                    if (context
                            .read<MessageRoomCubit>()
                            .messageRoomName
                            .trim()
                            .length ==
                        0) {
                      isActive = false;
                    } else {
                      isActive = true;
                    }

                    return CustomButton(
                      isActive: isActive,
                      action: () {
                        context.read<MessageRoomCubit>().editMessageRoom();
                        Navigator.of(context).pop();
                      },
                      text: 'Save',
                    );
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
