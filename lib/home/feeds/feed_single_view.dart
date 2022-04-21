import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/feed_adpater.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';

class FeedSingleView extends StatelessWidget {
  String feedId;
  String parentPage;
  FeedsBloc parentFeedBloc;

  FeedSingleView({Key key, this.feedId, this.parentPage, this.parentFeedBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('feedSingleView ${feedId} $parentPage ${parentFeedBloc.parentPage}' );
    return Scaffold(
      appBar: appBarWithBackButton(context: context, titleString: 'Post'),
      body: BlocProvider(
        create: (BuildContext context) => FeedsBloc(
            feedRepository: feedRepository,
            parentPage: parentPage,
            feedId: feedId,
            parentFeedBloc: parentFeedBloc),

        child: ListView(
          children: [
            FeedAdapter(0, 'singleView'),
          ],
        ),
        // child: Text(messageModel.feedId),
      ),
    );
  }
}
