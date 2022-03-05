import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_event.dart';
import 'package:queschat/home/message/message_room_list/message_room_list_state.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomListBloc
    extends Bloc<MessageRoomListEvent, MessageRoomListState> {
  String parentPage;

  // String isAllChatOrChannel;

  String detailsNode;

  DatabaseReference reference = FirebaseDatabase.instance.reference();

  TextEditingController textEditingController = TextEditingController();

  MessageRoomListBloc({
    @required this.parentPage,
  }) : super(MessageRoomListState(
            models: [], ids: [], displayModels: [], isLoading: true)) {
    state.parentPage = parentPage;
    if (parentPage == 'exploreChannel') {
      detailsNode = 'ChannelRooms';
      getAllChannelRooms();
    } else if (parentPage == 'channel') {
      detailsNode = 'ChannelRooms';
      getInitialChatRooms();
    } else {
      detailsNode = 'ChatRooms';
      getInitialChatRooms();
    }
    textEditingController.addListener(() {
      print('listning texxt controller');
      state.searchQuery = textEditingController.text;
      add(UpdateList());
    });
  }

  getAllChannelRooms() {
    reference
        .child(detailsNode)


        .once()
        .then((value) {
      Map<dynamic, dynamic> allChannels = value.value;
      print('allChannels');
      print(allChannels);
      if (allChannels != null && allChannels.isNotEmpty) {
        for (var mapEntry in allChannels.entries) {
          _covertDataToModel(
              messageRoomId: mapEntry.key, messageRoomMap: mapEntry.value);
        }
      }
    });
  }

  getInitialChatRooms() async {
    print(AppData().userId);
    reference
        .child('Users')
        .child(AppData().userId)
        .child(detailsNode)
        .onValue
        .listen((event) async {
      state.ids.clear();
      state.models.clear();
      state.displayModels.clear();
      state.page = 1;
      Map<dynamic, dynamic> chatRoomIDs = event.snapshot.value;
      print(chatRoomIDs);

      for (var mapEntry in chatRoomIDs.entries) {
        try {
          reference
              .child(detailsNode)
              .child(mapEntry.key)
              .onValue
              .listen((event) async {
            Map<dynamic, dynamic> messageRoomMap = event.snapshot.value;

            _covertDataToModel(
                messageRoomId: mapEntry.key, messageRoomMap: messageRoomMap);
          });
        } catch (e) {
          print('Error messageRoom List  ${mapEntry.key} ');
        }
      }
    });
  }

  sortChartRoomData(ChatRoomModel chatRoomModel) async {

    if (state.models.any((element) => element.id == chatRoomModel.id)) {
      state.models[state.models
              .indexWhere((element) => element.id == chatRoomModel.id)] =
          chatRoomModel;
      if(parentPage=='exploreChannel') {
        state.models.sort((l1, l2) {
          return l2.lastMessageTime.compareTo(l1.lastMessageTime);
        });
        add(UpdateList());
      }else{
        state.models.sort((l1, l2) {
          return l2.lastMessageTime.compareTo(l1.lastMessageTime);
        });
        add(UpdateList());
      }
    } else {
      state.models.add(chatRoomModel);
      state.models.sort((l1, l2) {
        return l2.lastMessageTime.compareTo(l1.lastMessageTime);
      });
      add(UpdateList());
    }
  }

  @override
  Stream<MessageRoomListState> mapEventToState(
      MessageRoomListEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(isLoading: true);
      await getInitialChatRooms();
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

  void _covertDataToModel(
      {@required messageRoomId, Map<dynamic, dynamic> messageRoomMap}) async {
    String messengerId = messageRoomMap['info']['messenger_id'];
    int unSeenMessageCount = 0;

    if (messageRoomMap['un_seen_message_count'] != null) {
      messageRoomMap['un_seen_message_count'].forEach((id, idValue) {
        if (id == AppData().userId) {
          unSeenMessageCount = idValue;
        }
      });
    }
    MessageModel lastMessageModel;
    if (parentPage != 'exploreChannel') {
      try {
        if (messageRoomMap['last_message'] != null) {
          Map<dynamic, dynamic> value = messageRoomMap['last_message'];

          MessageType messageType = MessageType.unsupported;
          if (value['message_type'] == 'text') {
            messageType = MessageType.text;
          } else if (value['message_type'] == 'image') {
            messageType = MessageType.image;
          } else if (value['message_type'] == 'video') {
            messageType = MessageType.video;
          } else if (value['message_type'] == 'audio') {
            messageType = MessageType.audio;
          } else if (value['message_type'] == 'voice_note') {
            messageType = MessageType.voice_note;
          } else if (value['message_type'] == 'deleted') {
            messageType = MessageType.deleted;
          }
          List<SeenStatus> seenStatuses = [];
          MessageStatus seenStatus = MessageStatus.sent;

          value['seen_status'].forEach((userId, status) {
            MessageStatus messageStatus = MessageStatus.sent;
            if (status == 'sent') {
              messageStatus = MessageStatus.sent;
            } else if (status == 'delivered') {
              messageStatus = MessageStatus.delivered;
            } else if (status == 'seen') {
              messageStatus = MessageStatus.seen;
            } else if (status == 'sending') {
              messageStatus = MessageStatus.sending;
            } else if (status == 'error') {
              messageStatus = MessageStatus.error;
            }
            seenStatus = messageStatus;
            seenStatuses
                .add(SeenStatus(userId: userId, messageStatus: messageStatus));
          });

          lastMessageModel = new MessageModel(
              senderID: value['sender_id'].toString(),
              messageType: messageType,
              messageMediaType: value['message_type'].toString(),
              message: value['message'],
              mediaUrl: value['media'] != null ? value['media'] : null,
              id: value['id'].toString(),
              seenStatues: seenStatuses,
              messageStatus: seenStatus,
              isSingleMessage: true,
              createdAt:
                  DateTime.fromMillisecondsSinceEpoch(value['created_at']));
        }
      } catch (e) {
        print('Error messageRoom List last message ${messageRoomId} ');
      }
    }
    bool isSingleChat =
        messageRoomMap['info']['is_single_chat'].toString() == 'True'
            ? true
            : false;
    if (isSingleChat) {
      UserContactModel userContactModel =
          await authRepository.getDetailsOfSelectedUser(messengerId, 'any');
      ChatRoomModel chatRoomModel = new ChatRoomModel(
        id: messageRoomId,
        name: userContactModel.name,
        messengerId: messengerId,
        imageUrl: userContactModel.profilePic,
        lastMessage: lastMessageModel,
        messageRoomType: messageRoomMap['info']['message_room_type'],
        createdTime: DateTime.fromMillisecondsSinceEpoch(
            messageRoomMap['info']['created_time']),
        isSingleChat: isSingleChat,
        unreadMessageCount: unSeenMessageCount,
        lastMessageTime: lastMessageModel != null
            ? lastMessageModel.createdAt
            : DateTime.fromMillisecondsSinceEpoch(
                messageRoomMap['info']['created_time']),
      );
      sortChartRoomData(chatRoomModel);
    } else {
      String imageUrl, imageId, name;

      name = messageRoomMap['info']['name'].toString();
      imageUrl = messageRoomMap['info']['icon_url'] != null
          ? Urls().serverAddress + messageRoomMap['info']['icon_url'].toString()
          : null;
      imageId = messageRoomMap['info']['icon_id'] != null
          ? messageRoomMap['info']['icon_id'].toString()
          : null;
      ChatRoomModel chatRoomModel = new ChatRoomModel(
        id: messageRoomId,
        name: name,
        imageUrl: imageUrl,
        imageId: imageId,
        lastMessage: lastMessageModel,
        description: messageRoomMap['info']['description'] != null
            ? messageRoomMap['info']['description']
            : '',
        createdTime: DateTime.fromMillisecondsSinceEpoch(
            messageRoomMap['info']['created_time']),
        isSingleChat: isSingleChat,
        messageRoomType: messageRoomMap['info']['message_room_type'],
        unreadMessageCount: unSeenMessageCount,
        lastMessageTime: lastMessageModel != null
            ? lastMessageModel.createdAt
            : DateTime.fromMillisecondsSinceEpoch(
                messageRoomMap['info']['created_time']),
      );
      sortChartRoomData(chatRoomModel);
    }
  }
}
