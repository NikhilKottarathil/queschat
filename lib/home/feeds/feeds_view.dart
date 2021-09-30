import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/home/feeds/feed_adpater.dart';

import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_state.dart';
import 'package:queschat/home/feeds/feeds_status.dart';

class FeedsView extends StatefulWidget {
  @override
  _FeedsViewState createState() => _FeedsViewState();
}

class _FeedsViewState extends State<FeedsView> {
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<FeedsBloc>().add(FetchMoreData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FeedsBloc, FeedsState>(
        listener: (context, state) async {
          if (state.pageScrollStatus is ScrollToTop) {
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn);
            });
          }
        },
        child: BlocBuilder<FeedsBloc, FeedsState>(builder: (context, state) {
          print(state.feedModelList.length);

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(20),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: state.feedModelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BlocProvider.value(value: context.read<FeedsBloc>(),child: FeedAdapter(index));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                ),
              ),
              state.isLoading ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomProgressIndicator(),
              ) : Container(),
            ],
          );
        }),
      ),
    );
  }
}
// onRefresh: () {
// context.read<FeedsBloc>().add(FetchInitialData());
// return null;
// },
