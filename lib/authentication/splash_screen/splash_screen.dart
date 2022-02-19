import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/splash_screen/session_cubit.dart';
import 'package:queschat/authentication/splash_screen/session_state.dart';
import 'package:queschat/authentication/splash_screen/session_state.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_view.dart';
import 'package:queschat/authentication/login/login_bloc.dart';
import 'package:queschat/authentication/login/login_view.dart';
import 'package:queschat/authentication/sign_up/sign_up_view.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_view.dart';
import 'package:queschat/components/app_exit_alert.dart';

class SplashScreen extends StatelessWidget {

  int length = 1;

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) async{
        // await Future.delayed(Duration(seconds: 3));
        if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');

        } else if (state is Unauthenticated) {
          if(state.e!=null){
            showSnackBar(context, state.e);
          }
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Container(
        color: AppColors.PrimaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   // 'assets/app_logo.png',
              //   fit: BoxFit.cover,
              //   height: height * .08,
              // ),
              SizedBox(
                height: height * .08,
              )
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Future<bool> popRoute() {
  //   if (_pages.length > 1) {
  //     _pages.removeLast();
  //     notifyListeners();
  //     return Future.value(true);
  //   }
  //   return _confirmAppExit();
  // }
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
