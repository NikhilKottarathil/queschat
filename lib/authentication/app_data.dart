import 'package:queschat/authentication/auth_repo.dart';
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

AuthRepository authRepository = AuthRepository();

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
  }
  Future<void> setUserDetails() async {
    var user = await authRepository.getUserDetails();
    appDataModel.userName = user['name'] != null ? user['name'] : '';
    appDataModel.phoneNumber = user['mobile'] != null ? user['mobile'] : '';
    appDataModel.userId = user['id'] != null ? user['id'].toString() : '';
    appDataModel.profilePic = user['profile_pic']['url'] != null
        ? 'https://api.queschat.com/' + user['profile_pic']['url']
        : Urls().personUrl;
  }
}
