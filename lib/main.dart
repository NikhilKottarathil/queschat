import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/app_navigator.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/constants/styles.dart';

import 'bloc/session_cubit.dart';

void main() async {
  runApp(
    new MaterialApp(
      title: "Queschat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NunitoSans_Regular',
          scaffoldBackgroundColor: AppColors.White),
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) =>
              SessionCubit(authRepo: context.read<AuthRepository>()),
          child: AppNavigator(),
        ),
      ),
    ),
  );
}
