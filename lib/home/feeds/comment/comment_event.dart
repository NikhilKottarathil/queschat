class CommentEvent {}

class FetchInitialData extends CommentEvent {}

class FetchMoreData extends CommentEvent {}

class CommentSelectedForReplay extends CommentEvent {
  int index;

  CommentSelectedForReplay({this.index});
}

class ShowDeleteAndReport extends CommentEvent {
  int commentIndex, replayIndex;

  ShowDeleteAndReport({this.commentIndex, this.replayIndex});
}

class ConfirmDelete extends CommentEvent {}


class AddNewComment extends CommentEvent {}

class CommentChanged extends CommentEvent {
  String comment;

  CommentChanged({this.comment});
}

class LikeAndUnLikeComment extends CommentEvent {
  int index;

  LikeAndUnLikeComment({this.index});
}

class ShowAndHideReplays extends CommentEvent {
  int index;

  ShowAndHideReplays({this.index});
}

class ReplayToComment extends CommentEvent {
  int index;
  String replay;

  ReplayToComment({this.index, this.replay});
}
