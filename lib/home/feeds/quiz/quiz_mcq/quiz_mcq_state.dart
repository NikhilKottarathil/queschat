import 'dart:io';

import 'package:queschat/authentication/form_submitting_status.dart';

class QuizMcqState  {
  String correctOption;
  FormSubmissionStatus formSubmissionStatus;

  String question;
  List<File> questionImages;
  bool isImageOptions;

  String questionValidationText;

  String optionA;
  String optionAValidationText;

  String optionB;
  String optionBValidationText;

  String optionC;
  String optionCValidationText;

  String optionD;
  String optionDValidationText;

  File optionAImage, optionBImage, optionCImage, optionDImage;

  bool get isFormSuccess {
    if (question.trim().length == 0) {
      return false;
    } else if (optionA.trim().length == 0 && !isImageOptions) {
      return false;
    } else if (optionB.trim().length == 0  && !isImageOptions) {
      return false;
    } else if (optionC.trim().length == 0  && !isImageOptions) {
      return false;
    } else if (optionD.trim().length == 0  && !isImageOptions) {
      return false;
    }else if (correctOption.trim().length == 0) {
      return false;
    } else if ((optionAImage == null ||
        optionBImage == null ||
        optionCImage == null ||
        optionDImage == null )  && isImageOptions){
      return false;
    } else {
      return true;
    }
  }

  QuizMcqState({
    this.question = '',
    this.questionImages,
    this.optionA = '',
    this.optionB = '',
    this.optionC = '',
    this.optionD = '',
    this.correctOption = '',
    this.formSubmissionStatus,
    this.optionAImage,
    this.optionBImage,
    this.optionCImage,
    this.optionDImage,
    this.isImageOptions = false,
    this.questionValidationText,
    this.optionCValidationText,
    this.optionBValidationText,
    this.optionAValidationText,
    this.optionDValidationText,
  });

  QuizMcqState copyWith({
    String question,questionValidationText,

    String optionA,
    String optionAValidationText,

    String optionB,
    String optionBValidationText,

    String optionC,
    String optionCValidationText,

    String optionD,
    String optionDValidationText,

    String correctOption,
    FormSubmissionStatus formSubmissionStatus,
    File optionAImage,
    optionBImage,
    optionCImage,
    optionDImage,
    List<File> questionImages,
    bool isImageOptions,
  }) {
    return QuizMcqState(
      question: question ?? this.question,
      questionValidationText: questionValidationText ?? this.questionValidationText,
      optionAValidationText: optionAValidationText ?? this.optionAValidationText,
      optionBValidationText: optionBValidationText ?? this.optionBValidationText,
      optionCValidationText: optionCValidationText ?? this.optionCValidationText,
      optionDValidationText: optionDValidationText ?? this.optionDValidationText,
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
      correctOption: correctOption ?? this.correctOption,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }

  // @override
  // // TODO: implement props
  // List<Object> get props => [this.question = '',
  //   this.questionImages,
  //   this.optionA = '',
  //   this.optionB = '',
  //   this.optionC = '',
  //   this.optionD = '',
  //   this.correctOption = '',
  //   this.formSubmissionStatus,
  //   this.optionAImage,
  //   this.optionBImage,
  //   this.optionCImage,
  //   this.optionDImage,
  //   this.isImageOptions = false,
  //   this.questionValidationText,
  //   this.optionCValidationText,
  //   this.optionBValidationText,
  //   this.optionAValidationText,
  //   this.optionDValidationText];
}
