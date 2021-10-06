import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_event.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_state.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';
import 'package:queschat/authentication/profile/profile_events.dart';



class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository authRepo;
  final ProfileBloc profileBloc;

  EditProfileBloc({this.authRepo,this.profileBloc}) : super(EditProfileState()){
    setUserDetails();
  }
  setUserDetails(){
    state.userName=profileBloc.state.name;
    state.phoneNumber=profileBloc.state.phoneNumber;
    state.bio=profileBloc.state.bio;

  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileUsernameChanged) {
      yield state.copyWith(userName: event.username);
    }
    else if (event is EditProfilePhoneNumberChangeChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);

    } else if (event is EditProfileBioChangeChanged) {
      yield state.copyWith(bio: event.bio);

    }  else if (event is EditProfileSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo.editProfile(userName:state.userName,phoneNumber:state.phoneNumber,bio: state.bio);
        profileBloc.add(ProfileEdited());
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());

      }
    }
  }
}