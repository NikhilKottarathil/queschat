abstract class EditProfileEvent {}

class EditProfileUsernameChanged extends EditProfileEvent {
  final String username;

  EditProfileUsernameChanged({this.username});
}

class EditProfilePhoneNumberChanged extends EditProfileEvent {
  final String phoneNumber;

  EditProfilePhoneNumberChanged({this.phoneNumber});
}

class EditProfileBioChanged extends EditProfileEvent {
  final String bio;

  EditProfileBioChanged({this.bio});
}

class EditProfileBirthDateChanged extends EditProfileEvent {
  final DateTime value;

  EditProfileBirthDateChanged({this.value});
}

class EditProfileFacebookLinkChanged extends EditProfileEvent {
  final String value;

  EditProfileFacebookLinkChanged({this.value});
}

class EditProfileInstagramLinkChanged extends EditProfileEvent {
  final String value;

  EditProfileInstagramLinkChanged({this.value});
}

class EditProfileLinkedinLinkChanged extends EditProfileEvent {
  final String value;

  EditProfileLinkedinLinkChanged({this.value});
}

class EditProfileSubmitted extends EditProfileEvent {}
