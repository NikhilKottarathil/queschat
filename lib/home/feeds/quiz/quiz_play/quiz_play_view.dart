import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/timer_card.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/mcq_adapter.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_bloc.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_event.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_state.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_result_view.dart';
import 'package:queschat/uicomponents/appbars.dart';

class QuizPlayView extends StatefulWidget {
  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return null;
      },
      child: Scaffold(
        appBar: appBarWithBackButton(
            context: context,
            titleString: "Play Quiz",
            isCenterTitle: false,
            tailActions: [
              BlocBuilder<QuizPlayBloc, QuizPlayState>(
                builder: (context,state) {
                  print('state.duration ${state.duration}');
                  // return buildTimerWidget(Duration(minutes: 10));
                  return buildTimerWidget(Duration(milliseconds: state.duration));
                }
              ),
            ],
            action: () {
              Navigator.of(context).pop();
            }),
        body: BlocListener<QuizPlayBloc, QuizPlayState>(
          listener: (context, state) {
            final formStatus = state.formSubmissionStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            }
            if (formStatus is SubmissionSuccess) {
              if(this.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) =>
                          MultiBlocProvider(providers: [
                            BlocProvider.value(
                              value: context.read<QuizPlayBloc>(),
                            ),

                          ], child: QuizResultView(),)
                  ),);
              }
            }
          },
          child: BlocBuilder<QuizPlayBloc, QuizPlayState>(
              builder: (context, state) {
                print('feed model ${state.feedModels.length}');
                print('feed model ${state.currentIndex}');
            return Scaffold(
              body: PageView.builder(
                itemBuilder: (context, index) {
                  return MCQAdapter(index);
                },
                itemCount: state.feedModels.length,
                controller: controller,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
              ),
              bottomNavigationBar: Container(
                color: AppColors.PrimaryColorLight,
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          state.currentIndex == 0
                              ? Container(
                                  width: 80,
                                )
                              : InkWell(
                                  onTap: () async {
                                    context
                                        .read<QuizPlayBloc>()
                                        .add(ShowPreviousMCQ());
                                    controller.animateToPage(
                                      state.currentIndex-1,
                                      duration:
                                      Duration(milliseconds: 1),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_back_ios,
                                          color: AppColors.White),
                                      Text(
                                        'Prev',
                                        style: TextStyles.smallRegularWhite,
                                      ),
                                    ],
                                  )),
                          InkWell(
                              onTap: () async {
                                if(state.currentIndex==state.mcqIds.length-1){
                                  context.read<QuizPlayBloc>().add(Finished());


                                }else{
                                  context.read<QuizPlayBloc>().add(ShowNextMCQ());
                                  controller.animateToPage(
                                    state.currentIndex+1,
                                    duration:
                                    Duration(milliseconds: 1),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    state.currentIndex == state.mcqIds.length - 1
                                        ? 'FINISH'
                                        : 'Next',
                                    style: TextStyles.smallRegularWhite,
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      color: AppColors.White),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Align(alignment:Alignment.center,child: Text((state.currentIndex+1).toString(),style: TextStyles.mediumBoldWhite,)),

                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
