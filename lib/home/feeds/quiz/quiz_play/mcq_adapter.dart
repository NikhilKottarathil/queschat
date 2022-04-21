import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/mcq_option_adapter.dart';
import 'package:queschat/components/multi_file_view_url.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_bloc.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_event.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_state.dart';
import 'package:queschat/models/mcq_model.dart';

class MCQAdapter extends StatelessWidget {
  int index;

  MCQAdapter(this.index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizPlayBloc, QuizPlayState>(builder: (context, state) {
      MCQModel mcqModel = state.feedModels[index].contentModel;

      print(mcqModel.selectedAnswer);
      print(mcqModel.correctAnswer);
      print(mcqModel.optionA);
      return Container(
        color: AppColors.White,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q:',
                    style: TextStyles.mediumBoldTextSecondary,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Text(
                        mcqModel.question,
                        style: TextStyles.mediumRegularTextSecondary,
                      )),

                ],
              ),
            ),
            Visibility(
              visible: mcqModel.media.length > 0,
              child: Center(
                child: SizedBox(
                  height: 300,
                  child: MultiFileViewUrl(
                    mediaUrl: mcqModel.media,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: mcqModel.optionType == 'text',
              child: Column(
                children: [
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'A',
                            answer: mcqModel.optionA));
                    },
                    option: mcqModel.optionA.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'A' ||
                        mcqModel.correctAnswer == 'A')
                        ? mcqModel.correctAnswer == 'A'
                        : null
                        : null,
                    answeredPercentage: mcqModel.optionAPercentage,
                    optionKey: 'A',
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'B',
                            answer: mcqModel.optionB));
                    },
                    option: mcqModel.optionB.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'B' ||
                        mcqModel.correctAnswer == 'B')
                        ? mcqModel.correctAnswer == 'B'
                        : null
                        : null,
                    answeredPercentage: mcqModel.optionBPercentage,

                    optionKey: 'B',
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'C',
                            answer: mcqModel.optionC));
                    },
                    option: mcqModel.optionC.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'C' ||
                        mcqModel.correctAnswer == 'C')
                        ? mcqModel.correctAnswer == 'C'
                        : null
                        : null,
                    answeredPercentage: mcqModel.optionCPercentage,

                    optionKey: 'C',
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'D',
                            answer: mcqModel.optionD));
                    },
                    option: mcqModel.optionD.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'D' ||
                        mcqModel.correctAnswer == 'D')
                        ? mcqModel.correctAnswer == 'D'
                        : null
                        : null,
                    answeredPercentage: mcqModel.optionDPercentage,

                    optionKey: 'D',
                  ),
                ],
              ),
            ),
            Visibility(
              visible: mcqModel.optionType == 'image',
              child: GridView(
                padding: EdgeInsets.all(14),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                children: [
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'A',
                            answer: mcqModel.optionA));
                    },
                    option: mcqModel.optionA.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'A' ||
                        mcqModel.correctAnswer == 'A')
                        ? mcqModel.correctAnswer == 'A'
                        : null
                        : null,
                    optionKey: 'A',
                  ),
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'B',
                            answer: mcqModel.optionB));
                    },
                    option: mcqModel.optionB.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'B' ||
                        mcqModel.correctAnswer == 'B')
                        ? mcqModel.correctAnswer == 'B'
                        : null
                        : null,
                    optionKey: 'B',
                  ),
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'C',
                            answer: mcqModel.optionC));
                    },
                    option: mcqModel.optionC.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'C' ||
                        mcqModel.correctAnswer == 'C')
                        ? mcqModel.correctAnswer == 'C'
                        : null
                        : null,
                    optionKey: 'C',
                  ),
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<QuizPlayBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'D',
                            answer: mcqModel.optionD));
                    },
                    option: mcqModel.optionD.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'D' ||
                        mcqModel.correctAnswer == 'D')
                        ? mcqModel.correctAnswer == 'D'
                        : null
                        : null,
                    optionKey: 'D',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
