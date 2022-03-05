import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/feeds/feed_adpater.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/router/app_router.dart';

class FeedMessageView extends StatelessWidget {
  MessageModel messageModel;
  FeedsBloc fedBloc;

  FeedMessageView({
    Key key,
    this.messageModel,
  }) {
    fedBloc = FeedsBloc(
        feedRepository: feedRepository,
        parentPage: 'messageRoomView',
        feedId: messageModel.feedId);
  }

  @override
  Widget build(BuildContext context) {
    print('feedMessageView ${messageModel.feedId}');

    // Text('${messageModel.feedId} ${fedBloc.state.feedModelList.length} ${fedBloc.feedId} '),


    return BlocProvider(
          create: (BuildContext context) => fedBloc,


          child: FeedAdapter(0, 'messageRoom'),
          // child: Text(messageModel.feedId),
        );
  }
}
