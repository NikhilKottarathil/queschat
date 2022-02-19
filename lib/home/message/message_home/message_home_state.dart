import 'package:queschat/home/home/home_status.dart';

class MessageHomeState {
  int tabIndex;
 final  HomeStatus homeStatus;

  MessageHomeState({
    this.tabIndex=0,
    this.homeStatus= const InitialStatus(index: 0),
  });

  MessageHomeState copyWith({
    int tabIndex,
    HomeStatus homeStatus,
  }) {
    return MessageHomeState(
      tabIndex: tabIndex ?? this.tabIndex,
      homeStatus: homeStatus ?? this.homeStatus,

    );
  }
}
