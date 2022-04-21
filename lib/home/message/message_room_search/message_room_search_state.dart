import 'package:queschat/models/chat_room_model.dart';

class MessageRoomSearchState {
  List<ChatRoomModel> models=[];
  List<ChatRoomModel> displayModels=[];
  int page;
  bool isLoading;
  String parentPage;
  Exception actionErrorMessage;
  String searchQuery;

  MessageRoomSearchState({
    this.models,
    this.displayModels,
    this.page=1,
    this.parentPage,
    this.actionErrorMessage,
    this.isLoading=false,
    this.searchQuery
  });

  MessageRoomSearchState copyWith({
    var models,
    var displayModels,
    bool isLoading,
    String parentPage,
    Exception actionErrorMessage,
    int page,
    String searchQuery,
  }) {
    return MessageRoomSearchState(
      models: models ?? this.models,
      displayModels: displayModels ?? this.displayModels,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      parentPage: parentPage ?? this.parentPage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
