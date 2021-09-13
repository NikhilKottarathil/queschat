



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/login/login_view.dart';
import 'package:queschat/authentication/sign_up/sign_up_view.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_view.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show login
          if (state == AuthState.login) MaterialPage(child: LoginView()),

          // Allow push animation
          if (state == AuthState.signUp ||
              state == AuthState.verifySignUp) ...[
            // Show Sign up
            MaterialPage(child: SignUpView()),

            // Show confirm sign up
            if (state == AuthState.verifySignUp)
              MaterialPage(child: VerifySignUpView())
          ]
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    },
    );
  }
}

