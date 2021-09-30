import 'dart:io';

import 'package:queschat/authentication/form_submitting_status.dart';

class PostBlogState {
  String heading;
  List<File> media;
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


  PostBlogState({
    this.media,
    this.heading = '',
    this.content = '',
    this.formSubmissionStatus
  });

  PostBlogState copyWith({
    var media,
    String heading,
    String content,
    FormSubmissionStatus formSubmissionStatus,
  }) {
    return PostBlogState(
      media: media ?? this.media,
      heading: heading ?? this.heading,
      content: content ?? this.content,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}
