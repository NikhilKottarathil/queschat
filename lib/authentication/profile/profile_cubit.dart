//
//
// enum ProfileState { profile, resetPassword, editProfile }
//
// class AuthCubit extends Cubit<ProfileState> {
//   SessionCubit sessionCubit;
//
//   AuthCubit({this.sessionCubit}) : super(ProfileState.login);
//
//   AuthCredentials authCredentials;
//
//   void showLogin() => emit(ProfileState.login);
//   void showForgotPassword() => emit(ProfileState.forgotPassword);
//
//   void showSignUp() => emit(ProfileState.signUp);
//
//   void showVerifySignUp(
//       {String userName, String phoneNumber, String password,String verifyOTP}) {
//     authCredentials = AuthCredentials(
//         userName: userName,
//         phoneNumber: phoneNumber,
//         password: password,
//         verifyOTP: verifyOTP
//     );
//     emit(ProfileState.verifySignUp);
//   }
//
//   void showSession(AuthCredentials credentials) {
//     sessionCubit.showSession(credentials);
//   }
// }
