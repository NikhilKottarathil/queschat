import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';

class SavedFeeds extends StatefulWidget {
  SavedFeeds({Key key}) : super(key: key);

  @override
  State<SavedFeeds> createState() => _SavedFeedsState();
}

class _SavedFeedsState extends State<SavedFeeds> {
  FeedRepository feedRepository = FeedRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBarWithBackButton(context: context, titleString: 'Saved Feeds'),
      body: BlocProvider(
        create: (context) =>savedFeedBloc,
        child: FeedsView(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {});
      //   },
      // ),
    );
  }
}
