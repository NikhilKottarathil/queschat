import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_navigator.dart';
import 'package:queschat/bloc/session_state.dart';
import 'package:queschat/components/app_exit_alert.dart';
import 'package:queschat/home/home_bloc.dart';
import 'package:queschat/home/home_navigator.dart';
import 'package:queschat/loading_view.dart';
import 'package:queschat/pages/homepage.dart';

import 'bloc/session_cubit.dart';

class AppNavigator extends StatelessWidget {
  final _navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            print('called parernt');

            return appExitAlert(context);
          },
          child: Navigator(
            key: _navigationKey,
            pages: [
              //show  Loading Screen
              if (state is UnKnownSessionState)
                MaterialPage(child: LoadingView()),
              //show  Auth Flow
              if (state is Unauthenticated)
                MaterialPage(
                  child: BlocProvider(
                    create: (context) =>
                        AuthCubit(sessionCubit: context.read<SessionCubit>()),
                    child: AuthNavigator(),
                  ),
                ),

              // Show Session View
              if (state is Authenticated)
                MaterialPage(
                    child: BlocProvider(
                  child: HomeNavigator(),
                  create: (context) => HomeBloc(),
                )),
            ],
            onPopPage: (route, result) => route.didPop(result),
          ),
        );
      },
    );
  }
}
