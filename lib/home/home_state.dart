import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/home/home_status.dart';

class HomeState {
  int notificationCount;
  int tabIndex;
 final  HomeStatus homeStatus;

  HomeState({
    this.notificationCount = 0,
    this.tabIndex=0,
    this.homeStatus= const InitialStatus(index: 0),
  });

  HomeState copyWith({
    int notificationCount,
    int tabIndex,
    HomeStatus homeStatus,
  }) {
    return HomeState(
      notificationCount: notificationCount ?? this.notificationCount,
      tabIndex: tabIndex ?? this.tabIndex,
      homeStatus: homeStatus ?? this.homeStatus,

    );
  }
}
