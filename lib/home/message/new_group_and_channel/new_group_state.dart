import 'dart:io';

import 'package:queschat/models/user_contact_model.dart';

abstract class NewGroupState {}

class InitialState extends NewGroupState {}

class ErrorMessage extends NewGroupState {
  Exception e;

  ErrorMessage({this.e});
}
class CreationSuccessful extends NewGroupState {
  String id;
  List<String>memberIds = [];
  String groupIconUrl;
  String description;

  CreationSuccessful({this.id,this.memberIds,this.groupIconUrl,this.description});
}

class GroupIconChanged extends NewGroupState {
  File groupIcon;

  GroupIconChanged({this.groupIcon});
}class GroupNameChanged extends NewGroupState {
  String groupName;

  GroupNameChanged({this.groupName});
}

class LoadList extends NewGroupState {
  final List<UserContactModel> items;

  LoadList({this.items});

  LoadList copyWith({
    List<UserContactModel> items,
  }) {
    return LoadList(
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items];
}
