class AuthCredentials {
  bool isUser;
  final String userName;
  final String phoneNumber;
  final String password;
   String token;
  String generatedOTP;
  String verificationId;
  String firebaseToken;
  int resendToken;

  AuthCredentials({this.userName,this.isUser,  this.phoneNumber, this.password, this.token,this.firebaseToken,this.resendToken,this.verificationId,this.generatedOTP});
}
