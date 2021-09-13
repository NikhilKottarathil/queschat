abstract class ForgotPasswordEvent {}





class Button
class ForgotPhoneNumberChanged extends ForgotPasswordEvent {
  final String phoneNumber;

  ForgotPhoneNumberChanged({this.phoneNumber});
}
class ForgotPasswordChanged extends ForgotPasswordEvent {
  final String password;

 ForgotPasswordChanged({this.password});
}Submitted extends ForgotPasswordEvent {}