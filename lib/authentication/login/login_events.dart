abstract class LoginEvent {}

class LoginPhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  LoginPhoneNumberChanged({this.phoneNumber});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({this.password});
}

class LoginSubmitted extends LoginEvent {}