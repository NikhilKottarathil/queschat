import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_cubit.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_state.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class AddMembersToMessageRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddMembersToMessageRoomCubit,
        AddMembersToMessageRoomState>(
      listener: (context, state) {
        if (state is ErrorMessage) {
          showSnackBar(context, state.e);
        }
        if (state is CreationSuccessful) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: appBarWithBackButton(
            titleString:
                context.read<AddMembersToMessageRoomCubit>().isGroupOrChannel ==
                        'group'
                    ? 'Add members to group'
                    : 'New members to channel',
            context: context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyles.smallRegularTextSecondary,
                onChanged: (value) {
                  context
                      .read<AddMembersToMessageRoomCubit>()
                      .searchUsers(value);
                },
                decoration: new InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyles.smallRegularTextTertiary),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
              color: AppColors.StatusBar,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Suggested",
                textAlign: TextAlign.start,
                style: TextStyle(color: AppColors.TextTertiary, fontSize: 16),
              ),
            ),
            Flexible(
              child: BlocBuilder<AddMembersToMessageRoomCubit,
                  AddMembersToMessageRoomState>(
                buildWhen: (previousState, state) {
                  return state is LoadList || state is InitialState;
                },
                builder:
                    (BuildContext context, AddMembersToMessageRoomState state) {
                  if (state is InitialState) {
                    return CustomProgressIndicator();
                  } else if (state is LoadList) {
                    return state.items.isNotEmpty? ListView(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      children: state.items.toSet().map((item) {
                        return userContactViewSelectable(item, context);
                      }).toList(),
                    ):Center(child: Text('No contacts to display',style: TextStyles.smallRegularTextTertiary,),);
                  }
                  return CustomProgressIndicator();
                },
              ),
            ),
            BlocBuilder<AddMembersToMessageRoomCubit,
                AddMembersToMessageRoomState>(

              builder:
                  (BuildContext context, AddMembersToMessageRoomState state) {
                bool isActive = false;
                if (state is LoadList) {
                  isActive = state.items.any((element) => element.isSelected);
                }
                return state is LoadingState? CustomProgressIndicator: Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomButton(
                    isActive: isActive,
                    action: () {
                      context.read<AddMembersToMessageRoomCubit>().addMembers();
                    },
                    text: 'Add',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
