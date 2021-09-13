abstract class VerifySignUpEvent {}

class VerifySignUpOtpChanged extends VerifySignUpEvent {
  final String otp;

  VerifySignUpOtpChanged({this.otp});
}

class VerifySignUpSubmitted extends VerifySignUpEvent {}