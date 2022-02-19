import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_event.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_state.dart';
import 'package:queschat/authentication/profile/profile_events.dart';
import 'package:queschat/router/app_router.dart';



class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository authRepo;

  EditProfileBloc({this.authRepo}) : super(EditProfileState()){
    setUserDetails();
  }
  setUserDetails(){
    state.userName=profileBloc.state.name;
    state.phoneNumber=profileBloc.state.phoneNumber;
    state.bio=profileBloc.state.bio;
    state.facebookLink=profileBloc.state.facebookLink;
    state.instagramLink=profileBloc.state.instagramLink;
    state.linkedinLink=profileBloc.state.linkedinLink;
    state.birthDate=profileBloc.state.birthDate;


  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileUsernameChanged) {
      yield state.copyWith(userName: event.username);
    }
    else if (event is EditProfilePhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);

    } else if (event is EditProfileBioChanged) {
      yield state.copyWith(bio: event.bio);

    } else if (event is EditProfileFacebookLinkChanged) {
      yield state.copyWith(facebookLink: event.value);

    } else if (event is EditProfileInstagramLinkChanged) {
      yield state.copyWith(instagramLink: event.value);

    } else if (event is EditProfileLinkedinLinkChanged) {
      yield state.copyWith(linkedinLink: event.value);

    } else if (event is EditProfileBirthDateChanged) {
      yield state.copyWith(birthDate: event.value);

    }  else if (event is EditProfileSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo.editProfile(userName:state.userName,phoneNumber:state.phoneNumber,bio: state.bio,facebookLink:state.facebookLink,instagramLink:state.instagramLink,linkedinLink: state.linkedinLink  ,dob: state.birthDate,);
        try{
          profileBloc.add(ProfileEdited());

        }catch(e){
          print(e);
        }
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());

      }
    }
  }
}