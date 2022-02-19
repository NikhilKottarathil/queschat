import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_events.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_state.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/router/app_router.dart';

class VerifySignUpBloc extends Bloc<VerifySignUpEvent, VerifySignUpState> {
  final AuthRepository authRepo;

  // final
  Timer _timer;
  AuthCredentials authCredentials;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  VerifySignUpBloc({this.authRepo, this.authCredentials})
      : super(VerifySignUpState()) {
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (state.pendingTimeInMills <= 1000) {
          add(TimerChanged(pendingTime: 0, otpState: OTPState.showResendOTP));
        } else {
          // state.pendingTimeInMills = state.pendingTimeInMills - 1000;
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
  Stream<VerifySignUpState> mapEventToState(VerifySignUpEvent event) async* {
    if (event is VerifySignUpOtpChanged) {
      yield state.copyWith(otp: event.otp);
    } else if (event is TimerChanged) {
      yield state.copyWith(
          pendingTimeInMills: event.pendingTime, otpState: event.otpState);
    } else if (event is ResendOTPSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        authCredentials.generatedOTP = await authRepo.getSignUpOTP(
            phoneNumber: authCredentials.phoneNumber);

        // firebaseAuth.verifyPhoneNumber(
        //     timeout: Duration(seconds: 60),
        //     phoneNumber: '+91' + authCredentials.phoneNumber,
        //     verificationCompleted: (verificationCompleted) async {},
        //     forceResendingToken: authCredentials.resendToken,
        //     verificationFailed: (verificationFailed) async {},
        //     codeSent: (verificationId, resendingToken) async {
        //       authCredentials.verificationId = verificationId;
        //       authCredentials.resendToken = resendingToken;
        //       add(ResendOTPSubmittedSuccess());
        //     },
        //     codeAutoRetrievalTimeout: (verificationId) {});
      } catch (e) {
        print(e);
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    } else if (event is ResendOTPSubmittedSuccess) {
      state.pendingTimeInMills = 60000;
      startTimer();
      yield state.copyWith(
          formStatus: InitialFormStatus(),
          otpState: OTPState.showTimer,
          otp: '');
    } else if (event is VerifySignUpSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      if (state.otp == authCredentials.generatedOTP) {
        add(VerifySignUpSubmittedSuccessfully());
      } else {
        Exception exception = Exception(['OTP does not match or TimeOut']);
        yield state.copyWith(formStatus: SubmissionFailed(exception));
        yield state.copyWith(formStatus: InitialFormStatus());
      }
      // try {
      //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //       verificationId: authCredentials.verificationId, smsCode: state.otp);
      //
      //   await firebaseAuth.signInWithCredential(credential);
      //   await firebaseAuth.signOut();
      //   add(VerifySignUpSubmittedSuccessfully());
      // } catch (e) {
      //   Exception exception = Exception(['OTP does not match or TimeOut']);
      //   yield state.copyWith(formStatus: SubmissionFailed(exception));
      //   yield state.copyWith(formStatus: InitialFormStatus());
      // }
    } else if (event is VerifySignUpSubmittedSuccessfully) {
      print('after otp');
      try {
        print('try signin');

        AuthCredentials signupCredentials = await authRepo.signUp(
            username: authCredentials.userName,
            password: authCredentials.password,
            phoneNumber: authCredentials.phoneNumber);
        print('try signinfailed');

        await firebaseAuth
            .signInWithCustomToken(signupCredentials.firebaseToken);
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

// class VerifySignUpBloc extends Bloc<VerifySignUpEvent, VerifySignUpState> {
//   final AuthRepository authRepo;
//   final AuthCredentials authCredentials;
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//
//   VerifySignUpBloc({this.authCredentials, this.authRepo})
//       : super(VerifySignUpState());
//
//   @override
//   Stream<VerifySignUpState> mapEventToState(VerifySignUpEvent event) async* {
//     if (event is VerifySignUpOtpChanged) {
//       yield state.copyWith(otp: event.otp);
//     } else if (event is VerifySignUpSubmitted) {
//       yield state.copyWith(formStatus: FormSubmitting());
//       print('verify otp ${state.otp} ${authCredentials.generatedOTP}');
//       if (state.otp == authCredentials.generatedOTP) {
//         try {
//           AuthCredentials signupCredentials= await authRepo.signUp(
//               username: authCredentials.userName,
//               password: authCredentials.password,
//               phoneNumber: authCredentials.phoneNumber);
//           await firebaseAuth.signInWithCustomToken(signupCredentials.firebaseToken);
//
//           yield state.copyWith(formStatus: SubmissionSuccess());
//
//           AppData appData=AppData();
//           appData.setUserDetails();
//
//         } catch (e) {
//           yield state.copyWith(formStatus: SubmissionFailed(e));
//           yield state.copyWith(formStatus: InitialFormStatus());
//
//         }
//       } else {
//         Exception exception = Exception(['OTP does not match']);
//         yield state.copyWith(formStatus: SubmissionFailed(exception));
//         yield state.copyWith(formStatus: InitialFormStatus());
//       }
//     }
//   }
// }
