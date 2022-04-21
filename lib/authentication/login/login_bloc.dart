import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/login/login_events.dart';
import 'package:queschat/authentication/login/login_state.dart';
import 'package:queschat/repository/auth_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({this.authRepo}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Phone Number updated
    if (event is LoginPhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);

      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);

      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final authCredentials = await authRepo.login(
            phoneNumber: state.phoneNumber, password: state.password);

        print(authCredentials.firebaseToken);
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        // await firebaseAuth.signInWithCustomToken(authCredentials.firebaseToken);

        await authRepo.updateFirebaseDeviceToken();

        AppData appData = AppData();
        await appData.setUserDetails();

        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        print(e);
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());
      }
    }
  }
}
