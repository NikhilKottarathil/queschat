abstract class EditProfileEvent {}

class EditProfileUsernameChanged extends EditProfileEvent {
  final String username;

  EditProfileUsernameChanged({this.username});
}

class EditProfilePhoneNumberChangeChanged extends EditProfileEvent {
  final String phoneNumber;

  EditProfilePhoneNumberChangeChanged({this.phoneNumber});
}
class EditProfileBioChangeChanged extends EditProfileEvent {
  final String bio;

  EditProfileBioChangeChanged({this.bio});
}



class EditProfileSubmitted extends EditProfileEvent {}