import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_event.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_state.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_status.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepo;

  ForgotPasswordBloc({this.authRepo})
      : super(ForgotPasswordState());

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is ForgotPhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);
    } else if (event is ForgotOTPChanged) {
      yield state.copyWith(otp: event.otp);
    } else if (event is ForgotPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is ButtonSubmitted) {
      if (state.formStatus is InitialStatus) {
        yield state.copyWith(formStatus: MobileNumberSubmitting());
        try {
          final data = await authRepo.getForgotPasswordOTP(
              phoneNumber: state.phoneNumber);

          final verifyOtp = data[0];
          final tempToken = data[1];
          yield state.copyWith(
              formStatus: MobileNumberSubmittedSuccessfully(),
              verifyOtp: verifyOtp,
              tempToken: tempToken);
        } catch (e) {
          yield state.copyWith(formStatus: MobileNumberSubmitFailed(e));
          yield state.copyWith(formStatus: InitialStatus());
        }
      } else if (state.formStatus is MobileNumberSubmittedSuccessfully) {
        yield state.copyWith(formStatus: OTPSubmitting());

        if (state.verifyOtp.trim() == state.otp.trim()) {
          yield state.copyWith(formStatus: OTPSubmittedSuccessfully());
        } else {
          Exception e = new Exception(['Please enter valid OTP']);
          yield state.copyWith(formStatus: OTPSubmitFailed(e));
          yield state.copyWith(formStatus: MobileNumberSubmittedSuccessfully());
        }
      } else if (state.formStatus is OTPSubmittedSuccessfully) {
        yield state.copyWith(formStatus: NewPasswordSubmitting());
        try {
          await authRepo.changePassword(
              password: state.password, token: state.tempToken);

          yield state.copyWith(formStatus: NewPasswordSubmittedSuccessfully());
        } catch (e) {
          yield state.copyWith(formStatus: NewPasswordSubmitFailed(e));
          yield state.copyWith(formStatus: OTPSubmittedSuccessfully());
        }
      } else if (state.formStatus is NewPasswordSubmittedSuccessfully) {
        // authCubit.showLogin();
      }
    } else if (event is ReverseButtonSubmitted) {
      if (state.formStatus is InitialStatus ||
          state.formStatus is MobileNumberSubmitting ||
          state.formStatus is MobileNumberSubmitFailed ||
          state.formStatus is NewPasswordSubmittedSuccessfully) {
        // authCubit.showLogin();
      } else if (state.formStatus is MobileNumberSubmittedSuccessfully ||
          state.formStatus is OTPSubmitting ||
          state.formStatus is OTPSubmitFailed) {
        yield state.copyWith( otp: '',formStatus: InitialStatus());
      } else if (state.formStatus is OTPSubmittedSuccessfully ||
          state.formStatus is NewPasswordSubmitting ||
          state.formStatus is NewPasswordSubmitFailed) {
        yield state.copyWith( password:'',formStatus: MobileNumberSubmittedSuccessfully());
      }
    }
  }
}
