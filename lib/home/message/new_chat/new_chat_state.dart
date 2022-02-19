import 'package:queschat/models/user_contact_model.dart';

abstract class NewChatState {}

class InitialState extends NewChatState {}

class SearchPressed extends NewChatState {}

class SearchCleared extends NewChatState {}

class LoadList extends NewChatState {
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


