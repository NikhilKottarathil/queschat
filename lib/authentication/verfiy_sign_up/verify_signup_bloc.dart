import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_events.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_state.dart';

import '../auth_repo.dart';

class VerifySignUpBloc extends Bloc<VerifySignUpEvent, VerifySignUpState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  VerifySignUpBloc({this.authRepo, this.authCubit})
      : super(VerifySignUpState());

  @override
  Stream<VerifySignUpState> mapEventToState(VerifySignUpEvent event) async* {
    if (event is VerifySignUpOtpChanged) {
      yield state.copyWith(otp: event.otp);
    } else if (event is VerifySignUpSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      if (state.otp == authCubit.authCredentials.verifyOTP) {
        try {
          final token = await authRepo.signUp(
              username: authCubit.authCredentials.userName,
              password: authCubit.authCredentials.password,
              phoneNumber: authCubit.authCredentials.phoneNumber);
          yield state.copyWith(formStatus: SubmissionSuccess());

          final credentials = authCubit.authCredentials;
          credentials.token = token;
          print(credentials);
          authCubit.showSession(credentials);
        } catch (e) {
          yield state.copyWith(formStatus: SubmissionFailed(e));
        }
      } else {
        Exception exception = Exception(['OTP does not match']);
        yield state.copyWith(formStatus: SubmissionFailed(exception));
        yield state.copyWith(formStatus: InitialFormStatus());
      }
    }
  }
}
