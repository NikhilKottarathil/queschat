

class MessageRoomForwardEvent {}

class FetchInitialData extends MessageRoomForwardEvent {}

class UpdateList extends MessageRoomForwardEvent {

}
class ForwardButtonPressed extends MessageRoomForwardEvent {

}

class RefreshList extends MessageRoomForwardEvent {}

class FetchMoreData extends MessageRoomForwardEvent {}

class UserAddedNewData extends MessageRoomForwardEvent {
  String id;

  UserAddedNewData({this.id});
}

class SearchQueryCleared extends MessageRoomForwardEvent {
  SearchQueryCleared();
}

class SearchQueryChanged extends MessageRoomForwardEvent {
  String value;

  SearchQueryChanged({this.value});
}

class DeleteChatRoom extends MessageRoomForwardEvent {
  int index;

  DeleteChatRoom({this.index});
}

class PinChatRoom extends MessageRoomForwardEvent {
  int index;

  PinChatRoom({this.index});
}

class MuteChatRoom extends MessageRoomForwardEvent {
  int index;

  MuteChatRoom({this.index});
}
