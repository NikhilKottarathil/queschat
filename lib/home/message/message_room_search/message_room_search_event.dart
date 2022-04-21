

class MessageRoomSearchEvent {}

class FetchInitialData extends MessageRoomSearchEvent {}

class UpdateList extends MessageRoomSearchEvent {

}

class RefreshList extends MessageRoomSearchEvent {}

class FetchMoreData extends MessageRoomSearchEvent {}

class UserAddedNewData extends MessageRoomSearchEvent {
  String id;

  UserAddedNewData({this.id});
}

class SearchQueryCleared extends MessageRoomSearchEvent {
  SearchQueryCleared();
}

class SearchQueryChanged extends MessageRoomSearchEvent {
  String value;

  SearchQueryChanged({this.value});
}

class DeleteChatRoom extends MessageRoomSearchEvent {
  int index;

  DeleteChatRoom({this.index});
}

class PinChatRoom extends MessageRoomSearchEvent {
  int index;

  PinChatRoom({this.index});
}

class MuteChatRoom extends MessageRoomSearchEvent {
  int index;

  MuteChatRoom({this.index});
}
