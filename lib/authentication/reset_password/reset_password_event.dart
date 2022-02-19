abstract class ResetPasswordEvent {}

class ForgotOTPChanged extends ResetPasswordEvent {
  final String otp;

  ForgotOTPChanged({this.otp});
}

class ForgotPhoneNumberChanged extends ResetPasswordEvent {
  final String phoneNumber;

  ForgotPhoneNumberChanged({this.phoneNumber});
}

class ResetPasswordChanged extends ResetPasswordEvent {
  final String password;

  ResetPasswordChanged({this.password});
}

class ButtonSubmitted extends ResetPasswordEvent {}

class OTPRequestSubmitted extends ResetPasswordEvent {}

class ReverseButtonSubmitted extends ResetPasswordEvent {}
