import 'dart:io';

import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_state.dart';

class PostQuizState {
   String heading;
  List<QuizMcqState> mcqList;
  int currentIndex;
  List<File> images;
  FormSubmissionStatus formSubmissionStatus;

  String get headingValidationText {
    if (heading.trim().length == 0) {
      return 'Please enter heading';
    } else {
      return null;
    }
  }


  String content;
  String get contentAValidationText {
    if (content.trim().length == 0) {
      return 'Please enter content';
    } else {
      return null;
    }
  }


  PostQuizState({
    this.mcqList,
    this.heading = '',
    this.images ,
    this.content = '',
    this.currentIndex,
    this.formSubmissionStatus
  });

  PostQuizState copyWith({
    List<QuizMcqState> mcqList,
    var images,
    String heading,
    int currentIndex=0,
    String content,
    FormSubmissionStatus formSubmissionStatus,
  }) {
    return PostQuizState(
      mcqList: mcqList ?? this.mcqList,
      currentIndex: currentIndex ?? this.currentIndex,
      images: images ?? this.images,
      heading: heading ?? this.heading,
      content: content ?? this.content,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}
