import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_view.dart';
import 'package:queschat/authentication/login/login_view.dart';
import 'package:queschat/authentication/sign_up/sign_up_view.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_view.dart';

class AuthNavigator extends StatelessWidget {
  final _navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Navigator(
            key: _navigationKey,
            pages: [
              // Show login
              if (state == AuthState.login) MaterialPage(child: LoginView()),
              if (state == AuthState.forgotPassword)
                MaterialPage(
                    child: BlocProvider(
                        create: (context) => ForgotPasswordBloc(
                              authRepo: context.read<AuthRepository>(),
                              authCubit: context.read<AuthCubit>(),
                            ),
                        child: ForgotPasswordView())),

              // Allow push animation
              if (state == AuthState.signUp ||
                  state == AuthState.verifySignUp) ...[
                // Show Sign

                MaterialPage(child: SignUpView()),
                // Show confirm sign up
                if (state == AuthState.verifySignUp)
                  MaterialPage(child: VerifySignUpView())
              ]
            ],
            onPopPage: (route, result) {
              print(result);
              print(route);
              return route.didPop(result);
            });
      },
    );
  }
}

// onWillPop: () async {
//   print('calleddddd');
//   // return await _navigationKey.currentState.maybePop();
//   if (_navigationKey.currentState.canPop()) {
//     _navigationKey.currentState.maybePop();
//     return  false;
//   }else{
//     return true;
//   }
// },