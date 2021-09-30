abstract class ForgotPasswordStatus {
  const ForgotPasswordStatus();
}

class InitialStatus extends ForgotPasswordStatus {
  const InitialStatus();
}

class MobileNumberSubmitting extends ForgotPasswordStatus {}

class MobileNumberSubmittedSuccessfully extends ForgotPasswordStatus {}

class MobileNumberSubmitFailed extends ForgotPasswordStatus {
  final Exception exception;

  MobileNumberSubmitFailed(this.exception);
}

class OTPSubmitting extends ForgotPasswordStatus {}

class OTPSubmittedSuccessfully extends ForgotPasswordStatus {}

class OTPSubmitFailed extends ForgotPasswordStatus {
  final Exception exception;

  OTPSubmitFailed(this.exception);
}

class NewPasswordSubmitting extends ForgotPasswordStatus {}

class NewPasswordSubmittedSuccessfully extends ForgotPasswordStatus {}

class NewPasswordSubmitFailed extends ForgotPasswordStatus {
  final Exception exception;

  NewPasswordSubmitFailed(this.exception);
}
