

import 'dart:io';

import 'package:queschat/authentication/form_submitting_status.dart';

class ReportState {
  String reason,phoneNumber;
  int step;
  List<String> reasons=["It's spam",'Nudity or sexual content','Hate speech or symbols'];
  FormSubmissionStatus formSubmissionStatus;


  ReportState({
    this.reason='',
    this.phoneNumber='',
    this.formSubmissionStatus= const InitialFormStatus(),
    this.step,
  });

  ReportState copyWith({
    String reason,
    String phoneNumber,
    int step,
    FormSubmissionStatus formSubmissionStatus
  }) {
    return ReportState(
      reason:reason ?? this.reason,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      step: step ?? this.step,
      formSubmissionStatus: formSubmissionStatus ?? this.formSubmissionStatus,
    );
  }
}
