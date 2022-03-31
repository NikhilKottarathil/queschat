import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_bloc.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_event.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_state.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_bloc.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_event.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_state.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_view.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';

class AddMCQsView extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // context.read<PostQuizBloc>().add(ClearAllFields());
        return null;
      },
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: appBarWithBackButton(
              context: context,
              titleString: "Add Poll",
              // tailActions: [
              //   TextButton(
              //       onPressed: () {
              //       },
              //       child: Text('Post\t \t',
              //           style: TextStyle(
              //               color: Color(0xFF004C93),
              //               fontFamily: 'NunitoSans',
              //               fontWeight: FontWeight.w700,
              //               fontSize: 20))),
              // ],
              action: () {
                Navigator.of(context).pop();
              }),
          body: BlocListener<PostQuizBloc, PostQuizState>(
            listener: (context, state) {
              final formStatus = state.formSubmissionStatus;
              if (formStatus is SubmissionFailed) {
                showSnackBar(context, formStatus.exception);
              }
              if (formStatus is SubmissionSuccess) {
                // context.read<FeedsBloc>().add(UserAddedNewFeed(id: formStatus.id));
                context.read<PostQuizBloc>().add(ClearAllFields());

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<PostQuizBloc, PostQuizState>(
                builder: (context, state) {
                  return PageView.builder(
                    itemBuilder: (context, index) {
                      return BlocProvider(
                        create: (context) =>
                            QuizMcqBloc(quizMcqState: state.mcqList[index]),
                        child: Scaffold(
                          body: QuizMCQView(),
                          bottomSheet: BlocBuilder<QuizMcqBloc, QuizMcqState>(
                            builder: (context, mcqState) {
                              print('quiz mcq reload ');
                              print(mcqState.question);

                              return Container(
                                color: AppColors.PrimaryColorLight,
                                height: 50,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    state.mcqList.length == 1
                                        ? Container(width: 80,)
                                        : InkWell(
                                        onTap: () async {
                                          context
                                              .read<QuizMcqBloc>()
                                              .add(ValidateMCQ());
                                          if (mcqState.isFormSuccess) {
                                            context.read<PostQuizBloc>().add(
                                                ShowPreviousMCQ(mcqState));
                                            await Future.delayed(
                                                Duration(microseconds: 100));
                                            int page = state.currentIndex - 1;
                                            controller.animateToPage(
                                              page,
                                              duration:
                                              Duration(milliseconds: 1),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.arrow_back_ios,
                                                color: AppColors.White),
                                            Text('Prev', style: TextStyles
                                                .smallRegularWhite,),

                                          ],
                                        )),
                                    TextButton(
                                      onPressed: ()async {
                                        context
                                            .read<QuizMcqBloc>()
                                            .add(ValidateMCQ());
                                        print(
                                            'form is success ${mcqState
                                                .isFormSuccess}');

                                        if (mcqState.isFormSuccess) {
                                         showPostAlert(context,mcqState);
                                        }
                                      },
                                      child: Text(
                                       'POST QUIZ',
                                        style: TextStyles.mediumBoldWhite,
                                      ),
                                    ),
                                    state.currentIndex == state.mcqList.length - 1
                                        ? InkWell(
                                        onTap: () async {
                                          context
                                              .read<QuizMcqBloc>()
                                              .add(ValidateMCQ());
                                          print(
                                              'form is success ${mcqState
                                                  .isFormSuccess}');

                                          if (mcqState.isFormSuccess) {
                                            context
                                                .read<PostQuizBloc>()
                                                .add(AddNewMCQ(mcqState));
                                            await Future.delayed(
                                                Duration(microseconds: 100));
                                            int page = state.currentIndex + 1;
                                            controller.animateToPage(
                                              page,
                                              duration:
                                              Duration(milliseconds: 1),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: AppColors.White,
                                            ),
                                            Text('New', style: TextStyles
                                                .smallRegularWhite,),

                                          ],
                                        ))
                                        : InkWell(
                                        onTap: () async {
                                          context
                                              .read<QuizMcqBloc>()
                                              .add(ValidateMCQ());
                                          if (mcqState.isFormSuccess) {
                                            context
                                                .read<PostQuizBloc>()
                                                .add(ShowNextMCQ(mcqState));
                                            await Future.delayed(
                                                Duration(microseconds: 100));
                                            int page = state.currentIndex + 1;
                                            controller.animateToPage(
                                              page,
                                              duration:
                                              Duration(milliseconds: 1),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text('Next', style: TextStyles
                                                .smallRegularWhite,),
                                            Icon(Icons.arrow_forward_ios,
                                                color: AppColors.White),
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    itemCount: state.mcqList.length,
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                  );
                }),
          ),
        ),
      ),
    );
  }

}
void showPostAlert(BuildContext buildContext,QuizMcqState quizMcqState) {
  showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      builder: (context){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Align(
            alignment: Alignment.centerLeft,
              child: Text('Are your sure ?',style: TextStyles.heading2TextPrimary,)),
          CustomButton(
            action: () {
              buildContext.read<PostQuizBloc>().add(PostQuizSubmitted(quizMcqState));
              Navigator.pop(context);
            },
            text: 'Post',
          ),
          SizedBox(height: 10,),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20,left: 20,right: 20),

                child: Text(
                  'Cancel',
                  style: TextStyles.buttonPrimary,
                ),
              ))
        ],
      ),
    );
  });
}
