
import 'package:queschat/home/in_app_notification/in_app_notification_model.dart';

abstract class InAppNotificationState {}

class InitialState extends InAppNotificationState {}
class LoadMoreState extends InAppNotificationState {}


class NewNotificationCount extends InAppNotificationState {
  int count;
  NewNotificationCount(this.count);
}

class LoadList extends InAppNotificationState {
  final List<InAppNotificationModel> items;

  LoadList({this.items});

  LoadList copyWith({
    List<InAppNotificationModel> items,
  }) {
    return LoadList(
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items];
}


