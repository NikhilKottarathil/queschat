class AuthCredentials {
  final String userName;
  final String phoneNumber;
  final String password;
   String token;
  String generatedOTP;
  String verificationId;
  String firebaseToken;
  int resendToken;

  AuthCredentials({this.userName, this.phoneNumber, this.password, this.token,this.firebaseToken,this.resendToken,this.verificationId,this.generatedOTP});
}
