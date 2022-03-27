import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/profile/profile_state.dart';
import 'package:queschat/authentication/profile/profile_events.dart';
import 'package:queschat/constants/strings_and_urls.dart';

import 'package:queschat/function/select_image.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/router/app_router.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepo;
  var imageAspectRatio;

  ProfileBloc({this.authRepo})
      : super(ProfileState()) {
    getUserData();
  }

  Future getUserData() async {
    try {
      final user = await authRepo.getUserDetails();
      state.name = user['name'] != null ? user['name'] : '';
      state.phoneNumber = user['mobile'] != null ? user['mobile'] : '';
      state.bio = user['about_me'] != null ? user['about_me'] : null;
      state.instagramLink =
          user['instagram_link'] != null ? user['instagram_link'] : null;
      state.facebookLink =
          user['facebook_link'] != null ? user['facebook_link'] : null;
      state.linkedinLink =
          user['linkedin_link'] != null ? user['linkedin_link'] : null;
      state.birthDate = user['dob'] != null
          ? DateTime.fromMillisecondsSinceEpoch(user['dob'])
          : null;
      state.imageUrl = user['profile_pic']['url'] != null
          ? 'https://api.queschat.com/' + user['profile_pic']['url']
          : null;
      add(UpdateData());
    } on Exception {
    }
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    // Phone Number updated
    if (event is ChangeProfilePicture) {
      print('in');
      try {
        state.imageFile = await selectImage(
            imageFile: state.imageFile,
            aspectRatios: imageAspectRatio,
            context: event.context);
        await authRepo.changeProfilePicture(imageFile: state.imageFile);
        await getUserData();
        yield state.copyWith();
      } catch (e) {
        print(e);
      }
    } else if (event is ProfileEdited) {
      try {
        await getUserData();
        print(state.name);
        print(state.phoneNumber);
      } catch (e) {}
    } else if (event is UpdateData) {

      yield state.copyWith(name: state.name);
    } else if (event is FetchInitialFeeds) {
      homeFeedBloc.add(FetchInitialData());
    }
  }
}
