import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/sign_up/sign_up_events.dart';
import 'package:queschat/authentication/sign_up/sign_up_state.dart';
import 'package:queschat/repository/auth_repo.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;

  SignUpBloc({this.authRepo}) : super(SignUpState());

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
       generatedOTP = await authRepo.getSignUpOTP(phoneNumber:state.phoneNumber);
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());

      }
    }
  }
}