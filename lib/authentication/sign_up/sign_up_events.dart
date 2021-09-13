abstract class SignUpEvent {}

class SignUpUsernameChanged extends SignUpEvent {
  final String username;

  SignUpUsernameChanged({this.username});
}

class SignUpPhoneNumberChangeChanged extends SignUpEvent {
  final String phoneNumber;

  SignUpPhoneNumberChangeChanged({this.phoneNumber});
}
class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({this.password});
}


class SignUpSubmitted extends SignUpEvent {}