import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/otp_login/otp_login_events.dart';
import 'package:queschat/authentication/otp_login/otp_login_state.dart';
import 'package:queschat/constants/strings_and_urls.dart';

import 'package:queschat/repository/auth_repo.dart';


class OTPLoginBloc extends Bloc<OTPLoginEvent, OTPLoginState> {
  final AuthRepository authRepo;

  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Timer _timer;
  int resendToken;
  String firebaseToken;

  OTPLoginBloc({this.authRepo}) : super(OTPLoginState());

  void startTimer() {
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (state.pendingTimeInMills <= 1000) {
          add(TimerChanged(pendingTime: 0, otpState: OTPState.showResendOTP));
        } else {
          add(TimerChanged(
              pendingTime: state.pendingTimeInMills - 1000,
              otpState: OTPState.showTimer));
        }
      },
    );
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _timer.cancel();
    return super.close();
  }

  @override
  Stream<OTPLoginState> mapEventToState(OTPLoginEvent event) async* {
    if (event is PhoneNumberChanged) {
      yield state.copyWith(
          phoneNumber: event.phoneNumber, formStatus: InitialFormStatus());
    } else if (event is OTPChanged) {
      yield state.copyWith(otp: event.otp, formStatus: InitialFormStatus());
    } else if (event is TimerChanged) {
      yield state.copyWith(
          pendingTimeInMills: event.pendingTime,
          otpState: event.otpState,
          formStatus: InitialFormStatus());
    } else if (event is GetOTPSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        AuthCredentials authCredentials = await authRepo.loginByOTP(
            phoneNumber: state.phoneNumber);

        firebaseToken = authCredentials.firebaseToken;
        add(GetOTPSubmittedSuccess(
            generatedOTP: authCredentials.generatedOTP));
      }catch(e){
        state.copyWith(formStatus: SubmissionFailed(AppExceptions().somethingWentWrong));

      }
    } else if (event is GetOTPSubmittedSuccess) {
      state.pendingTimeInMills = 60000;
      startTimer();
      yield state.copyWith(
          otpState: OTPState.showTimer,
          otp: '',
          generatedOTP: event.generatedOTP,
          formStatus: InitialFormStatus());
    } else if (event is ResendOTPSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        AuthCredentials authCredentials = await authRepo.loginByOTP(
            phoneNumber: state.phoneNumber);

        firebaseToken = authCredentials.firebaseToken;
        add(GetOTPSubmittedSuccess(
            generatedOTP: authCredentials.generatedOTP));
      }catch(e){
        state.copyWith(formStatus: SubmissionFailed(AppExceptions().somethingWentWrong));

      }
    } else if (event is OTPLoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      if(state.otp== state.generatedOTP){
        add(OTPLoginSubmittedSuccess());

      }else{
        state.copyWith(formStatus: SubmissionFailed(Exception('OTP does not match')));
      }

    } else if (event is OTPLoginSubmittedSuccess) {
      try {


        // await firebaseAuth.signInWithCustomToken(firebaseToken);
        AppData appData = AppData();
        await authRepo.updateFirebaseDeviceToken();

        await appData.setUserDetails();
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: InitialFormStatus());
      }
    }
  }
}
