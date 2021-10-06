import 'dart:io';

import 'package:queschat/authentication/form_submitting_status.dart';

class PostBlogState {
   String heading;
  List<File> media;
  List<String> mediaUrls;
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
    this.mediaUrls,
    this.heading = '',
    this.content = '',
    this.formSubmissionStatus
  });

  PostBlogState copyWith({
    List<File> media,
    List<String> mediaUrls,
    String heading,
    String content,
    FormSubmissionStatus formSubmissionStatus,
  }) {
    return PostBlogState(
      media: media ?? this.media,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      heading: heading ?? this.heading,
      content: content ?? this.content,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}
