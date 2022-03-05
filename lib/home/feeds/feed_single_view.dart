import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/feed_adpater.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_bloc.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';

class FeedSingleView extends StatelessWidget {
String feedId;
String parentPage;
FeedSingleView({Key key,this.feedId,this.parentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('feedSingleView ${feedId} $parentPage');
    return Scaffold(

      appBar: appBarWithBackButton(context: context,titleString: 'Post'),
      body: BlocProvider(

        create: (BuildContext context) =>
            FeedsBloc(feedRepository: feedRepository, parentPage: parentPage,feedId: feedId),

        // providers: [
        //   // BlocProvider.value(value: context.read<HomeBloc>()),
        //   BlocProvider<FeedsBloc>(
        //     create: (BuildContext context) =>
        //         FeedsBloc(feedRepository: feedRepository, parentPage: 'messageRoomView',feedId: messageModel.feedId),
        //   ),
        //   BlocProvider<PostMcqBloc>(
        //     create: (BuildContext context) =>
        //         PostMcqBloc(feedRepo: feedRepository),
        //   ),
        //   BlocProvider<PostQuizBloc>(
        //     create: (BuildContext context) =>
        //         PostQuizBloc(feedRepo: feedRepository),
        //   ),
        //   BlocProvider<PostBlogBloc>(
        //     create: (BuildContext context) =>
        //         PostBlogBloc(feedRepo: feedRepository, parentPage: 'home'),
        //   ),
        // ],
        child: ListView(
          children: [
            FeedAdapter(0,'singleView'),
          ],
        ),
        // child: Text(messageModel.feedId),
      ),
    );
  }
}
