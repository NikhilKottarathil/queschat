
class FeedModel{

  String userName,profilePicUrl,uploadedTime,likeCount,commentCount,feedType,id;
  bool isLiked=false;
  String likeId;
  var contentModel;
  FeedModel({this.userName,this.profilePicUrl,this.uploadedTime,this.likeCount,this.commentCount,this.feedType,this.likeId,this.id,this.contentModel,this.isLiked=false});
}