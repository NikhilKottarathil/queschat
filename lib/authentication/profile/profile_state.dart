

import 'dart:io';

class ProfileState {
  String name,phoneNumber,imageUrl,bio;
  File imageFile;


  ProfileState({
    this.name='',
    this.phoneNumber='',
    this.imageUrl='',
    this.imageFile,
    this.bio
  });

  ProfileState copyWith({
    String name,
    String phoneNumber,
    File imageFile,
    String imageUrl,
    String bio,
  }) {
    return ProfileState(
      name:name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
    );
  }
}
