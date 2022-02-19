class FeedEvent {}

class FetchInitialData extends FeedEvent {}


class UpdateFeeds extends FeedEvent {}

class RefreshFeeds extends FeedEvent {}

class FetchMoreData extends FeedEvent {}

class UserAddedNewFeed extends FeedEvent {
  String id;
  UserAddedNewFeed({this.id});
}

class McqAnswered extends FeedEvent {
  int feedIndex;
  String option;
  String answer;

  McqAnswered({this.feedIndex, this.option,this.answer});
}
class LikeAndUnLikeFeed extends FeedEvent {
  int feedIndex;

  LikeAndUnLikeFeed({this.feedIndex});
}class EditedAFeed extends FeedEvent {
  String feedId;

  EditedAFeed({this.feedId});
}class DeleteFeed extends FeedEvent {
  String  feedId;

  DeleteFeed({this.feedId});
}class SaveAndUnSaveFeed extends FeedEvent {
  int feedIndex;

  SaveAndUnSaveFeed({this.feedIndex});
}
class CommentFeed extends FeedEvent {
  int feedIndex;
  String option;

  CommentFeed({this.feedIndex, this.option});
}



