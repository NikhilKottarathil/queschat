
import 'package:queschat/authentication/otp_login/otp_login_state.dart';

abstract class OTPLoginEvent {}

class PhoneNumberChanged extends OTPLoginEvent {
  final String phoneNumber;

  PhoneNumberChanged({this.phoneNumber});
}

class GetOTPSubmitted extends OTPLoginEvent {}

class GetOTPSubmittedSuccess extends OTPLoginEvent {
  String generatedOTP;

  GetOTPSubmittedSuccess({this.generatedOTP});
}

class OTPChanged extends OTPLoginEvent {
  final String otp;

  OTPChanged({this.otp});
}
class ChangeNumberPressed extends OTPLoginEvent {
}

class ResendOTPSubmitted extends OTPLoginEvent {}

class TimerChanged extends OTPLoginEvent {
  int pendingTime;
  OTPState otpState;

  TimerChanged({this.pendingTime, this.otpState});
}

class OTPLoginSubmitted extends OTPLoginEvent {}

class OTPLoginSubmittedSuccess extends OTPLoginEvent {}
