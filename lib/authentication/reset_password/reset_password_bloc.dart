import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/reset_password/reset_password_event.dart';
import 'package:queschat/authentication/reset_password/reset_password_state.dart';
import 'package:queschat/authentication/reset_password/reset_password_status.dart';
import 'package:queschat/repository/auth_repo.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository authRepo;

  String verificationID;
  int resendToken;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ResetPasswordBloc({this.authRepo}) : super(ResetPasswordState());

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is ForgotPhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);
    } else if (event is ForgotOTPChanged) {
      yield state.copyWith(otp: event.otp);
    } else if (event is ResetPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is ButtonSubmitted) {
      if (state.formStatus is InitialStatus) {
        yield state.copyWith(formStatus: MobileNumberSubmitting());

        try {

          final data =
          await authRepo.getForgotPasswordOTP(phoneNumber: state.phoneNumber);

          final verifyOtp = data[0];
          final tempToken = data[1];
          yield state.copyWith(verifyOtp: verifyOtp.toString(), tempToken: tempToken);
                add(OTPRequestSubmitted());

          // await firebaseAuth.verifyPhoneNumber(
          //     timeout: Duration(seconds: 60),
          //     phoneNumber: '+91' + state.phoneNumber,
          //     verificationCompleted: (verificationCompleted) async {},
          //     verificationFailed: (verificationFailed) async {},
          //     codeSent: (verificationId, resendingToken) async {
          //       verificationID = verificationId;
          //       resendToken = resendingToken;
          //       add(OTPRequestSubmitted());
          //     },
          //     codeAutoRetrievalTimeout: (verificationId) {});
        } on FirebaseAuthException catch (e) {
          yield state.copyWith(formStatus: MobileNumberSubmitFailed(e));
          yield state.copyWith(formStatus: InitialStatus());
        }
      } else if (state.formStatus is MobileNumberSubmittedSuccessfully) {
        yield state.copyWith(formStatus: OTPSubmitting());

        if(state.otp==state.verifyOtp) {

          yield state.copyWith(formStatus: OTPSubmittedSuccessfully());
        } else{
          Exception e = new Exception(['Please enter valid OTP']);
          yield state.copyWith(formStatus: OTPSubmitFailed(e));
          yield state.copyWith(formStatus: MobileNumberSubmittedSuccessfully());
        }
        // try {
        //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //       verificationId: verificationID, smsCode: state.otp);
        //   await firebaseAuth.signInWithCredential(credential);
        //   await firebaseAuth.signOut();
        //   yield state.copyWith(formStatus: OTPSubmittedSuccessfully());
        // } catch (e) {
        //   Exception e = new Exception(['Please enter valid OTP']);
        //   yield state.copyWith(formStatus: OTPSubmitFailed(e));
        //   yield state.copyWith(formStatus: MobileNumberSubmittedSuccessfully());
        // }
      }
      else if (state.formStatus is OTPSubmittedSuccessfully) {
        yield state.copyWith(formStatus: NewPasswordSubmitting());
        try {
          await authRepo.changePassword(
              password: state.password,
              token: state.tempToken);

          yield state.copyWith(formStatus: NewPasswordSubmittedSuccessfully());
        } catch (e) {
          yield state.copyWith(formStatus: NewPasswordSubmitFailed(e));
          yield state.copyWith(formStatus: OTPSubmittedSuccessfully());
        }
      }
    }else if (event is ReverseButtonSubmitted) {
        print('reverse buttn submitted');
        if (state.formStatus is MobileNumberSubmittedSuccessfully ||
            state.formStatus is OTPSubmitting ||
            state.formStatus is OTPSubmitFailed) {
          print('reverse buttn submitted 1' );

          yield state.copyWith(otp: '', formStatus: InitialStatus());
        } else if (state.formStatus is OTPSubmittedSuccessfully ||
            state.formStatus is NewPasswordSubmitting ||
            state.formStatus is NewPasswordSubmitFailed) {
          print('reverse buttn submitted 2');

          yield state.copyWith(
              password: '', formStatus: MobileNumberSubmittedSuccessfully());
        }
      }
    else if (event is OTPRequestSubmitted) {
      yield state.copyWith(formStatus: MobileNumberSubmittedSuccessfully());
    }
  }
}
