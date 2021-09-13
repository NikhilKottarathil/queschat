import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/login/login_events.dart';
import 'package:queschat/authentication/login/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginBloc({this.authRepo,this.authCubit}) : super(LoginState());

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
        final token= await authRepo.login(phoneNumber:state.phoneNumber,password: state.password );
        yield state.copyWith(formStatus: SubmissionSuccess());
        authCubit.showSession(new AuthCredentials(token: token));
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());
      }
    }
  }
}