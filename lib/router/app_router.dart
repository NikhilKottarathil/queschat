import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_view.dart';
import 'package:queschat/authentication/login/login_bloc.dart';
import 'package:queschat/authentication/login/login_view.dart';
import 'package:queschat/authentication/otp_login/otp_login_bloc.dart';
import 'package:queschat/authentication/otp_login/otp_login_view.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';
import 'package:queschat/authentication/profile/profile_view.dart';
import 'package:queschat/authentication/reset_password/reset_password_bloc.dart';
import 'package:queschat/authentication/reset_password/reset_password_view.dart';
import 'package:queschat/authentication/sign_up/sign_up_bloc.dart';
import 'package:queschat/authentication/sign_up/sign_up_view.dart';
import 'package:queschat/authentication/splash_screen/session_cubit.dart';
import 'package:queschat/authentication/splash_screen/splash_screen.dart';
import 'package:queschat/authentication/user_profile/user_profile_bloc.dart';
import 'package:queschat/authentication/user_profile/user_profile_view.dart';
import 'package:queschat/home/feeds/feed_single_view.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_cubit.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_view.dart';
import 'package:queschat/home/home/home_bloc.dart';
import 'package:queschat/home/home/home_view_2.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_cubit.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_view.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_view.dart';
import 'package:queschat/home/message/message_room_list/expore_channels_views.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_bloc.dart';
import 'package:queschat/repository/auth_repo.dart';


AuthRepository authRepository = AuthRepository();
FeedRepository feedRepository = FeedRepository();
HomeBloc homeBloc;

MessageRoomListBloc allChatMessageRoomListBloc;

MessageRoomListBloc channelMessageRoomListBloc;

FeedsBloc homeFeedBloc;
FeedsBloc myFeedsBloc;
FeedsBloc savedFeedBloc;

ProfileBloc profileBloc;

InAppNotificationCubit inAppNotificationCubit;

Future<void> setRepositoryAndBloc() async {
  await authRepository.initRepository();
  allChatMessageRoomListBloc = MessageRoomListBloc(parentPage: 'allChat');
  channelMessageRoomListBloc = MessageRoomListBloc(parentPage: 'channel');
  await allChatMessageRoomListBloc.initMessageRoomList();
  await channelMessageRoomListBloc.initMessageRoomList();

  homeFeedBloc =
      FeedsBloc(feedRepository: feedRepository, parentPage: 'home');
  homeBloc = HomeBloc();
  myFeedsBloc =
      FeedsBloc(feedRepository: feedRepository, parentPage: 'myFeeds');
  savedFeedBloc =
      FeedsBloc(feedRepository: feedRepository, parentPage: 'savedFeeds');
  inAppNotificationCubit = InAppNotificationCubit();
  profileBloc = ProfileBloc(authRepo: authRepository);
}

Future<void> resetRepositoryAndBloc() async {
  await authRepository.initRepository();
  profileBloc = ProfileBloc(authRepo: authRepository);

  allChatMessageRoomListBloc = MessageRoomListBloc(parentPage: 'allChat');
  channelMessageRoomListBloc = MessageRoomListBloc(parentPage: 'channel');
}

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    // final GlobalKey<ScaffoldState> key = settings.arguments;
    Map arguments = settings.arguments;

    switch (settings.name) {
      //auth
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SessionCubit(authRepo: authRepository),
            child: SplashScreen(),
          ),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginBloc(authRepo: authRepository),
            child: LoginView(),
          ),
        );

      case '/otpLogin':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => OTPLoginBloc(authRepo: authRepository),
            child: OTPLoginView(),
          ),
        );

      case '/signUp':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SignUpBloc(authRepo: authRepository,phoneNumber:  arguments['phoneNumber']),
            child: SignUpView(),
          ),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileView(),
        );

      case '/userProfile':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UserProfileBloc(userId: arguments['userId']),
            child: UserProfileView(),
          ),
        );
        case '/forgotPassword':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgotPasswordBloc(authRepo: authRepository),
            child: ForgotPasswordView(),
          ),
        );
      case '/resetPassword':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ResetPasswordBloc(authRepo: authRepository),
            child: ResetPasswordView(),
          ),
        );
      case '/messageRoom':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            child: MessageRoomView(),
            create: (_) => MessageRoomCubit(
                parentPage: arguments['parentPage'],
                chatRoomModel: arguments['chatRoomModel']),
          ),
        );
      case '/exploreChannels':
        return MaterialPageRoute(builder: (_) {
          MessageRoomListBloc messageRoomListBloc =
              MessageRoomListBloc(parentPage: 'exploreChannel');
          messageRoomListBloc.initMessageRoomList();
          return BlocProvider(
            create: (context) => messageRoomListBloc,
            child: ExploreChannelsView(),
          );
        });
      case '/feedSingleView':
        return MaterialPageRoute(
          builder: (_) => FeedSingleView(
              parentPage: arguments['parentPage'],parentFeedBloc: arguments['parentFeedBloc'], feedId: arguments['feedId']),
        );
      case '/leaderBoard':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LeaderBoardCubit(quizId: arguments['quizId']),
            child: LeaderBoardView(),
          ),
        );
      case '/inAppNotifications':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => inAppNotificationCubit,
            child: InAppNotificationView(),
          ),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => homeBloc,
            child: HomeView2(),
          ),
        );



      default:
        return null;
    }
  }
}
