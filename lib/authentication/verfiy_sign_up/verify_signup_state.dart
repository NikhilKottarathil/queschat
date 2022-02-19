import 'package:queschat/authentication/form_submitting_status.dart';

enum OTPState { showPhoneNumber, showTimer, showResendOTP }

class VerifySignUpState {
  final String otp;
  int pendingTimeInMills;

  OTPState otpState;

  String get otpValidationText {
    //
    if (otp.trim().length == 0) {
      return 'Please enter OTP';
    }
    // else if (otp.trim().length < 6) {
    //   return 'Enter valid otp';
    // }
    else {
      return null;
    }
  }

  final FormSubmissionStatus formStatus;

  VerifySignUpState({
    this.otp = '',
    this.otpState = OTPState.showTimer,
    this.pendingTimeInMills = 60000,
    this.formStatus = const InitialFormStatus(),
  });

  VerifySignUpState copyWith({
    String otp,
    FormSubmissionStatus formStatus,
    OTPState otpState,
    int pendingTimeInMills,
  }) {
    return VerifySignUpState(
      otp: otp ?? this.otp,
      formStatus: formStatus ?? this.formStatus,
      otpState: otpState ?? this.otpState,
      pendingTimeInMills: pendingTimeInMills ?? this.pendingTimeInMills,
    );
  }
}
