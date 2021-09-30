class CommentModel {
  String userName,
      profilePicUrl,
      uploadedTime,
      likeCount,
      replayCount,
      comment,
  userId,
      id;
  bool isShowReplay;
  bool isLiked = false;
  String likeId;
  List<CommentModel> replays;

  CommentModel(
      {this.userName,
      this.profilePicUrl,
      this.uploadedTime,
      this.likeCount,
      this.isShowReplay,
      this.comment,
      this.replayCount,
      this.likeId,
      this.id,
        this.userId,
      this.replays,
      this.isLiked = false});
}
