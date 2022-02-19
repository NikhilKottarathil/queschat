import 'package:queschat/authentication/form_submitting_status.dart';

enum OTPState { showPhoneNumber, showTimer, showResendOTP }


class OTPLoginState {
  int pendingTimeInMills;

  OTPState otpState;
  String token;

  String phoneNumber = '';

  String get phoneNumberValidationText {
    if (phoneNumber.trim().length == 0) {
      return 'Please enter phone number';
    } else if (phoneNumber.trim().length != 10) {
      return 'Enter a 10 digit  phone number';
    } else {
      return null;
    }
  }

  String otp = '';

  String generatedOTP = '';
  String verificationId = '';

  String get otpValidationText {
    if (otp.trim().length == 0) {
      return 'Please enter password';
    } else {
      return null;
    }
  }

  final FormSubmissionStatus formStatus;

  OTPLoginState({
    this.phoneNumber = '',
    this.otp = '',
    this.token,
    this.generatedOTP = '',
    this.verificationId = '',
    this.otpState = OTPState.showPhoneNumber,
    this.pendingTimeInMills = 60000,
    this.formStatus = const InitialFormStatus(),
  });

  OTPLoginState copyWith({
    String phoneNumber,
    String otp,
    String generatedOTP,
    String verificationId,
    OTPState otpState,
    int pendingTimeInMills,
    String token,
    FormSubmissionStatus formStatus,
  }) {
    return OTPLoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      generatedOTP: generatedOTP ?? this.generatedOTP,
      verificationId: verificationId ?? this.verificationId,
      token: token ?? this.token,
      formStatus: formStatus ?? this.formStatus,
      otpState: otpState ?? this.otpState,
      pendingTimeInMills: pendingTimeInMills ?? this.pendingTimeInMills,
    );
  }
}
