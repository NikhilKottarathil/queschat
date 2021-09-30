abstract class ForgotPasswordEvent {}

class ForgotOTPChanged extends ForgotPasswordEvent {
  final String otp;

  ForgotOTPChanged({this.otp});
}

class ForgotPhoneNumberChanged extends ForgotPasswordEvent {
  final String phoneNumber;

  ForgotPhoneNumberChanged({this.phoneNumber});
}
class ForgotPasswordChanged extends ForgotPasswordEvent {
  final String password;

 ForgotPasswordChanged({this.password});
}


class ButtonSubmitted extends ForgotPasswordEvent {}
class ReverseButtonSubmitted extends ForgotPasswordEvent {}