import 'package:queschat/models/chat_room_model.dart';

class MessageRoomForwardState {
  List<ChatRoomModel> models=[];
  List<ChatRoomModel> displayModels=[];
  int page;
  bool isLoading;
  String parentPage;
  Exception actionErrorMessage;
  String searchQuery;

  MessageRoomForwardState({
    this.models,
    this.displayModels,
    this.page=1,
    this.parentPage,
    this.actionErrorMessage,
    this.isLoading=false,
    this.searchQuery
  });

  MessageRoomForwardState copyWith({
    var models,
    var displayModels,
    bool isLoading,
    String parentPage,
    Exception actionErrorMessage,
    int page,
    String searchQuery,
  }) {
    return MessageRoomForwardState(
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
