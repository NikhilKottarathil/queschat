import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/app_navigator.dart';
import 'package:queschat/authentication/auth_navigator.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/constants/styles.dart';

import 'authentication/auth_cubit.dart';
import 'bloc/session_cubit.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF144169),
      statusBarIconBrightness: Brightness.light));
  runApp(
    new MaterialApp(
      title: "Queschat",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          fontFamily: 'NunitoSans_Regular',
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.PrimaryColorLight,
              statusBarIconBrightness:Brightness.light,
              statusBarBrightness: Brightness.light,
            )
          ),
          scaffoldBackgroundColor: Color(0xFFFAFAFA)),
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) =>
              SessionCubit(authRepo: context.read<AuthRepository>()),
          child:AppNavigator(),
        ),
      ),
    ),
  );
}
// BlocProvider(
// create: (context) => AuthCubit( sessionCubit: context.read<SessionCubit>()),
// child: AuthNavigator(),
// )