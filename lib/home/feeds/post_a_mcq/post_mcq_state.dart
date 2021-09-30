import 'package:queschat/authentication/form_submitting_status.dart';

class PostMcqState {
  String correctOption;
  FormSubmissionStatus formSubmissionStatus;

  String question;
  String get questionValidationText {
    if (question.trim().length == 0) {
      return 'Please enter question';
    } else {
      return null;
    }
  }


  String optionA;
  String get optionAValidationText {
    if (optionA.trim().length == 0) {
      return 'Please enter option';
    } else {
      return null;
    }
  }

  String optionB;

  String get optionBValidationText {
    if (optionB.trim().length == 0) {
      return 'Please enter option';
    } else {
      return null;
    }
  }

  String optionC;

  String get optionCValidationText {
    if (optionC.trim().length == 0) {
      return 'Please enter option';
    } else {
      return null;
    }
  }

  String optionD;

  String get optionDValidationText {
    if (optionD.trim().length == 0) {
      return 'Please enter option';
    } else {
      return null;
    }
  }

  PostMcqState({
    this.question = '',
    this.optionA = '',
    this.optionB = '',
    this.optionC = '',
    this.optionD = '',
    this.correctOption='',
    this.formSubmissionStatus
  });

  PostMcqState copyWith({
    String question,
    String optionA,
    String optionB,
    String optionC,
    String optionD,
    String correctOption,
    FormSubmissionStatus formSubmissionStatus,
  }) {
    return PostMcqState(
      question: question ?? this.question,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctOption: correctOption ?? this.correctOption,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}
