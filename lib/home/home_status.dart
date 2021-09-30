abstract class HomeStatus {
  const HomeStatus();
}

class InitialStatus extends HomeStatus {
  final int index;
  const InitialStatus({this.index});
}

class NotificationStatus extends HomeStatus {
}

class NewMessageStatus extends HomeStatus {}

