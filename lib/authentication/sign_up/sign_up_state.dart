import 'package:queschat/authentication/form_submitting_status.dart';

class SignUpState {

  final String userName;

  String get userNameValidationText {
    //
    if (userName.trim().length == 0) {
      return 'Please enter name';
    } else if (userName.trim().length<6) {
      return 'Username is too short';
    } else {
      return null;
    }
  }


  final String phoneNumber;

  String get phoneNumberValidationText {
    //
    if (phoneNumber.trim().length == 0) {
      return 'Please enter phone number';
    } else if (phoneNumber.trim().length<10) {
      return 'Enter a valid  phone number';
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

  final FormSubmissionStatus formStatus;

  SignUpState({
    this.userName = '',
    this.phoneNumber = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String userName,
    String phoneNumber,
    String password,
    FormSubmissionStatus formStatus,
  }) {
    return SignUpState(
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
