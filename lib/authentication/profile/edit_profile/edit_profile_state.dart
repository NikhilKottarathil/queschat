import 'package:queschat/authentication/form_submitting_status.dart';

class EditProfileState {
  String userName;

  String get userNameValidationText {
    //
    if (userName.trim().length == 0) {
      return 'Please enter name';
    } else if (userName.trim().length < 4) {
      return 'Username is too short!  at least 4 characters';
    } else {
      return null;
    }
  }

  String phoneNumber;

  String get phoneNumberValidationText {
    //
    if (phoneNumber.trim().length == 0) {
      return 'Please enter phone number';
    } else if (phoneNumber.trim().length != 10) {
      return 'Enter a valid  phone number';
    } else {
      return null;
    }
  }

  String bio;
  DateTime birthDate;
  String facebookLink;
  String instagramLink;
  String linkedinLink;

  final FormSubmissionStatus formStatus;

  EditProfileState(
      {this.userName = '',
      this.phoneNumber = '',
      this.formStatus = const InitialFormStatus(),
      this.bio,
      this.birthDate,
      this.facebookLink,
      this.instagramLink,
      this.linkedinLink});

  EditProfileState copyWith({
    String userName,
    String phoneNumber,
    String bio,
    DateTime birthDate,
    String facebookLink,
    String instagramLink,
    String linkedinLink,

    FormSubmissionStatus formStatus,
  }) {
    return EditProfileState(
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      facebookLink: facebookLink ?? this.facebookLink,
      instagramLink: instagramLink ?? this.instagramLink,
      linkedinLink: linkedinLink ?? this.linkedinLink,
      formStatus: formStatus ?? this.formStatus,

    );
  }
}
