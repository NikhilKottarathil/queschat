class UserContactModel{
  String name,id,bio,profilePic;
  bool isUser=false;
  List<String> phoneNumbers;
  String userType;
  bool isSelected;
  UserContactModel({this.id,this.name,this.phoneNumbers,this.bio,this.profilePic,this.isUser,this.isSelected,this.userType});
}
