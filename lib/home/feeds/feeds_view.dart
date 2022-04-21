import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
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
        print('fetch more feed scroll controller');
        context.read<FeedsBloc>().add(FetchMoreData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
          Exception e= state.actionErrorMessage;
          if(e!=null  &&e.toString().length!=0){
            showSnackBar(context, e);
          }
        },
        child: BlocBuilder<FeedsBloc, FeedsState>(builder: (context, state) {
          print(state.feedModelList.length);

          return state.isLoading?ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return BlocProvider.value(value: context.read<FeedsBloc>(),child: FeedAdapterDummy());
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },

          ): Column(
            children: [
              Expanded(
                child: state.feedModelList.length==0?Center(child: Text('No Post to Show',style: TextStyles.mediumMediumTextTertiary,),): ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: state.feedModelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BlocProvider.value(value: context.read<FeedsBloc>(),child: FeedAdapter(index,'feeds'));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                ),
              ),
              state.isLoadMore ? Padding(
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
