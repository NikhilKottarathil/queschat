import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:queschat/home/message/message_room_search/message_room_search_event.dart';
import 'package:queschat/home/message/message_room_search/message_room_search_state.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomSearchBloc
    extends Bloc<MessageRoomSearchEvent, MessageRoomSearchState> {
  // String isAllChatOrChannel;

  String detailsNode;

  DatabaseReference reference = FirebaseDatabase.instance.reference();

  TextEditingController textEditingController = TextEditingController();

  MessageRoomSearchBloc()
      : super(MessageRoomSearchState(
            models: [], displayModels: [], isLoading: true)) {
    add(FetchInitialData());
    initMessageRoomSearch();
  }

  Future initMessageRoomSearch() async {
    textEditingController.addListener(() {
      print('listning texxt controller');
      state.searchQuery = textEditingController.text;
      add(UpdateList());
    });
  }

  @override
  Stream<MessageRoomSearchState> mapEventToState(
      MessageRoomSearchEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(isLoading: true);
      await  resetRepositoryAndBloc();
      state.models.clear();
      state.displayModels.clear();

      state.models.addAll(allChatMessageRoomListBloc.state.models);
      state.models.addAll(channelMessageRoomListBloc.state.models);
      print('channel ${allChatMessageRoomListBloc.state.models.length}');
      print('chat ${allChatMessageRoomListBloc.state.models.length}');
      List<String> existingChatUsers=[];
      allChatMessageRoomListBloc.state.models.forEach((element) {
        if(element.messageRoomType=='chat'){
          existingChatUsers.add(element.messengerId);
        }
      });

      authRepository.queschatUsers.forEach((element) {
        if(!existingChatUsers.contains(element.id)){
          state.models.add(ChatRoomModel(
            id: 'null',
            imageUrl: element.profilePic,
            name: element.name,isSingleChat: true,
            messengerId: element.id,
            mobile: element.phoneNumbers[0],
            messageRoomType: 'chat',
            unreadMessageCount: 0

          ));

        }
      });
      add(UpdateList());
    } else if (event is UpdateList) {
      List<String> searchArray = state.models.map((e) => e.name).toList();

      List<ChatRoomModel> tempModels = [];

      if (state.searchQuery == null ||
          state.searchQuery.toString().trim().length == 0) {
        tempModels = state.models;
      } else {
        final fuse = Fuzzy(searchArray);

        final result = fuse.search(state.searchQuery);
        print(result);

        result.forEach((r) {
          tempModels.add(state.models[searchArray.indexOf(r.item)]);
        });
      }
      print(
          'message room search ${state.searchQuery}  ${state.models.length} ${tempModels.length}');
      yield state.copyWith(
          displayModels: tempModels, models: state.models, isLoading: false);
    } else if (event is SearchQueryCleared) {
      textEditingController.text = '';
      // yield state.copyWith(isLoading: false, searchQuery: '');

      // add(SearchQueryChanged(value: textEditingController.text));
    }
  }
}
