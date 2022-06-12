import 'dart:convert';
import 'dart:io';

// import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/awsome_notifications.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  List<Contact> contactsOnPhone = [];
  List<UserContactModel> queschatUsers = [];
  List<String> queschatUsersMobileNumbers = [];
  List<UserContactModel> nonQueschatUsers= [];


  initRepository() async{
    await readContactsFromPhone();
  }

  Future<String> attemptAutoLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null) {
      String token = sharedPreferences.getString('token');
      dynamic myBody = {
        'token': token,
      };
      print(token);
      var body = await postDataRequest(address: 'check/token', myBody: myBody);
      print(body);
      if (body['message'] == 'Token Valid') {
        AppData appData = AppData();
        await appData.setUserDetails();
        return token;
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw Exception('No authentication permission');
        }
      }
    } else {
      throw Exception('Not Authenticated');
    }
  }

  Future<AuthCredentials> login({String phoneNumber, password}) async {
    dynamic myBody = {'mobile': phoneNumber, 'password': password};
    // print(myBody);
    try {
      var body =
          await postDataRequest(address: 'user' + '/login', myBody: myBody);
      if (body['token'] != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('token', body['token'].toString());
        await sharedPreferences.setString(
            'firebase_token', body['firebase_token'].toString());
        return AuthCredentials(
            phoneNumber: phoneNumber,
            generatedOTP: body['otp'].toString(),
            firebaseToken: body['firebase_token'].toString(),
            token: body['token'].toString());
      } else {
        if (body['message'] != null) {
          throw Exception(body['message']);
        } else {
          throw AppExceptions().somethingWentWrong;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<String> getSignUpOTP({phoneNumber}) async {
    try {
      dynamic myBody = {
        'mobile': phoneNumber,
      };
      // print(myBody);
      var body =
          await postDataRequest(address: 'register/getOtp', myBody: myBody);
      // print(body);
      if (body != null) {
        if (body['otp'] != null) {
          return body['otp'].toString();
        } else {
          if (body['message'] != null) {
            throw Exception(body['message']);
          } else {
            throw AppExceptions().somethingWentWrong;
          }
        }
      } else {
        throw AppExceptions().serverException;
      }
    } catch (e) {
      print(e);

      throw e;
    }
  }

  Future<AuthCredentials> signUp(
      {String username, phoneNumber, password}) async {
    dynamic myBody = {
      'name': username,
      'mobile': phoneNumber,
      'password': password
    };
    try {
      var body =
          await postDataRequest(address: 'user' + '/signup', myBody: myBody);
      if (body['token'] != null) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('token', body['token']);
        await sharedPreferences.setString(
            'firebase_token', body['firebase_token']);
        return AuthCredentials(
            phoneNumber: phoneNumber,
            firebaseToken: body['firebase_token'].toString(),
            token: body['token'].toString());
      } else {
        if (body['message'] != null) {
          print('signup else ');

          throw Exception(body['message']);
        } else {
          throw AppExceptions().somethingWentWrong;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<AuthCredentials> loginByOTP({phoneNumber}) async {
    try {
      dynamic myBody = {
        'mobile': phoneNumber,
      };
      print(myBody);
      var body = await postDataRequest(address: 'getOtp', myBody: myBody);
      if (body['otp'] != null) {

        if(body['token']!=null) {
          return AuthCredentials(
              isUser: true,
              phoneNumber: phoneNumber,
              generatedOTP: body['otp'].toString(),
              firebaseToken: body['firebase_token'].toString(),
              token: body['token'].toString());
        }else{
          return AuthCredentials(
              isUser: false,
              phoneNumber: phoneNumber,
              generatedOTP: body['otp'].toString(),);
        }
      } else {
        if (body['message'] != null) {
            throw Exception(body['message']);
        } else {
          throw AppExceptions().somethingWentWrong;
        }
      }
    } catch (e) {
      throw AppExceptions().serverException;
    }
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.clear();
    AppData().clearAllData();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
  }

  Future<List> getForgotPasswordOTP({String phoneNumber}) async {
    try {
      dynamic myBody = {
        'mobile': phoneNumber,
      };
      // print(myBody);
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

  Future<Map<String, dynamic>> getMyDetails() async {
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
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      var body = await getDataRequest(address: 'user/profile/$userId');
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

  Future<void> editProfile(
      {String userName,
      phoneNumber,
      bio,
      deviceToken,

      instagramLink,
      linkedinLink,
      facebookLink,DateTime dob}) async {
    try {
      var myBody = {};
      if (userName != null) myBody.addAll({'name': userName});
      if (phoneNumber != null) myBody.addAll({'mobile': phoneNumber});
      if (deviceToken != null) myBody.addAll({'device_token': deviceToken});
      if (bio != null && bio.toString().trim().length != 0) {
        myBody.addAll({'about_me': bio});
      }
      if (facebookLink != null && facebookLink.toString().trim().length != 0) {
        myBody.addAll({'facebook_link': facebookLink});
      }
      if (instagramLink != null &&
          instagramLink.toString().trim().length != 0) {
        myBody.addAll({'instagram_link': instagramLink});
      }
      if (linkedinLink != null && linkedinLink.toString().trim().length != 0) {
        myBody.addAll({'linkedin_link': linkedinLink});
      }
      if (dob != null) {
        myBody.addAll({'dob': dob.millisecondsSinceEpoch});
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
    // print("Result: ${response.statusCode}");
    // print("Result: ${response.body}");
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

  Future readContactsFromPhone() async {
    if (await Permission.contacts.isGranted) {
      contactsOnPhone = await FlutterContacts.getContacts(withProperties: true);


      List<String> mobileNumbers = [];
      print('=====getAllRegisteredUsersIcContactList========');

      if (contactsOnPhone.isEmpty) {
        await readContactsFromPhone();
      }
      contactsOnPhone.forEach((contact) {
        contact.phones.forEach((element) {
          try {
            String number=element.number.replaceAll(' ', '').trim();
            if (number.length > 10) {

              element.number = number
                  .substring(number.length - 10, number.length);

              mobileNumbers.add(number);
            } else {
              mobileNumbers.add(number);
            }
          } catch (e) {
            // print('getUserOnQuesChat mobil $e');
          }
        });
      });


      try {
        dynamic myBody = {
          'mobile_numbers': mobileNumbers,
        };

        var body =
        await postDataRequest(address: 'contact/users', myBody: myBody);

        if (body['Users'] != null) {
          try {
            body['Users'].forEach((user) {
              String id = user['id'].toString();
              String mobile = user['mobile'].toString();
              String name=user['name'];
              // String name = user['name'].toString();
              String bio;

              String profilePic;
              if (user['profile_pic'] != null) {
                profilePic = Urls().serverAddress + user['profile_pic'];
              }
              if (user['about_me'] != null) {
                bio = user['about_me'];
              }

              try {
                contactsOnPhone.forEach((contact) {
                  contact.phones.forEach((element) {
                    if (element.number.toString().trim() == mobile.trim()) {
                      name = contact.displayName;
                      queschatUsersMobileNumbers.add(element.number);
                    }
                  });
                });
              } catch (e) {

              }
              if (name == null) {
                name = mobile;
              }
              name = id == AppData().userId ? 'You' : name;

              queschatUsers.add(UserContactModel(
                  id: id,
                  bio: bio,
                  phoneNumbers: [mobile],
                  name: name,
                  profilePic: profilePic,
                  isSelected: false,
                  isUser: true));
            });
            contactsOnPhone.forEach((contact) {
              List<String> contactMobileNumbers = [];
              contact.phones.forEach((element) {
                if (!queschatUsersMobileNumbers.contains(element.number.trim())) {
                  if (!contactMobileNumbers.contains(element.number.trim())) {
                    contactMobileNumbers.add(element.number.trim());


                    nonQueschatUsers.add(UserContactModel(
                        isUser: false,
                        name: contact.displayName,
                        phoneNumbers: contactMobileNumbers,
                        isSelected: false));
                  }
                }
              });
            });

          } catch (e) {}

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
  }

  Future<List<UserContactModel>> getAllRegisteredUsersIcContactList(
      bool isAllUsers) async {

    if (isAllUsers) {
     List allUser=queschatUsers+nonQueschatUsers;
      return  allUser;
    }
    else{
      return queschatUsers;
    }
  }

  // Future<ChatRoomModel> getDetailsOfSelectedUserByContact(String userId) async {
  //   if (contactsOnPhone.isEmpty) {
  //     await readContactsFromPhone();
  //   }
  //   List<Contact> contacts = [];
  //   contacts.addAll(contactsOnPhone);
  //   print('=====getDetailsOfSelectedUserByContact========');
  //
  //   try {
  //     var body = await getDataRequest(address: 'user/profile/$userId');
  //
  //     if (body['User'] != null) {
  //       String name;
  //       String profilePic = body['User']['profile_pic']['url'] != null
  //           ? Urls().serverAddress + body['User']['profile_pic']['url']
  //           : null;
  //       String mobile = body['User']['mobile'].toString();
  //       contacts.forEach((contact) {
  //         contact.phones.forEach((element) {
  //           if (element.number.length > 10) {
  //             element.number = element.number
  //                 .substring(element.number.length - 10, element.number.length);
  //             if (element.number.toString() == mobile) {
  //               name = contact.displayName;
  //             }
  //           } else {
  //             if (element.number.toString() == mobile) {
  //               name = contact.displayName;
  //             }
  //           }
  //         });
  //       });
  //
  //       return ChatRoomModel(
  //           imageUrl: profilePic,
  //           name: name != null ? name : mobile,
  //           mobile: mobile);
  //     } else {
  //       if (body['message'] != null) {
  //         throw Exception(body['message']);
  //       } else {
  //         throw Exception('Please retry');
  //       }
  //     }
  //   } catch (e) {
  //     throw Exception('Please retry');
  //   }
  // }

  Future<UserContactModel> getDetailsOfUserNameElseNumber(
      String userId, String userType) async {

    if(queschatUsers.any((element) => element.id==userId)){
      UserContactModel userContactModel= queschatUsers.singleWhere((element) => element.id==userId);
      userContactModel.userType=userType;
      return userContactModel;
    }else{
      var body = await getDataRequest(address: 'user/profile/$userId');
      if (body['User'] != null) {
        String name= body['User']['name'];
        String profilePic = body['User']['profile_pic']['url'] != null
            ? Urls().serverAddress + body['User']['profile_pic']['url']
            : null;
        String mobile = body['User']['mobile'].toString();

        // name = userId == AppData().userId ? 'You' : name;
        return UserContactModel(
            profilePic: profilePic,
            userType: userType,
            id: userId,
            isUser: true,
            name: name != null ? name : mobile,
            phoneNumbers: [mobile]);
      } else {
        if (body['message'] != null) {
          if(body['message']=='User Not Found'){
            return UserContactModel(
                profilePic: null,
                userType: userType,
                id: userId,
                isUser: true,
                name: 'Deleted User',
                phoneNumbers: ['DeletedUser']);
          }else {
            throw Exception(body['message']);
          }
        } else {
          throw Exception('Please retry');
        }
      }
    }

  }

  // getNameOfSelectedUserByContact(String userId) async {
  //   print('=====getNameOfSelectedUserByContact========');
  //
  //   if (contactsOnPhone.isEmpty) {
  //     await readContactsFromPhone();
  //   }
  //   List<Contact> contacts = [];
  //   contacts.addAll(contactsOnPhone);
  //
  //   try {
  //     var body = await getDataRequest(address: 'user/profile/$userId');
  //
  //     if (body['User'] != null) {
  //       String name;
  //
  //       String mobile = body['User']['mobile'].toString();
  //       contacts.forEach((contact) {
  //         contact.phones.forEach((element) {
  //           if (element.number.length > 10) {
  //             element.number = element.number
  //                 .substring(element.number.length - 10, element.number.length);
  //             if (element.number.toString() == mobile) {
  //               name = contact.displayName;
  //             }
  //           } else {
  //             if (element.number.toString() == mobile) {
  //               name = contact.displayName;
  //             }
  //           }
  //         });
  //       });
  //
  //       if (name == null) {
  //         if (AppData().userId == userId) {
  //           name = 'You';
  //         } else {
  //           name = mobile;
  //         }
  //       }
  //
  //       return name;
  //     } else {
  //       return userId;
  //     }
  //   } catch (e) {
  //     return userId;
  //   }
  // }

  Future<void> updateFirebaseDeviceToken(
      {String password, token, mobile}) async {
    print('=====UpdateFirebaseToken========');
    try {
      String deviceToken = await getFirebaseMessagingToken();

      dynamic myBody = {'device_token': deviceToken};
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
}
