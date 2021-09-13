import 'package:queschat/authentication/form_submitting_status.dart';

class LoginState {
  final String phoneNumber;

  String get phoneNumberValidationText {
    //
    if (phoneNumber.trim().length == 0) {
      return 'Please enter phone number';
    } else if (phoneNumber.trim().length!=10) {
      return 'Enter a 10 digit  phone number';
    } else {
      return null;
    }
  }

  final String password;

  String get passwordValidationText {
    if (password.trim().length == 0) {
      return 'Please enter password';
    } else {
      return null;
    }
  }

  final FormSubmissionStatus formStatus;

  LoginState({
    this.phoneNumber = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String phoneNumber,
    String password,
    FormSubmissionStatus formStatus,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
