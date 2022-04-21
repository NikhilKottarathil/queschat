import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/router/app_router.dart';

void deleteFeedAndRemoveAll(String feedId){
  feedRepository.deleteFeed(feedId: feedId);
  if (homeFeedBloc.state.feedIds.contains(feedId)) {
    homeFeedBloc.add(DeleteFeed(feedId: feedId));
  }
  if (savedFeedBloc.state.feedIds.contains(feedId)) {
    savedFeedBloc.add(DeleteFeed(feedId: feedId));
  }
  if (myFeedsBloc.state.feedIds.contains(feedId)) {
    myFeedsBloc.add(DeleteFeed(feedId: feedId));
  }
}
void updateFeedInAll(String feedId){
  if (homeFeedBloc.state.feedIds.contains(feedId)) {
    homeFeedBloc.add(EditedAFeed(feedId: feedId));
  }
  if (savedFeedBloc.state.feedIds.contains(feedId)) {
    savedFeedBloc.add(EditedAFeed(feedId: feedId));
  }
  if (myFeedsBloc.state.feedIds.contains(feedId)) {
    myFeedsBloc.add(EditedAFeed(feedId: feedId));
  }
}