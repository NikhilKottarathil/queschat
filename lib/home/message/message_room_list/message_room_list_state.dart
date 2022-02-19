import 'package:queschat/models/chat_room_model.dart';

class MessageRoomListState {
  List<ChatRoomModel> models=[];
  List<ChatRoomModel> displayModels=[];
  int page;
  List<String> ids=[];
  bool isLoading;
  String parentPage;
  Exception actionErrorMessage;
  String searchQuery;

  MessageRoomListState({
    this.models,
    this.displayModels,
    this.ids,
    this.page=1,
    this.parentPage,
    this.actionErrorMessage,
    this.isLoading=false,
    this.searchQuery
  });

  MessageRoomListState copyWith({
    var models,
    var displayModels,
    var ids,
    bool isLoading,
    String parentPage,
    Exception actionErrorMessage,
    int page,
    String searchQuery,
  }) {
    return MessageRoomListState(
      models: models ?? this.models,
      displayModels: displayModels ?? this.displayModels,
      ids: ids ?? this.ids,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      parentPage: parentPage ?? this.parentPage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
