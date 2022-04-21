import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/user_profile/user_profile_events.dart';
import 'package:queschat/authentication/user_profile/user_profile_state.dart';
import 'package:queschat/router/app_router.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  String userId;

  UserProfileBloc({@required this.userId}) : super(UserProfileState()) {
    getUserData();
  }

  Future getUserData() async {
    try {
      final user = await authRepository.getUserDetails(userId);
      state.name = user['name'] != null ? user['name'] : '';
      state.userId =userId;
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
    } on Exception {}
  }

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    if (event is UpdateData) {
      yield state.copyWith(name: state.name);
    }
  }
}
