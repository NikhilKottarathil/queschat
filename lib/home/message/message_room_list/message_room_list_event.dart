import 'package:queschat/models/chat_room_model.dart';

class MessageRoomListEvent {}

class FetchInitialData extends MessageRoomListEvent {}

class UpdateList extends MessageRoomListEvent {

}

class RefreshList extends MessageRoomListEvent {}

class FetchMoreData extends MessageRoomListEvent {}

class UserAddedNewData extends MessageRoomListEvent {
  String id;

  UserAddedNewData({this.id});
}

class SearchQueryCleared extends MessageRoomListEvent {
  SearchQueryCleared();
}

class SearchQueryChanged extends MessageRoomListEvent {
  String value;

  SearchQueryChanged({this.value});
}

class DeleteChatRoom extends MessageRoomListEvent {
  int index;

  DeleteChatRoom({this.index});
}

class PinChatRoom extends MessageRoomListEvent {
  int index;

  PinChatRoom({this.index});
}

class MuteChatRoom extends MessageRoomListEvent {
  int index;

  MuteChatRoom({this.index});
}
