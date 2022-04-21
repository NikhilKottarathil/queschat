

import 'dart:io';

class UserProfileState {
  String name,phoneNumber,imageUrl,bio;
  File imageFile;
  DateTime birthDate;
  String facebookLink;
  String instagramLink;
  String linkedinLink;
  String userId;

  UserProfileState({
      this.name='',
      this.phoneNumber='',
      this.imageUrl='',
      this.bio,
    this.userId,

      this.imageFile,
      this.birthDate,
      this.facebookLink,
      this.instagramLink,
      this.linkedinLink});



  UserProfileState copyWith({
    String name,
    String phoneNumber,
    File imageFile,
    String imageUrl,
    String userId,
    String bio,
    DateTime birthDate,
    String facebookLink,
    String instagramLink,
    String linkedinLink,
  }) {
    return UserProfileState(
      name:name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      userId: userId ?? this.userId,
      facebookLink: facebookLink ?? this.facebookLink,
      instagramLink: instagramLink ?? this.instagramLink,
      linkedinLink: linkedinLink ?? this.linkedinLink,
    );
  }
}
