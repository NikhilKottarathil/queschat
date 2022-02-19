import 'package:queschat/models/user_contact_model.dart';

abstract class AddMembersToMessageRoomState {}

class InitialState extends AddMembersToMessageRoomState {}

class ErrorMessage extends AddMembersToMessageRoomState {
  Exception e;

  ErrorMessage({this.e});
}

class LoadingState extends AddMembersToMessageRoomState {}

class CreationSuccessful extends AddMembersToMessageRoomState {}

class LoadList extends AddMembersToMessageRoomState {
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
