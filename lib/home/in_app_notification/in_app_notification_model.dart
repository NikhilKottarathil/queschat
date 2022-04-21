
class InAppNotificationModel{

  List<String> userIds, userNames,userProfilePics;
  String id,connectionId,connectionType,associateId,associateType;
  DateTime createdTime;


  InAppNotificationModel({this.userNames, this.userProfilePics, this.userIds, this.id,
      this.connectionId,this.connectionType, this.associateId, this.createdTime,this.associateType});
}