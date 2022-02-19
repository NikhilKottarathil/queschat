
class InAppNotificationModel{

  List<String> userIds, userNames,userProfilePics;
  String id,content,connectionId,connectionType,associateId,associateType;
  DateTime createdTime;


  InAppNotificationModel({this.userNames,this.content, this.userProfilePics, this.userIds, this.id,
      this.connectionId,this.connectionType, this.associateId, this.createdTime,this.associateType});
}