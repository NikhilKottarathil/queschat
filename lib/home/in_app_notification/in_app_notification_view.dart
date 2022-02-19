import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_adapter.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_cubit.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_state.dart';

import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class InAppNotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    bool isSearchPressed = false;
    print('pageBuild');

    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<InAppNotificationCubit>().loadMoreData();
      }
    });
    return BlocListener<InAppNotificationCubit, InAppNotificationState>(
      listener: (context, state) {
        // if (state is Authenticated) {
        //   Navigator.pushReplacementNamed(context, '/home');
        //
        // } else if (state is Unauthenticated) {
        //   Navigator.pushReplacementNamed(context, '/login');
        // }
      },
      child: Scaffold(
        appBar:
            appBarWithBackButton(context: context, titleString: 'Notification'),
        body: Column(
          children: [
            Expanded(
              child:
                  BlocBuilder<InAppNotificationCubit, InAppNotificationState>(
                      buildWhen: (previousState, state) {
                return state is LoadList || state is InitialState;
              }, builder: (BuildContext context, InAppNotificationState state) {
                if (state is InitialState) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loading',
                        style: TextStyles.mediumRegularTextTertiary,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomProgressIndicator(),
                    ],
                  );
                }
                if (state is LoadList) {
                  return state.items.isNotEmpty?ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    itemCount: state.items.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return InAppNotificationAdapter(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/feedSingleView',
                            arguments: {
                              'parentPage': 'notification',
                              'feedID': state.items[index].associateId,
                            },
                          );
                        },
                        model: state.items[index],
                      );
                    },
                  ):Center(child: Text('You have no notification'),);
                }
                return CustomProgressIndicator();
              }),
            ),
            BlocBuilder<InAppNotificationCubit, InAppNotificationState>(
                builder: (BuildContext context, InAppNotificationState state) {
              if (state is LoadMoreState) {
                return CustomProgressIndicator();
              }

              return Container();
            })
          ],
        ),
      ),
    );
  }
}
