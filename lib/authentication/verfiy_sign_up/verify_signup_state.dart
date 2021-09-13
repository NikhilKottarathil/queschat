import 'package:queschat/authentication/form_submitting_status.dart';

class VerifySignUpState {
  final String otp;

  String get otpValidationText {
    //
    if (otp.trim().length == 0) {
      return 'Please enter OTP';
    } else if (otp.trim().length < 6) {
      return 'Enter valid otp';
    } else {
      return null;
    }
  }

  final FormSubmissionStatus formStatus;

  VerifySignUpState({
    this.otp = '',
    this.formStatus = const InitialFormStatus(),
  });

  VerifySignUpState copyWith({
    String otp,
    FormSubmissionStatus formStatus,
  }) {
    return VerifySignUpState(
      otp: otp ?? this.otp,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
