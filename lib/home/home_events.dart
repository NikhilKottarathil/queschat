abstract class HomeEvent {}

class FabPressed extends HomeEvent {}

class NotificationClicked extends HomeEvent {}

class CreateClicked extends HomeEvent {}

class OptionMenuClicked extends HomeEvent {}

class ChangeTab extends HomeEvent {
  final int index;
  ChangeTab(this.index);
}

