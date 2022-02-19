

import 'dart:io';

class ProfileState {
  String name,phoneNumber,imageUrl,bio;
  File imageFile;
  DateTime birthDate;
  String facebookLink;
  String instagramLink;
  String linkedinLink;

  ProfileState({
      this.name='',
      this.phoneNumber='',
      this.imageUrl='',
      this.bio,
      this.imageFile,
      this.birthDate,
      this.facebookLink,
      this.instagramLink,
      this.linkedinLink});



  ProfileState copyWith({
    String name,
    String phoneNumber,
    File imageFile,
    String imageUrl,
    String bio,
    DateTime birthDate,
    String facebookLink,
    String instagramLink,
    String linkedinLink,
  }) {
    return ProfileState(
      name:name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      facebookLink: facebookLink ?? this.facebookLink,
      instagramLink: instagramLink ?? this.instagramLink,
      linkedinLink: linkedinLink ?? this.linkedinLink,
    );
  }
}
