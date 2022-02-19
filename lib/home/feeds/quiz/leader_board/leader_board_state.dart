

import 'package:queschat/home/feeds/quiz/leader_board/leader_board_model.dart';

abstract class LeaderBoardState {}

class InitialState extends LeaderBoardState {}
class LoadMoreState extends LeaderBoardState {}


class NewNotificationCount extends LeaderBoardState {
  int count;
  NewNotificationCount(this.count);
}

class LoadList extends LeaderBoardState {
  final List<LeaderBoardModel> items;

  LoadList({this.items});

  LoadList copyWith({
    List<LeaderBoardModel> items,
  }) {
    return LoadList(
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items];
}


