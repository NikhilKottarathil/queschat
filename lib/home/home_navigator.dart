import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_bloc.dart';
import 'package:queschat/home/home_bloc.dart';
import 'package:queschat/home/home_state.dart';
import 'package:queschat/home/home_status.dart';
import 'package:queschat/home/home_view.dart';
import 'package:queschat/pages/new_message.dart';

class HomeNavigator extends StatelessWidget {
  final _navigationKey = GlobalKey<NavigatorState>();
  FeedRepository feedRepository = FeedRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Navigator(
          key: _navigationKey,
          pages: [
            if (state.homeStatus is InitialStatus ||
                state.homeStatus is NotificationStatus ||
                state.homeStatus is NewMessageStatus) ...[
              MaterialPage(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<HomeBloc>()),
                    BlocProvider<FeedsBloc>(
                      create: (BuildContext context) => FeedsBloc(
                          feedRepository: feedRepository, parentPage: 'home'),
                    ),
                    BlocProvider<PostMcqBloc>(
                      create: (BuildContext context) =>
                          PostMcqBloc(feedRepo: feedRepository),
                    ), BlocProvider<PostQuizBloc>(
                      create: (BuildContext context) =>
                          PostQuizBloc(feedRepo: feedRepository),
                    ),
                    BlocProvider<PostBlogBloc>(
                      create: (BuildContext context) => PostBlogBloc(
                          feedRepo: feedRepository, parentPage: 'home'),
                    ),
                  ],
                  child: HomeView(),
                ),
              ),
              if (state.homeStatus is NewMessageStatus)
                MaterialPage(child: NewMessage()),
            ]
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}
