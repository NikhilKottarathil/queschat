import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/bloc/session_cubit.dart';

enum AuthState { login, signUp, verifySignUp }

class AuthCubit extends Cubit<AuthState> {
  SessionCubit sessionCubit;

  AuthCubit({this.sessionCubit}) : super(AuthState.login);

  AuthCredentials authCredentials;

  void showLogin() => emit(AuthState.login);

  void showSignUp() => emit(AuthState.signUp);

  void showVerifySignUp(
      {String userName, String phoneNumber, String password,String verifyOTP}) {
    authCredentials = AuthCredentials(
      userName: userName,
      phoneNumber: phoneNumber,
      password: password,
      verifyOTP: verifyOTP
    );
    emit(AuthState.verifySignUp);
  }

  void showSession(AuthCredentials credentials) {
    sessionCubit.showSession(credentials);
  }
}
