import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_bloc.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_state.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';

class QuizResultView extends StatelessWidget {
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
            titleString: "Result",
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
            }
          },
          child: BlocBuilder<QuizPlayBloc, QuizPlayState>(
              builder: (context, state) {
            print('feed model ${state.feedModels.length}');
            return Padding(
              padding: EdgeInsets.all(20),

              child: Column(
                children: [
                  Flexible(child: Image.asset('images/trophy.png',fit: BoxFit.contain,)),
                  SizedBox(height: 20,),
                  Text('Congratulations',style: TextStyles.largeBoldPrimaryColor,),
                  SizedBox(height: 35,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(state.totalMCQ.toString(),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppColors.TextSecondary,
                                  height: 1.33,
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700)),
                          Text(
                            'Total',
                            style: TextStyles.smallRegularTextTertiary,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(state.attendedMCQ.toString(),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppColors.TextSecondary,
                                  height: 1.33,
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700)),
                          Text(
                            'Attended',
                            style: TextStyles.smallRegularTextTertiary,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(state.correctMCQ.toString(),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppColors.TextSecondary,
                                  height: 1.33,
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w700)),
                          Text(
                            'Correct',
                            style: TextStyles.smallRegularTextTertiary,
                          )
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 35,),
                  Column(
                    children: [
                      Text((state.correctMCQ*int.parse(context.read<QuizPlayBloc>().point)).toString(),
                          style: TextStyle(
                              fontSize: 48,
                              color: AppColors.GreenPrimary,
                              height: 1.33,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700)),
                      Text(
                        'Total Score',
                        style: TextStyles.largeRegularTextTertiary,
                      )
                    ],
                  ),
                  SizedBox(height: 35,),
                  Text(
                    'Completed Time : ${getDurationTime((context.read<QuizPlayBloc>().totalDuration-state.duration).toString())}',
                    style: TextStyles.xMediumRegularTextFourth,
                  ),
                  Spacer(),
                  CustomButton(
                    text: 'Leader Board',
                    action: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/leaderBoard',arguments: {'quizId':context.read<QuizPlayBloc>().quizId});
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
