import 'package:queschat/home/feeds/comment/comment_model.dart';
import 'package:queschat/home/feeds/feeds_status.dart';


class CommentState {
  List<CommentModel> commentModelList=[];
  PageScrollStatus pageScrollStatus;
  int page;
  int indexOfSelectedComment;
  int indexOfSelectedCommentForDelete;
  int indexOfSelectedCReplayForDelete;
  List<String> commentIds=[];
  bool isLoading;
  bool isShowDeleteAndReportAlert;
  String comment;
  String get commentValidationText {
    if (comment.trim().length == 0) {
      return 'Please enter comment';
    } else {
      return null;
    }
  }


  CommentState({
    this.comment,
    this.commentModelList,
    this.indexOfSelectedCommentForDelete,
    this.indexOfSelectedCReplayForDelete,
    this.indexOfSelectedComment,
    this.pageScrollStatus=const InitialStatus(),
    this.commentIds,
    this.isShowDeleteAndReportAlert=false,
    this.page=1,
    this.isLoading=false
  });

  CommentState copyWith({
    var commentModelList,
    var commentIds,
    bool isLoading,
    bool isShowDeleteAndReportAlert,
    String comment,
    int indexOfSelectedComment,
    int indexOfSelectedCommentForDelete,
    int indexOfSelectedCReplayForDelete,
    PageScrollStatus pageScrollStatus,
    int page,
  }) {
    return CommentState(
      comment: comment ?? this.comment,
      commentModelList: commentModelList ?? this.commentModelList,
      commentIds: commentIds ?? this.commentIds,
      pageScrollStatus: pageScrollStatus ?? this.pageScrollStatus,
      isLoading: isLoading ?? this.isLoading,
      isShowDeleteAndReportAlert: isShowDeleteAndReportAlert ?? this.isShowDeleteAndReportAlert,
      indexOfSelectedComment: indexOfSelectedComment ?? this.indexOfSelectedComment,
      indexOfSelectedCommentForDelete: indexOfSelectedCommentForDelete ?? this.indexOfSelectedCommentForDelete,
      indexOfSelectedCReplayForDelete: indexOfSelectedCReplayForDelete ?? this.indexOfSelectedCReplayForDelete,
      page: page ?? this.page,
    );
  }
}
