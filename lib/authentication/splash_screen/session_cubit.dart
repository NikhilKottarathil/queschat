import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/splash_screen/session_state.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/router/app_router.dart';

class SessionCubit extends Cubit<SessionState> {
  AuthRepository authRepo;

  SessionCubit({this.authRepo}) : super(UnKnownSessionState()) ;


  void attemptAutoLogin() async {
    try {
      final token = await authRepo.attemptAutoLogin();
      AppData appData = AppData();
      appData.setUserDetails();
      await setRepositoryAndBloc();
      emit(Authenticated(token: token));

    } catch (e) {

      emit(Unauthenticated(e: e));
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
