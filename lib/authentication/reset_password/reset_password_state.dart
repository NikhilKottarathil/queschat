
import 'package:queschat/authentication/reset_password/reset_password_status.dart';

class ResetPasswordState {
  final String phoneNumber;

  String get phoneNumberValidationText {
    //
    if (phoneNumber.trim().length == 0) {
      return 'Please enter phone number';
    } else if (phoneNumber.trim().length != 10) {
      return 'Enter a valid phone number';
    } else {
      return null;
    }
  }

  final String otp;

  String get otpValidationText {
    //
    if (otp.trim().length == 0) {
      return 'Please enter OTP';
    } else {
      return null;
    }
  }

  final String password;

  String get passwordValidationText {
    if (password.trim().length == 0) {
      return 'Please enter password';
    } else if (password.trim().length < 6) {
      return 'Your password must contain at least 6 characters';
    } else {
      return null;
    }
  }

  final ResetPasswordStatus formStatus;
  String tempToken, verifyOtp;

  ResetPasswordState({
    this.tempToken = '',
    this.verifyOtp = '',
    this.otp = '',
    this.phoneNumber = '',
    this.password = '',
    this.formStatus = const InitialStatus(),
  });

  ResetPasswordState copyWith({
    String tempToken,
    String verifyOtp,
    String otp,
    String phoneNumber,
    String password,
    ResetPasswordStatus formStatus,
  }) {
    return ResetPasswordState(
      tempToken: tempToken ?? this.tempToken,
      verifyOtp: verifyOtp ?? this.verifyOtp,
      otp: otp ?? this.otp,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
