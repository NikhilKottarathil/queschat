import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/sign_up/sign_up_events.dart';
import 'package:queschat/authentication/sign_up/sign_up_state.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/router/app_router.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;
  String phoneNumber;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  SignUpBloc({this.authRepo,this.phoneNumber}) : super(SignUpState(phoneNumber: phoneNumber));

  String generatedOTP;
  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpUsernameChanged) {
      yield state.copyWith(userName: event.username);
    }
    else if (event is SignUpPhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);

    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(password: event.password);

    } else if (event is SignUpSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        print('try signin');

        AuthCredentials signupCredentials = await authRepo.signUp(
            username:state.userName,
            phoneNumber: state.phoneNumber);
        print('try signinfailed');

        // await firebaseAuth
        //     .signInWithCustomToken(signupCredentials.firebaseToken);
        await authRepo.updateFirebaseDeviceToken();

        await AppData().setUserDetails();
        resetRepositoryAndBloc();

        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        print('try signinfailed with $e');

        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());
      }
    }
  }
}