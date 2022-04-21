import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/authentication/splash_screen/session_cubit.dart';
import 'package:queschat/authentication/splash_screen/session_state.dart';
import 'package:queschat/function/show_snack_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int length = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }



  void requestPermissions() async {

    if (await Permission.contacts.isGranted) {
      context.read<SessionCubit>().attemptAutoLogin();

    } else {
      await Future.delayed(Duration(seconds: 2));

      await [Permission.contacts].request();
      context.read<SessionCubit>().attemptAutoLogin();


    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) async {
        // await Future.delayed(Duration(seconds: 3));
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is Unauthenticated) {
          if (state.e != null) {
            showSnackBar(context, state.e);
          }
          Navigator.pushReplacementNamed(context, '/otpLogin');
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset('images/logo_with_name.png',
              width: MediaQuery.of(context).size.width * .6,
              fit: BoxFit.contain),
        ),
      ),
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
