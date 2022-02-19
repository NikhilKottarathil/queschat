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
import 'package:queschat/home/feeds/feed_single_view.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_view.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_cubit.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_view.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_bloc.dart';
import 'package:queschat/home/home/home_bloc.dart';
import 'package:queschat/home/home/home_view.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_cubit.dart';
import 'package:queschat/home/in_app_notification/in_app_notification_view.dart';
import 'package:queschat/home/message/message_home/message_home_bloc.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_view.dart';
import 'package:queschat/home/message/message_room_list/expore_channels_views.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_bloc.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_view.dart';

import 'package:queschat/repository/auth_repo.dart';

AuthRepository authRepository = AuthRepository();
FeedRepository feedRepository = FeedRepository();

MessageRoomListBloc allChatMessageRoomListBloc =
    MessageRoomListBloc(parentPage: 'allChat');
MessageRoomListBloc channelMessageRoomListBloc =
    MessageRoomListBloc(parentPage: 'channel');
FeedsBloc homeFeedBloc =
    FeedsBloc(feedRepository: feedRepository, parentPage: 'homeView');
FeedsBloc myFeedsBloc =
    FeedsBloc(feedRepository: feedRepository, parentPage: 'myFeeds');
FeedsBloc savedFeedBloc =
    FeedsBloc(feedRepository: feedRepository, parentPage: 'savedFeeds');
ProfileBloc profileBloc = ProfileBloc(authRepo: authRepository);
HomeBloc homeBloc = HomeBloc();

MessageHomeBloc messageHomeBloc = MessageHomeBloc();

InAppNotificationCubit inAppNotificationCubit = InAppNotificationCubit();

void resetRepositoryAndBloc() {
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
            create: (context) => SignUpBloc(authRepo: authRepository),
            child: SignUpView(),
          ),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => profileBloc,
            child: ProfileView(),
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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                MessageRoomListBloc(parentPage: 'exploreChannel'),
            child: ExploreChannelsView(),
          ),
        );
      case '/feedSingleView':
        return MaterialPageRoute(
          builder: (_) => FeedSingleView(
              parentPage: arguments['parentPage'], feedId: arguments['feedId']),
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => homeBloc),
              BlocProvider(
                create: (context) => FeedsBloc(
                    feedRepository: feedRepository, parentPage: 'home'),
              ),
              BlocProvider(
                create: (context) => PostMcqBloc(feedRepo: feedRepository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    PostQuizBloc(feedRepo: feedRepository),
              ),
              BlocProvider(
                create: (context) =>
                    PostBlogBloc(feedRepo: feedRepository, parentPage: 'home'),
              ),
            ],
            child: HomeView(),
          ),
        );

      default:
        return null;
    }
  }
}
