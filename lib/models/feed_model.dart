class FeedModel {
  String userName,
      userId,
      profilePicUrl,
      uploadedTime,
      likeCount,
      commentCount,
      feedType,
      id;
  bool isLiked = false;
  String savedId;
  String likeId;
  var contentModel;
  String messageRoomId;
  String messageRoomName;
  String messageRoomImageUrl;

  FeedModel(
      {this.userName,
      this.messageRoomId,
      this.savedId,
      this.userId,
      this.profilePicUrl,
      this.uploadedTime,
      this.likeCount,
      this.commentCount,
      this.feedType,
      this.likeId,
      this.id,
      this.contentModel,
      this.isLiked = false,this.messageRoomName,this.messageRoomImageUrl});
}
