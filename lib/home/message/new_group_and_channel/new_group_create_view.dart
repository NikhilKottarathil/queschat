import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_view.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_cubit.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'new_group_state.dart';

class NewGroupCreateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('pageBuild');

    return BlocListener<NewGroupCubit, NewGroupState>(
      listener: (context, state) {
        if (state is CreationSuccessful) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/messageRoom', arguments: {
            'parentPage': 'newGroupCreateView',
            'chatRoomModel': ChatRoomModel(
              id: state.id,
            ),
          });
        } else if (state is ErrorMessage) {
          showSnackBar(context, state.e);
        }
      },
      child: Scaffold(
        appBar:
            appBarWithBackButton(titleString: 'New Group', context: context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyles.smallRegularTextSecondary,
                onChanged: (value) {
                  context.read<NewGroupCubit>().groupNameChanged(value);
                },
                decoration: new InputDecoration(
                    hintText: 'Group Name',
                    border: InputBorder.none,
                    hintStyle: TextStyles.smallRegularTextTertiary,
                    prefixIcon: BlocBuilder<NewGroupCubit, NewGroupState>(
                      buildWhen: (previousState, state) {
                        return state is InitialState ||
                            state is GroupIconChanged;
                      },
                      builder: (context, state) {
                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppColors.SecondaryColor,
                            shape: BoxShape.circle,
                            // border: Border.all(color: AppColors.BorderColor),
                          ),
                          height: 50,
                          width: 50,
                          child: state is GroupIconChanged
                              ? ClipOval(
                                  child: Image.file(
                                  state.groupIcon,
                                  fit: BoxFit.cover,
                                ))
                              : IconButton(
                                  icon: Icon(
                                    Icons.camera_enhance,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<NewGroupCubit>()
                                        .selectGroupIcon(context);
                                  },
                                ),
                        );
                      },
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
              color: AppColors.StatusBar,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Members",
                textAlign: TextAlign.start,
                style: TextStyle(color: AppColors.TextTertiary, fontSize: 16),
              ),
            ),
            Flexible(
              child: BlocBuilder<NewGroupCubit, NewGroupState>(
                buildWhen: (previousState, state) {
                  return state is LoadList || state is InitialState;
                },
                builder: (BuildContext context, NewGroupState state) {
                  if (state is InitialState) {
                    return CustomProgressIndicator();
                  } else if (state is LoadList) {
                    List<UserContactModel> items = state.items
                        .where((element) => element.isSelected)
                        .toList();
                    return ListView(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      children: items.toSet().map((item) {
                        return userContactView(item, context);
                      }).toList(),
                    );
                  }
                  return CustomProgressIndicator();
                },
              ),
            ),
            BlocBuilder<NewGroupCubit, NewGroupState>(
              buildWhen: (previousState, state) {
                return state is GroupNameChanged || state is InitialState;
              },
              builder: (BuildContext context, NewGroupState state) {
                bool isActive = true;
                print(
                    'group name  build${context.read<NewGroupCubit>().groupName}');
                if (context.read<NewGroupCubit>().groupName.trim().length ==
                    0) {
                  isActive = false;
                } else {
                  isActive = true;
                }

                return Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomButton(
                    isActive: isActive,
                    action: () {
                      context.read<NewGroupCubit>().uploadGroupImage();
                    },
                    text: 'Next',
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
