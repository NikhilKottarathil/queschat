import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/new_group_and_channel/new_channel_create_view.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_create_view.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_cubit.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'new_group_state.dart';

class NewGroupViewSelectUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<NewGroupCubit, NewGroupState>(
      listener: (context, state) {
        if (state is ErrorMessage) {
          showSnackBar(context, state.e);
        }
        //if (state is CreationSuccessful) {
        //           Navigator.pushReplacementNamed(context, '/home');
        //
        //         }else
      },
      child: Scaffold(
        appBar: appBarWithBackButton(
            titleString:
                context.read<NewGroupCubit>().isGroupOrChannel == 'group'
                    ? 'New Group'
                    : 'New Channel',
            context: context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyles.smallRegularTextSecondary,
                onChanged: (value) {
                  context.read<NewGroupCubit>().searchUsers(value);
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
              child: BlocBuilder<NewGroupCubit, NewGroupState>(
                buildWhen: (previousState, state) {
                  return state is LoadList || state is InitialState;
                },
                builder: (BuildContext context, NewGroupState state) {
                  if (state is InitialState) {
                    return CustomProgressIndicator();
                  } else if (state is LoadList) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      children: state.items.toSet().map((item) {
                        return userContactViewSelectable(item, context);
                      }).toList(),
                    );
                  }
                  return CustomProgressIndicator();
                },
              ),
            ),
            BlocBuilder<NewGroupCubit, NewGroupState>(
              buildWhen: (previousState, state) {
                return state is LoadList || state is InitialState;
              },
              builder: (BuildContext context, NewGroupState state) {
                bool isActive = false;
                if (state is LoadList) {
                  isActive = state.items.any((element) => element.isSelected);
                }
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomButton(
                    isActive: isActive,
                    action: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<NewGroupCubit>(),
                            child: context
                                        .read<NewGroupCubit>()
                                        .isGroupOrChannel ==
                                    'group'
                                ? NewGroupCreateView()
                                : NewChannelCreateView(),
                          ),
                        ),
                      );
                    },
                    text: 'Next',
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
