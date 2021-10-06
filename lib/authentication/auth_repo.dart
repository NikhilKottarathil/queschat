import 'dart:io';

import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<String> attemptAutoLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null) {
      String token = sharedPreferences.getString('token');
      dynamic myBody = {
        'token': token,
      };
      print(token);
      var body = await postDataRequest(address: 'check/token', myBody: myBody);
      if (body['message'] == 'Token Valid') {
        AppData appData=AppData();
        await appData.setUserDetails();
        return token;
      } else {
        throw Exception('No authentication permission');
      }
    } else {
      throw Exception('not authenticated');
    }
  }

  Future<String> login({String phoneNumber, password}) async {
    dynamic myBody = {'mobile': phoneNumber, 'password': password};
    var body = await postDataRequest(address: 'user/login', myBody: myBody);
    if (body['token'] != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', body['token']);
      return body['token'];
    } else {
      if (body['message'] != null) {
        throw Exception(body['message']);
      } else {
        throw Exception('Login Failed');
      }
    }
  }

  Future<String> getSignUpOTP({phoneNumber}) async {
    try {
      dynamic myBody = {
        'mobile': phoneNumber,
      };
      print(myBody);
      var body =
          await postDataRequest(address: 'register/getOtp', myBody: myBody);
      if (body['otp'] != null) {
        return body['otp'];
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw Exception('Please retry');
        }
      }
    } catch (e) {
      throw Exception('Please retry');
    }
  }

  Future<String> signUp({String username, phoneNumber, password}) async {
    dynamic myBody = {
      'name': username,
      'mobile': phoneNumber,
      'password': password
    };
    var body = await postDataRequest(address: 'user/signup', myBody: myBody);
    if (body['token'] != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', body['token']);
      return body['token'];
    } else {
      if (body['message'] != null) {
        throw Exception(body['message']);
      } else {
        throw Exception('Sign retry');
      }
    }
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      await sharedPreferences.clear();
    } catch (e) {
      throw Exception('Some error occurred');
    }
  }

  Future<List> getForgotPasswordOTP({String phoneNumber}) async {
    try {
      dynamic myBody = {
        'mobile': phoneNumber,
      };
      print(myBody);
      var body = await postDataRequest(
          address: 'user/reset/password/otp', myBody: myBody);
      if (body['otp'] != null) {
        return [body['otp'], body['token']];
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw Exception('Please retry');
        }
      }
    } catch (e) {
      throw Exception('Please retry');
    }
  }

  Future<void> changePassword({String password, token}) async {
    try {
      dynamic myBody = {'password': password, 'token': token};
      print(myBody);
      var body =
          await postDataRequest(address: 'user/reset/password', myBody: myBody);
      if (body['message'] == 'Password Successfully Changed !!') {
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw Exception('Please retry');
        }
      }
    } catch (e) {
      throw Exception('Please retry');
    }
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      var body = await getDataRequest(address: 'user/profile');
      if (body['User'] != null) {
        return body['User'];
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw Exception('Please retry');
        }
      }
    } catch (e) {
      throw Exception('Please retry');
    }
  }

  Future<void> editProfile({String userName, phoneNumber,bio}) async {
    try {
      var myBody = {'name': userName, 'mobile': phoneNumber};
      if(bio!=null && bio.toString().trim().length!=0){
        dynamic bioBody={'about_me':bio};
        myBody.addAll(bioBody);
      }
      print(myBody);
      var body =
          await patchDataRequest(address: 'user/profile', myBody: myBody);
      if (body['message'] == 'Successfully Updated') {
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw Exception('Please retry');
        }
      }
    } catch (e) {
      throw Exception('Please retry');
    }
  }

  Future<void> changeProfilePicture({File imageFile}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    Map<String, String> headers = {};
    headers['x-access-token'] = token;
    String url = "https://api.queschat.com/api/user/profile";

    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.headers.addAll(headers);
    if (imageFile != null) {
      request.files.add(http.MultipartFile('profile_pic',
          imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
          filename: imageFile.path.split("/").last));
    }
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.statusCode}");
    print("Result: ${response.body}");
    var body = json.decode(response.body);
  }
// Future<void> changeProfilePicture({File imageFile})async{
//   print(imageFile);
//   try {
//     Map<String,String> myBody = {
//     };
//     print(myBody);
//     var body = await postImageDataRequest(address: 'user/profile', myBody: myBody,imageFile: imageFile,imageAddress: 'profile_pic');
//     if (body['message'] =='Successfully Updated !!') {
//     } else {
//       if (body['message'] != null) {
//         throw Exception(body['message']);
//       } else {
//         throw Exception('Please retry');
//       }
//     }
//     return null;
//   } catch (e) {
//     print(e);
//     throw Exception('Please retry');
//   }
// }
}
