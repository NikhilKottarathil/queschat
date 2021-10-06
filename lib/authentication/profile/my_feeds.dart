import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_view.dart';
import 'package:queschat/uicomponents/appbars.dart';
class MyFeeds extends StatelessWidget {
  FeedRepository feedRepository=FeedRepository();

  MyFeeds({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context: context,titleString: 'My Feeds'),
      body: BlocProvider(
        create: (context)=>FeedsBloc(parentPage: 'myFeeds',feedRepository: feedRepository),
        child: FeedsView(),
      ),
    );
  }
}
