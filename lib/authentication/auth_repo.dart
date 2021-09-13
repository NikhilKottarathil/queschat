import 'package:queschat/authentication/api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<String> attemptAutoLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null) {
      String token = sharedPreferences.getString('token');
      dynamic myBody = {
        'token': token,
      };
      var body = await postDataRequest(address: 'check/token', myBody: myBody);
      if (body['message'] == 'Token Valid') {
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
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
      print('p1');
      if (body['otp'] != null) {
        print('p2');

        return body['otp'];
      } else {
        print('p3');

        if (body['message'] != null) {
          print('p4');

          throw Exception(body['message']);
        } else {
          print('p5');

          throw Exception('Please retry');
        }
      }
    }catch (e){
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
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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

  Future<void> signOut() async {}
}
