import 'dart:io';

import 'package:queschat/authentication/form_submitting_status.dart';

class PostPollState {
  FormSubmissionStatus formSubmissionStatus;

  String question;
  List<File> questionImages;
  bool isImageOptions;
  int numberOfOption=2;

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
  File  optionAImage,optionBImage,optionCImage,optionDImage;

  PostPollState({
    this.question = '',
    this.questionImages,
    this.optionA = '',
    this.optionB = '',
    this.optionC = '',
    this.optionD = '',
    this.numberOfOption=2,
    this.formSubmissionStatus,
    this.optionAImage,
    this.optionBImage,
    this.optionCImage,
    this.optionDImage,
    this.isImageOptions=false,
  });

  PostPollState copyWith({
    String question,
    String optionA,
    String optionB,
    String optionC,
    String optionD,
    int numberOfOption,
    FormSubmissionStatus formSubmissionStatus,
    File  optionAImage,optionBImage,optionCImage,optionDImage,
    List<File> questionImages,
    bool isImageOptions,

  }) {
    return PostPollState(
      question: question ?? this.question,
      questionImages: questionImages ?? this.questionImages,
      isImageOptions: isImageOptions ?? this.isImageOptions,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      optionAImage: optionAImage ?? this.optionAImage,
      optionBImage: optionBImage ?? this.optionBImage,
      optionCImage: optionCImage ?? this.optionCImage,
      optionDImage: optionDImage ?? this.optionDImage,
      numberOfOption: numberOfOption ?? this.numberOfOption,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}
