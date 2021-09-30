

import 'dart:io';

class ProfileState {
  String name,phoneNumber,imageUrl;
  File imageFile;


  ProfileState({
    this.name='',
    this.phoneNumber='',
    this.imageUrl='',
    this.imageFile,
  });

  ProfileState copyWith({
    String name,
    String phoneNumber,
    File imageFile,
    String imageUrl
  }) {
    return ProfileState(
      name:name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
