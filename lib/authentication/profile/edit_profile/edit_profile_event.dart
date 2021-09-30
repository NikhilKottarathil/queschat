abstract class EditProfileEvent {}

class EditProfileUsernameChanged extends EditProfileEvent {
  final String username;

  EditProfileUsernameChanged({this.username});
}

class EditProfilePhoneNumberChangeChanged extends EditProfileEvent {
  final String phoneNumber;

  EditProfilePhoneNumberChangeChanged({this.phoneNumber});
}



class EditProfileSubmitted extends EditProfileEvent {}