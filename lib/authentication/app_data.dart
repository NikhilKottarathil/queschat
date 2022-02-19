import 'package:firebase_database/firebase_database.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/constants/strings_and_urls.dart';

class AppDataModel {
  String userName;
  String phoneNumber;
  String password;
  String token;
  String profilePic;
  String userId;

  AppDataModel(
      {this.userName,
      this.phoneNumber,
      this.password,
        this.userId,
      this.token,
      this.profilePic});
}

AppDataModel appDataModel = AppDataModel();

AuthRepository authRepositoryTemp = AuthRepository();

class AppData {
  String userName;
  String phoneNumber;
  String password;
  String token;
  String userId;
  String profilePic;
  AppData(){
    userName=appDataModel.userName;
    phoneNumber=appDataModel.phoneNumber;
    profilePic=appDataModel.profilePic;
    userId=appDataModel.userId;
    // userId='21082700001';
  }
  Future<void> setUserDetails() async {
    var user = await authRepositoryTemp.getUserDetails();
    appDataModel.userName = user['name'] != null ? user['name'] : '';
    appDataModel.phoneNumber = user['mobile'] != null ? user['mobile'] : '';
    appDataModel.userId = user['id'] != null ? user['id'].toString() : '';
    appDataModel.profilePic = user['profile_pic']['url'] != null
        ? 'https://api.queschat.com/' + user['profile_pic']['url']
        : Urls().personUrl;

  }
  Future<void> clearAllData() async {
    // appDataModel.isUser = false;
    appDataModel.userName = 'Guest';
    appDataModel.phoneNumber = '0123456789';
    appDataModel.userId = null;

    appDataModel.profilePic = null;
  }

}

List<String>activeMessageRoomIds=[];

addActiveMessageRoom(String messageRoomId){
  if(!activeMessageRoomIds.contains(messageRoomId)){
    activeMessageRoomIds.add(messageRoomId);
  }
}
removeActiveMessageRoom(String messageRoomId){
  if(activeMessageRoomIds.contains(messageRoomId)){
    activeMessageRoomIds.remove(messageRoomId);
  }
}


