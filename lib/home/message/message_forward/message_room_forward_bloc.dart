import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:queschat/home/message/message_forward/message_room_formward_state.dart';
import 'package:queschat/home/message/message_forward/message_room_forward_event.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_view.dart';
import 'package:queschat/main.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomForwardBloc
    extends Bloc<MessageRoomForwardEvent, MessageRoomForwardState> {
  DatabaseReference reference = FirebaseDatabase.instance.reference();

  TextEditingController textEditingController = TextEditingController();

  MessageModel messageModel;
  ChatRoomModel chatRoomModel;

  MessageRoomForwardBloc(
      {@required this.chatRoomModel, @required this.messageModel})
      : super(MessageRoomForwardState(
            models: [], displayModels: [], isLoading: true)) {
    add(FetchInitialData());
    initMessageRoomForward();
  }

  Future initMessageRoomForward() async {
    textEditingController.addListener(() {
      print('listning texxt controller');
      state.searchQuery = textEditingController.text;
      add(UpdateList());
    });
  }

  @override
  Stream<MessageRoomForwardState> mapEventToState(
      MessageRoomForwardEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(isLoading: true);
      state.models.addAll(allChatMessageRoomListBloc.state.models
          .map((item) => new ChatRoomModel.clone(item))
          .toList());
      state.models.addAll(channelMessageRoomListBloc.state.models
          .map((item) => new ChatRoomModel.clone(item))
          .toList());
      List<String> existingChatUsers = [];
      allChatMessageRoomListBloc.state.models.forEach((element) {
        if (element.messageRoomType == 'chat') {
          existingChatUsers.add(element.messengerId);
        }
      });

      authRepository.queschatUsers.forEach((element) {
        if (!existingChatUsers.contains(element.id)) {
          state.models.add(ChatRoomModel(
              id: 'null',
              imageUrl: element.profilePic,
              name: element.name,
              isSingleChat: true,
              isSelected: false,
              messengerId: element.id,
              mobile: element.phoneNumbers[0],
              messageRoomType: 'chat',
              unreadMessageCount: 0));
        }
      });
      state.models.forEach((element) {
        element.isSelected = false;
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
    } else if (event is ForwardButtonPressed) {
      int count = 0;
      state.models.forEach((element) {
        if (element.isSelected) {
          count += 1;
        }
      });
      if (count == 1) {
        for (var element in state.models) {
          if (element.isSelected) {
            String parentPage;
            ChatRoomModel chatRoomModelElement;

            if (element.id == 'null') {
              parentPage = 'newChat';
              chatRoomModelElement = ChatRoomModel(
                  name: element.name,
                  imageUrl: element.imageUrl,
                  messageRoomType: 'chat',
                  isSingleChat: true,
                  messengerId: element.messengerId);
            } else {
              chatRoomModelElement = ChatRoomModel(id: element.id);
              if (element.messageRoomType == 'channel') {
                parentPage = 'channelRoomsView';
              } else {
                parentPage = 'ChatRoomsViews';
              }
            }
            Map<String, dynamic> forwardBody = {};
            if(messageModel.forwardMessage!=null){
              forwardBody.addAll({
                'message_room_id': messageModel.forwardMessage.messageRoomId,
                'message_id': messageModel.forwardMessage.messageId,
                'message_type': 'forwarded',
                'message_room_type': messageModel.forwardMessage.messageRoomType
              });
            }else{
              forwardBody.addAll({
                'message_room_id': chatRoomModel.id,
                'message_id': messageModel.id,
                'message_type':'forwarded',
                'message_room_type': chatRoomModel.messageRoomType
              });
            }
            MessageRoomCubit messageRoomCubit = MessageRoomCubit(
                parentPage: parentPage, chatRoomModel: chatRoomModelElement);

            Navigator.of(MyApp.navigatorKey.currentContext).pop();
            Navigator.of(MyApp.navigatorKey.currentContext).pop();
            Navigator.of(MyApp.navigatorKey.currentContext).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                        child: MessageRoomView(),
                        create: (_) => messageRoomCubit)));
            messageRoomCubit.sendMessage(
                messageType: MessageType.forward, forwardBody: forwardBody);
            break;
          }
        }
      } else {
        state.models.forEach((element) {
          if (element.isSelected) {
            String parentPage;
            ChatRoomModel chatRoomModelElement;

            if (element.id == 'null') {
              parentPage = 'newChat';
              chatRoomModelElement = ChatRoomModel(
                  name: element.name,
                  imageUrl: element.imageUrl,
                  messageRoomType: 'chat',
                  isSingleChat: true,
                  messengerId: element.messengerId);
            } else {
              chatRoomModelElement = ChatRoomModel(id: element.id);
              if (element.messageRoomType == 'channel') {
                parentPage = 'channelRoomsView';
              } else {
                parentPage = 'ChatRoomsViews';
              }
            }
            Map<String, dynamic> forwardBody = {
              'message_room_id': chatRoomModel.id,
              'message_id': messageModel.id,
              'message_type': messageModel.message,
              'message_room_type': chatRoomModel.messageRoomType
            };
            MessageRoomCubit(
                    parentPage: parentPage, chatRoomModel: chatRoomModelElement)
                .sendMessage(
                    messageType: MessageType.forward, forwardBody: forwardBody);
          }
        });
        Navigator.of(MyApp.navigatorKey.currentContext).pop();
        Navigator.of(MyApp.navigatorKey.currentContext).pop();
      }
    }
  }
}
