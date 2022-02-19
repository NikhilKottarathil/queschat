
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_state.dart';

abstract class VerifySignUpEvent {}

class VerifySignUpOtpChanged extends VerifySignUpEvent {
  final String otp;

  VerifySignUpOtpChanged({this.otp});
}

class ResendOTPSubmitted extends VerifySignUpEvent {}

class ResendOTPSubmittedSuccess extends VerifySignUpEvent {}

class TimerChanged extends VerifySignUpEvent {
  int pendingTime;
  OTPState otpState;

  TimerChanged({this.pendingTime, this.otpState});
}

class VerifySignUpSubmitted extends VerifySignUpEvent {}

class VerifySignUpSubmittedSuccessfully extends VerifySignUpEvent {}
