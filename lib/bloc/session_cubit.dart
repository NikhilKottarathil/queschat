import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/bloc/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  AuthRepository authRepo;

  SessionCubit({this.authRepo}) : super(UnKnownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final token = await authRepo.attemptAutoLogin();
      emit(Authenticated(token: token));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) {
    final token = credentials.token;
    emit(Authenticated(token: token));
  }

  void logOut() {
    authRepo.logOut();
    emit(Unauthenticated());
  }
}
