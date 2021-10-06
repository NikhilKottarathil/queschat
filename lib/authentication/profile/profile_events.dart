import 'package:flutter/cupertino.dart';

abstract class ProfileEvent {}

class ProfileEdited extends ProfileEvent {}
class FetchInitialFeeds  extends ProfileEvent {}

class ChangeProfilePicture extends ProfileEvent {
  final BuildContext context;
  ChangeProfilePicture({@required this.context});
}


