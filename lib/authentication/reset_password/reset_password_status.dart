abstract class ResetPasswordStatus {
  const ResetPasswordStatus();
}

class InitialStatus extends ResetPasswordStatus {
  const InitialStatus();
}

class MobileNumberSubmitting extends ResetPasswordStatus {}

class MobileNumberSubmittedSuccessfully extends ResetPasswordStatus {}

class MobileNumberSubmitFailed extends ResetPasswordStatus {
  final Exception exception;

  MobileNumberSubmitFailed(this.exception);
}

class OTPSubmitting extends ResetPasswordStatus {}

class OTPSubmittedSuccessfully extends ResetPasswordStatus {}

class OTPSubmitFailed extends ResetPasswordStatus {
  final Exception exception;

  OTPSubmitFailed(this.exception);
}

class NewPasswordSubmitting extends ResetPasswordStatus {}

class NewPasswordSubmittedSuccessfully extends ResetPasswordStatus {}

class NewPasswordSubmitFailed extends ResetPasswordStatus {
  final Exception exception;

  NewPasswordSubmitFailed(this.exception);
}
