import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_adapter.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_cubit.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_state.dart';
import 'package:queschat/uicomponents/appbars.dart';

class LeaderBoardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    bool isSearchPressed = false;
    print('pageBuild');

    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<LeaderBoardCubit>().loadMoreData();
      }
    });
    return BlocListener<LeaderBoardCubit, LeaderBoardState>(
      listener: (context, state) {
        // if (state is Authenticated) {
        //   Navigator.pushReplacementNamed(context, '/home');
        //
        // } else if (state is Unauthenticated) {
        //   Navigator.pushReplacementNamed(context, '/login');
        // }
      },
      child: Scaffold(
        appBar: appBarWithBackButton(context: context, titleString: ''),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leader Board',
                style: TextStyles.largeBoldPrimaryColor,
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
                  buildWhen: (previousState, state) {
                return state is LoadList || state is InitialState;
              }, builder: (BuildContext context, LeaderBoardState state) {
                if (state is LoadList) {
                  return state.items.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LeaderBoardWinnerAdapter(
                              model: state.items.length>=2?state.items[1]:null,
                              rank: 2,
                            ),
                            LeaderBoardWinnerAdapter(
                              model: state.items[0],
                              rank: 1,
                            ),
                            LeaderBoardWinnerAdapter(
                              model: state.items.length>=3?state.items[1]:null,
                              rank: 3,
                            )
                          ],
                        )
                      : Container();
                }
                return SizedBox(height: 200);
              }),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
                    buildWhen: (previousState, state) {
                  return state is LoadList || state is InitialState;
                }, builder: (BuildContext context, LeaderBoardState state) {
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
                    return state.items.isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                            itemCount: state.items.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return LeaderBoardAdapter(
                                onPressed: () {},
                                index: index,
                                model: state.items[index],
                              );
                            },
                          )
                        : Center(
                            child: Text('You have no notification'),
                          );
                  }
                  return CustomProgressIndicator();
                }),
              ),
              BlocBuilder<LeaderBoardCubit, LeaderBoardState>(
                  builder: (BuildContext context, LeaderBoardState state) {
                if (state is LoadMoreState) {
                  return CustomProgressIndicator();
                }

                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
