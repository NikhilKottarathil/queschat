import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_event.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_state.dart';

class QuizMcqBloc extends Bloc<QuizMcqEvent, QuizMcqState> {
  final QuizMcqState quizMcqState;

  QuizMcqBloc({this.quizMcqState}) : super(quizMcqState);

  @override
  Stream<QuizMcqState> mapEventToState(QuizMcqEvent event) async* {
    if (event is QuestionChanged) {
      yield state.copyWith(question: event.question,questionValidationText: '');
    } else if (event is SelectQuestionImages) {
      try {
        File file;
        file = await selectImage(imageFile: file, context: event.context);
        if(file!=null) {
          state.questionImages.add(file);
        }
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
    } else if (event is ChooseOptionType) {
      yield state.copyWith(isImageOptions: !state.isImageOptions);
    } else if (event is OptionAChanged) {
      yield state.copyWith(optionA: event.optionA,optionAValidationText: '');
    } else if (event is OptionBChanged) {
      yield state.copyWith(optionB: event.optionB,optionBValidationText: '');
    } else if (event is OptionCChanged) {
      yield state.copyWith(optionC: event.optionC,optionCValidationText: '');
    } else if (event is OptionDChanged) {
      yield state.copyWith(optionD: event.optionD,optionDValidationText: '');
    } else if (event is SelectOptionAImage) {
      try {
        state.optionAImage = await selectImage(
            imageFile: state.optionAImage, context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
    } else if (event is SelectOptionBImage) {
      try {
        state.optionBImage = await selectImage(
            imageFile: state.optionBImage, context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
    } else if (event is SelectOptionCImage) {
      try {
        state.optionCImage = await selectImage(
            imageFile: state.optionCImage, context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
    } else if (event is SelectOptionDImage) {
      try {
        state.optionDImage = await selectImage(
            imageFile: state.optionDImage, context: event.context);
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
    } else if (event is CorrectOptionChanged) {
      yield state.copyWith(correctOption: event.correctOption);
    } else if (event is ClearFields) {
      yield state.copyWith(
          correctOption: '',
          optionD: '',
          optionC: '',
          optionB: '',
          optionA: '',
          question: '',
          formSubmissionStatus: InitialFormStatus());
    } else if (event is ValidateMCQ) {
      if (state.question.trim().length == 0) {
        state.questionValidationText = 'Please enter question';
      } else {
        state.questionValidationText = '';
      }
      if (state.optionA.trim().length == 0) {
        state.optionAValidationText = 'Please enter option';
      } else {
        state.optionAValidationText = null;
      }
      if (state.optionB.trim().length == 0) {
        state.optionBValidationText = 'Please enter option';
      } else {
        state.optionBValidationText = null;
      }
      if (state.optionC.trim().length == 0) {
        state.optionCValidationText = 'Please enter option';
      } else {
        state.optionCValidationText = null;
      }
      if (state.optionD.trim().length == 0) {
        state.optionDValidationText = 'Please enter option';
      } else {
        state.optionDValidationText = null;
      }
      if( (state.optionAImage == null ||
          state.optionBImage == null ||
          state.optionCImage == null ||
          state.optionDImage == null ) && state.isImageOptions) {
        Exception e = Exception(['Please Select All Images']);
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));

      }
      if (state.correctOption==null || state.correctOption=='') {
        Exception e = Exception(['Please Select Correct Answer']);
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));

      }

      yield state.copyWith(formSubmissionStatus: InitialFormStatus());
    }
  }
}
