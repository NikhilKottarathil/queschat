abstract class MessageHomeEvent {}

class FabPressed extends MessageHomeEvent {}

class NotificationClicked extends MessageHomeEvent {}

class CreateClicked extends MessageHomeEvent {}

class OptionMenuClicked extends MessageHomeEvent {}

class ChangeTab extends MessageHomeEvent {
  final int index;
  ChangeTab(this.index);
}

