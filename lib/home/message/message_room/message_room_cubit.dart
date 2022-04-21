import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:queschat/function/file_types.dart';
import 'package:queschat/function/select_image.dart';
import 'package:queschat/function/some_function.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/feed_actions.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomCubit extends Cubit<MessageRoomState> {
  String parentPage;
  ChatRoomModel chatRoomModel;

  List<UserContactModel> userContactModels = [];

  DatabaseReference reference = FirebaseDatabase.instance.reference();
  TextEditingController textEditingController = TextEditingController();


  // List<String> ids = [];
  List<MessageModel> messageModels = [];

  DateTime messageRoomOpenTime = DateTime.now();

  // DateTime joiningDateTime;
  // DateTime removedDateTime;

  MessageRoomStatus messageRoomStatus = MessageRoomStatus.NotExist;
  MessageRoomUserStatus messageRoomUserStatus = MessageRoomUserStatus.UnKnown;

  bool isInInitialState = true;

  String lastSeenAndStatus = '';
  String dataNode;
  String detailsNode;
  String userRole = 'user';
  String messageRoomName = '';
  String description = '';
  int initialMessageCount = 25;
  int loadMoreMessageCount = 20;
  bool isAllMessageLoaded = false;
  bool emojiShowing = false;

  MessageRoomCubit({@required this.parentPage, @required this.chatRoomModel})
      : super(InitialState()) {
    if (parentPage == 'channelRoomsView' ||
        parentPage == 'dynamicLinkChannel' ||
        parentPage == 'newChannelCreateView' ||
        parentPage == 'channelFeedAdapter' ||
        parentPage == 'exploreChannelRoomsView') {
      dataNode = 'ChannelRoomsData';
      detailsNode = 'ChannelRooms';
    } else {
      dataNode = 'ChatRoomsData';
      detailsNode = 'ChatRooms';
    }
    if (chatRoomModel.id != null) {
      AwesomeNotifications()
          .cancel(getAlphabetOrderNumberFromString(chatRoomModel.id));
    }
    getMessageRoomInfo();

    textEditingController.addListener(() {
      emit(TextMessageState(
          message: textEditingController.text,
          messageRoomUserStatus: messageRoomUserStatus,
          messageRoomStatus: messageRoomStatus,
          userRole: userRole));
    });
  }

  getLiveChat() async {
    print(AppData().userId);
    isInInitialState = false;
    print('messageDataText LiveChat');

    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('un_seen_message_count')
        .child(AppData().userId)
        .set(0);
    reference
        .child(dataNode)
        .child(chatRoomModel.id)
        .onChildChanged
        .listen((event) async {
      print('inside change lsitner ${event.snapshot.value}');

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> value = event.snapshot.value;
        String id = value['id'].toString();
        if (messageModels.map((e) => e.id).toList().contains(id)) {
          MessageModel messageModel = await convertDataToMessageModel(value);

          messageModels[messageModels.map((e) => e.id).toList().indexOf(id)] =
              messageModel;

          updateMessageList();
        }
      }
    });
    reference
        .child(dataNode)
        .child(chatRoomModel.id)
        .limitToLast(1)
        .onChildAdded
        .listen((event) async {
      print('inside added lsitner ${event.snapshot.value}');

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> value = event.snapshot.value;
        DateTime createdAt =
        DateTime.fromMillisecondsSinceEpoch(value['created_at'] - 1);
        if (messageRoomOpenTime.millisecondsSinceEpoch <
            createdAt.millisecondsSinceEpoch) {
          String id = value['id'].toString();

          if (!messageModels
              .map((e) => e.id)
              .toList()
              .contains(getDisplayDate(createdAt))) {
            messageModels.insert(
                0,
                MessageModel(
                    messageType: MessageType.date,
                    message: getDisplayDate(createdAt),
                    id: getDisplayDate(createdAt),
                    createdAt: createdAt));
            messageModels
                .map((e) => e.id)
                .toList()
                .add(getDisplayDate(createdAt));
          }
          MessageModel messageModel = await convertDataToMessageModel(value);

          if (messageModels.map((e) => e.id).toList().contains(id)) {
            messageModels[messageModels.map((e) => e.id).toList().indexOf(id)] =
                messageModel;
          } else {
            messageModels.insert(0, messageModel);
          }

          updateMessageList();
        }
      }
    });
    initialMessageData();
  }

  initialMessageData() async {
    print('inside loadMore');
    // if (messageModels.first.createdAt.millisecondsSinceEpoch >=
    //     (chatRoomModel.createdTime.millisecondsSinceEpoch - (86400000 * 1)))
        {
      if (messageModels.length > 10) {
        emit(LoadMoreState());
      }
      print('inside created condition');
// print(messageModels.last.createdAt);
      await reference
          .child(dataNode)
          .child(chatRoomModel.id)
          .orderByKey()
          .limitToLast(20)
          .once()
          .then((DataSnapshot snapshot) {
        print('inside reference condition');

        if (snapshot.value != null) {
          Map<dynamic, dynamic> data = snapshot.value;
          print('inside null condition ${data}');

          loopMessageData(data);
        }else{
          updateMessageList();

        }
      });
    }
  }

  loadMoreMessages() async {
    print('inside loadMore');
    if (!isAllMessageLoaded) {
      if (messageModels.length > 10) {
        emit(LoadMoreState());
      }
      print('inside created condition');
// print(messageModels.last.createdAt);
      await reference
          .child(dataNode)
          .child(chatRoomModel.id)
          .orderByKey()
          .endAt(messageModels[messageModels.length - 2].id)
          .limitToLast(20)
          .once()
          .then((DataSnapshot snapshot) {
        print('inside reference condition');

        if (snapshot.value != null) {
          Map<dynamic, dynamic> data = snapshot.value;
          if (data.length <= 1) {
            isAllMessageLoaded = true;
          }
          print('inside null condition ${data.length}');

          loopMessageData(data);
        }
        else{
          updateMessageList();

        }
      });
    }
  }

  loopMessageData(Map<dynamic, dynamic> data) async {
    for (var mapEntry in data.entries) {
      String id = mapEntry.key;
      var value = mapEntry.value;
      MessageModel messageModel = await convertDataToMessageModel(value);

      if (!messageModels.map((e) => e.id).toList().contains(id)) {
        messageModels.add(messageModel);
      } else {
        messageModels[messageModels.map((e) => e.id).toList().indexOf(id)] =
            messageModel;
      }
      DateTime createdAt =
      DateTime.fromMillisecondsSinceEpoch(value['created_at'] - 1);
      if (messageModels
          .map((e) => e.id)
          .toList()
          .contains(getDisplayDate(createdAt))) {
        int index = messageModels
            .map((e) => e.id)
            .toList()
            .indexOf(getDisplayDate(createdAt));
        DateTime previousCreatedAt = messageModels[index].createdAt;

        messageModels.removeAt(index);

        messageModels.add(MessageModel(
            messageType: MessageType.date,
            id: getDisplayDate(createdAt),
            message: getDisplayDate(createdAt),
            createdAt: createdAt.millisecondsSinceEpoch <
                previousCreatedAt.millisecondsSinceEpoch
                ? createdAt
                : previousCreatedAt));
      } else {
        messageModels.add(MessageModel(
            messageType: MessageType.date,
            id: getDisplayDate(createdAt),
            message: getDisplayDate(createdAt),
            createdAt: createdAt));
      }
    }
    updateMessageList();
  }

  updateMessageList() {
    messageModels.sort((l1, l2) {
      return l2.createdAt.compareTo(l1.createdAt);
    });
    emit(LoadList().copyWith(messageModels: messageModels));
    // if (ids.length < 25) {
    //   print('load messages');
    //
    //   loadMoreMessages();
    //   print('load messages complete');
    // } else {
    //   print('ids.length is high');
    // }
  }

  Future<MessageModel> convertDataToMessageModel(
      Map<dynamic, dynamic> value) async {
    DateTime createdAt =
    DateTime.fromMillisecondsSinceEpoch(value['created_at']);
    String senderId = value['sender_id'].toString();
    String id = value['id'];
    List<SeenStatus> seenStatuses = [];
    MessageStatus seenStatus = MessageStatus.sent;
    bool isForwardMessage=false;
    if (value['seen_status'] != null) {
      value['seen_status'].forEach((userId, status) {
        MessageStatus messageStatus = MessageStatus.sent;
        if (status == 'sent') {
          messageStatus = MessageStatus.sent;
          if (AppData().userId == userId &&
              AppData().userId != value['sender_id']) {
            reference
                .child(dataNode)
                .child(chatRoomModel.id)
                .child(value['id'])
                .child('seen_status')
                .child(userId)
                .set('seen');
          }
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
    }
    ForwardMessage forwardMessage;
    if (value['forward_message'] != null&& value['message_type']!='deleted') {
      String dataNode;
      isForwardMessage=true;

      if (value['forward_message']['message_room_type'] == 'channel') {
        dataNode = 'ChannelRoomsData';
      } else {
        dataNode = 'ChatRoomsData';
      }
      forwardMessage = ForwardMessage(
          messageRoomType: value['forward_message']['message_room_type'],
          messageRoomId: value['forward_message']['message_room_id'],
          messageId: value['forward_message']['message_id']);

    await reference
        .child(dataNode)
        .child(value['forward_message']['message_room_id'])
        .child(value['forward_message']['message_id'])
        .once()
        .then((snapShot) {
    print('forward message ${snapShot.value}');
    value = snapShot.value;

    });
    }
    MessageType messageType = MessageType.unsupported;
    String feedId;
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
    } else if (value['message_type'] == 'document') {
    messageType = MessageType.document;
    } else if (value['message_type'] == 'feed') {
    messageType = MessageType.feed;
    feedId = value['feed_id'];
    } else if (value['message_type'] == 'deleted') {
      if(isForwardMessage) {
        messageType = MessageType.forward_deleted;
      }else{
        messageType = MessageType.deleted;

      }
    } else if (value['message_type'] == 'forwarded') {
      messageType = MessageType.forward;
    }

    MessageModel messageModel = new MessageModel(
    senderID: senderId,
    messageType: messageType,
    message: value['message'],
    mediaId: value['media_id'].toString(),
    mediaUrl: value['media'] != null
    ? Urls().serverAddress + value['media']
        : null,
    id: id,
    feedId: feedId,
    seenStatues: seenStatuses,
    messageStatus: seenStatus,
    isSingleMessage: chatRoomModel.isSingleChat,
    forwardMessage: forwardMessage,
    createdAt: createdAt);
    return messageModel;
  }

  incrementUnSeenMessageCount() {
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('un_seen_message_count')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data != null) {
        data.forEach((key, value) {
          if (key != AppData().userId) {
            reference
                .child(detailsNode)
                .child(chatRoomModel.id)
                .child('un_seen_message_count')
                .child(key)
                .set(value + 1);
          }
        });
      }
    });
  }

  listenUserPresenceStatus(String messengerId) async {
    reference
        .child('presence/$messengerId')
        .onValue
        .listen((event) async {
      print('statusAndLastSeen2');

      if (event.snapshot.value != null) {
        print('statusAndLastSeen3');
        if (event.snapshot.value == 'online') {
          lastSeenAndStatus = event.snapshot.value;
          emit(StatusAndLastSeenState(statusAndLastSeen: event.snapshot.value));
        } else {
          lastSeenAndStatus =
          'last seen at ${getDisplayDateOrTime(
              DateTime.fromMillisecondsSinceEpoch(event.snapshot.value))}';
          emit(StatusAndLastSeenState(
              statusAndLastSeen:
              'last seen at ${getDisplayDateOrTime(
                  DateTime.fromMillisecondsSinceEpoch(
                      event.snapshot.value))}'));
        }
      }
    });
    print('statusAndLastSeen');

    // return statusAndLastSeen;
  }

  listenTypingUsers() async {
    await reference
        .child('TypingListener')
        .child(chatRoomModel.id)
        .child('is_typing')
        .onValue
        .listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value;
      List<String> typingUsers = [];

      if (data != null) {
        data.forEach((key, value) async {
          if (AppData().userId != key) {
            // {
            typingUsers.add(key);
          }
          print('value models length 00  ${typingUsers.length}');
        });
        emit(TypingUserState(typingUsers: typingUsers));

        print('value models length ${typingUsers.length}');
      } else {
        emit(StatusAndLastSeenState(statusAndLastSeen: lastSeenAndStatus));
      }
    });
    if (chatRoomModel.messageRoomType == 'chat') {
      listenUserPresenceStatus(chatRoomModel.messengerId);
    }
  }

  getMembers() {
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('members')
        .onValue
        .listen((event) async {
      print('aaaaaaaaaaa member node listning');
      Map<dynamic, dynamic> data = event.snapshot.value;
      userContactModels.clear();
      messageRoomUserStatus = MessageRoomUserStatus.NotJoined;

      if (data != null) {
        List<UserContactModel> tempUserContactModels = [];

        for (var mapEntry in data.entries) {
          if (mapEntry.key == AppData().userId) {
            userRole = mapEntry.value['user_type'].toString();
            // joiningDateTime = DateTime.fromMillisecondsSinceEpoch(
            //     int.parse(mapEntry.value['joining_date'].toString()));
            if (mapEntry.value['status'].toString() == 'removed') {
              messageRoomUserStatus = MessageRoomUserStatus.Removed;
              // removedDateTime = DateTime.fromMillisecondsSinceEpoch(
              //     mapEntry.value['removed_date']);
            } else {
              messageRoomUserStatus = MessageRoomUserStatus.Active;
            }
            userRole = mapEntry.value['user_type'];
          }
          if (mapEntry.value['status'].toString() == 'active') {
            tempUserContactModels.add(
                await authRepository.getDetailsOfUserNameElseNumber(
                    mapEntry.key, mapEntry.value['user_type'].toString()));
          }
        }
        print('user role $userRole ');

        emit(TextMessageState(
            message: textEditingController.text,
            messageRoomUserStatus: messageRoomUserStatus,
            messageRoomStatus: messageRoomStatus,
            userRole: userRole));
        userContactModels.clear();

        userContactModels.addAll(tempUserContactModels);
        userContactModels.sort((l1, l2) {
          return l2.name.compareTo(l1.name);
        });
        if(chatRoomModel.isSingleChat){
          tempUserContactModels.removeWhere((element) => element.id==AppData().userId);
          chatRoomModel.name=tempUserContactModels[0].name;
          chatRoomModel.messengerId=tempUserContactModels[0].id;
          chatRoomModel.imageUrl=tempUserContactModels[0].profilePic;
        }
        emit(InfoDetails(chatRoomModel: chatRoomModel));

        emit(MembersState(userContactModels: userContactModels));
        if (isInInitialState) {
          getLiveChat();
        }
        listenTypingUsers();
      }
    });
  }

  getMessageRoomInfo() async {
    if (parentPage == 'newChat') {
      messageRoomStatus = MessageRoomStatus.NotCreated;
      messageRoomUserStatus = MessageRoomUserStatus.Active;
      emit(InfoDetails(chatRoomModel: chatRoomModel));

      await Future.delayed(Duration(milliseconds: 1));
      emit(TextMessageState(
          message: '',
          messageRoomStatus: messageRoomStatus,
          messageRoomUserStatus: messageRoomUserStatus,
          userRole: userRole));
      updateMessageList();


    } else {
      reference
          .child(detailsNode)
          .child(chatRoomModel.id)
          .child('info')
          .onValue
          .listen((event) async {
        Map<dynamic, dynamic> map = event.snapshot.value;
        userContactModels.clear();
        if (map != null) {
          if (map['status'] == 'active') {
            messageRoomStatus = MessageRoomStatus.Active;
          } else {
            messageRoomStatus = MessageRoomStatus.Deleted;
          }

          // String messengerId = map['messenger_id'];
          int unSeenMessageCount = 0;
          String imageUrl = map['icon_url'] != null
              ? Urls().serverAddress + map['icon_url'].toString()
              : null;
          String imageId =
          map['icon_id'] != null ? map['icon_id'].toString() : null;
          bool isSingleChat =
          map['is_single_chat'].toString() == 'True' ? true : false;
          if (isSingleChat) {
            // UserContactModel userContactModel = await authRepository
            //     .getDetailsOfUserNameElseNumber(messengerId, 'any');
            ChatRoomModel tempChatRoomModel = new ChatRoomModel(
                id: chatRoomModel.id.toString(),
                // name: userContactModel.name,
                // messengerId: messengerId,
                // imageUrl: userContactModel.profilePic,
                messageRoomType: map['message_room_type'],
                createdTime:
                DateTime.fromMillisecondsSinceEpoch(map['created_time']),
                isSingleChat: isSingleChat,
                unreadMessageCount: unSeenMessageCount,
                lastMessageTime: DateTime.now());
            chatRoomModel = tempChatRoomModel;
          } else {
            ChatRoomModel tempChatRoomModel = new ChatRoomModel(
                id: chatRoomModel.id,
                name: map['name'],
                imageUrl: imageUrl,
                imageId: imageId,
                description:
                map['description'] != null ? map['description'] : '',
                createdTime:
                DateTime.fromMillisecondsSinceEpoch(map['created_time']),
                isSingleChat: isSingleChat,
                messageRoomType: map['message_room_type'],
                unreadMessageCount: unSeenMessageCount,
                lastMessageTime: DateTime.now());

            chatRoomModel = tempChatRoomModel;
          }
          messageRoomName = chatRoomModel.name;
          description = chatRoomModel.description != null
              ? chatRoomModel.description
              : '';

          getMembers();
        } else {
          messageRoomStatus = MessageRoomStatus.NotExist;
        }
        emit(TextMessageState(
            message: textEditingController.text,
            messageRoomUserStatus: messageRoomUserStatus,
            messageRoomStatus: messageRoomStatus,
            userRole: userRole));
      });
    }
  }

  sendMessage({MessageType messageType,
    List<File> files,
    String feedId,
    Map<String, dynamic> forwardBody}) async {
    String message = textEditingController.text;
    Map<String, dynamic> chatRoomMap = {};
    Map<String, String> seenStatus = {};

    if (messageRoomStatus == MessageRoomStatus.NotCreated) {
      String messageRoomId = reference
          .push()
          .key;
      chatRoomModel.id = messageRoomId;

      Map<String, dynamic> unSeenMessageCountMap = {};
      Map<String, dynamic> memberMap = {};

      memberMap.addAll({
        chatRoomModel.messengerId: {
          'user_type': 'owner',
          'joining_date': ServerValue.timestamp,
          'status': 'active'
        }
      });
      unSeenMessageCountMap.addAll({chatRoomModel.messengerId: 0});
      seenStatus.addAll({chatRoomModel.messengerId: 'sent'});

      memberMap.addAll({
        AppData().userId: {
          'user_type': 'owner',
          'joining_date': ServerValue.timestamp,
          'status': 'active'
        }
      });
      unSeenMessageCountMap.addAll({AppData().userId: 0});
      seenStatus.addAll({AppData().userId: 'sent'});

      Map<String, dynamic> infoMap = {
        'created_time': ServerValue.timestamp,
        'created_by': AppData().userId,
        'is_single_chat': 'True',
        'status': 'active',
        'message_room_type': 'chat',
        'name': 'single',
        'messenger_id': chatRoomModel.messengerId
      };
      chatRoomMap.addAll({
        'info': infoMap,
        'un_seen_message_count': unSeenMessageCountMap,
        'members': memberMap,
      });
    } else {
      for (var element in userContactModels) {
        seenStatus.addAll({element.id: 'sent'});
      }
    }

    // print('submit 1');
    if (messageType == MessageType.file ||
        messageType == MessageType.voice_note) {
      // print('submit  if 3');

      await Future.forEach(files, (file) async {
        try {
          String messageId = reference
              .push()
              .key;
          messageModels.insert(
              0,
              MessageModel(
                  id: messageId,
                  createdAt: DateTime.now(),
                  messageType: MessageType.loading));
          updateMessageList();
          Map<String, String> requestBody = {};
          var body = await postImageDataRequest(
              imageAddress: 'images',
              address: 'media',
              imageFile: file,
              myBody: requestBody);
          if (body['url'] != null) {
            Map<String, dynamic> data = {
              'message': messageType == MessageType.voice_note
                  ? 'voice_note'
                  : getFileTypeFromPath(file.path),
              'media': body['url'].toString(),
              'media_id': body['id'].toString(),
              'sender_id': AppData().userId,
              'created_at': ServerValue.timestamp,
              'id': messageId,
              'message_type': messageType == MessageType.voice_note
                  ? 'voice_note'
                  : getFileTypeFromPath(file.path),
              'seen_status': seenStatus
            };
            incrementUnSeenMessageCount();

            reference
                .child(dataNode)
                .child(chatRoomModel.id)
                .child(messageId)
                .set(data);
            reference
                .child(detailsNode)
                .child(chatRoomModel.id)
                .child('last_message')
                .set(data);

            createMessageRoom(chatRoomMap);

            sendNotificationRequest(
                messageTypeString: messageType == MessageType.voice_note
                    ? 'voice_note'
                    : getFileTypeFromPath(file.path),
                message: textEditingController.text);
          } else {
            throw Exception('Image Uploading  Failed');
          }
        } catch (e) {
          print(e);
          // print('failed dailed');
        }
      });
    } else if (messageType == MessageType.text ||
        messageType == MessageType.feed) {
      try {
        // int millis = ServerValue.timestamp-(86400000*40);

        // for (int i = 0; i < 200; i++) {
        String messageId = reference
            .push()
            .key;

        Map<String, dynamic> data = {
          'sender_id': AppData().userId,
          // 'created_at': ServerValue.timestamp,
          'created_at': ServerValue.timestamp,
          // 'created_at': millis,
          'id': messageId,
          'seen_status': seenStatus
        };
        // millis = millis + 10000000;
        if (messageType == MessageType.text) {
          data.addAll({
            // 'message': i.toString(),
            'message': message,
            'message_type': 'text',
          });
        } else if (messageType == MessageType.feed) {
          data.addAll({
            'feed_id': feedId,
            'message': 'feed',
            'message_type': 'feed',
          });
        }

        incrementUnSeenMessageCount();

        reference
            .child(dataNode)
            .child(chatRoomModel.id)
            .child(messageId)
            .set(data);
        reference
            .child(detailsNode)
            .child(chatRoomModel.id)
            .child('last_message')
            .set(data);

        createMessageRoom(chatRoomMap);
        sendNotificationRequest(
            messageTypeString:
            messageType == MessageType.text ? 'text' : 'feed',
            message: textEditingController.text);
        // }
        if (messageType == MessageType.text) {
          textEditingController.text = '';
          emit(TextMessageState(
              message: '',
              messageRoomUserStatus: messageRoomUserStatus,
              messageRoomStatus: messageRoomStatus,
              userRole: userRole));
        }
      } catch (e) {
        emit(ErrorMessageState(e: e));
      }
    } else if (messageType == MessageType.forward) {
      try {
        String messageId = reference
            .push()
            .key;

        Map<String, dynamic> data = {
          'sender_id': AppData().userId,
          'created_at': ServerValue.timestamp,
          'forward_message': forwardBody,
          'message_type':'forwarded',
          'id': messageId,
          'seen_status': seenStatus
        };

        incrementUnSeenMessageCount();

        reference
            .child(dataNode)
            .child(chatRoomModel.id)
            .child(messageId)
            .set(data);
        reference
            .child(detailsNode)
            .child(chatRoomModel.id)
            .child('last_message')
            .set(data);

        createMessageRoom(chatRoomMap);
        sendNotificationRequest(
            messageTypeString: forwardBody['message_type'],
            message: textEditingController.text);
      } catch (e) {
        emit(ErrorMessageState(e: e));
      }
    }
  }

  deleteMessage(MessageModel messageModel) async {
    if (messageModel.messageType == MessageType.feed) {
      deleteFeedAndRemoveAll(messageModel.feedId);
    }
    if (messageModel.messageType != MessageType.feed &&
        messageModel.messageType != MessageType.text &&
        messageModel.messageType != MessageType.forward &&
        messageModel.messageType != MessageType.loading) {
      var body =
      await deleteDataRequest(address: 'media/${messageModel.mediaId}');
    }
    reference
        .child(dataNode)
        .child(chatRoomModel.id)
        .child(messageModel.id)
        .child('message_type')
        .set('deleted');
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('last_message')
        .child('message_type')
        .set('deleted');
  }


  createMessageRoom(Map<String, dynamic> chatRoomMap) {
    if (messageRoomStatus == MessageRoomStatus.NotCreated) {
      // print('newchatRoomId ${chatRoomModel.id}');
      reference.child(detailsNode).child(chatRoomModel.id).update(chatRoomMap);

      reference
          .child('Users')
          .child(chatRoomModel.messengerId)
          .child(detailsNode)
          .child(chatRoomModel.id)
          .set(chatRoomModel.id);
      reference
          .child('Users')
          .child(AppData().userId)
          .child(detailsNode)
          .child(chatRoomModel.id)
          .set(chatRoomModel.id);
      messageRoomStatus = MessageRoomStatus.Active;

      getMembers();
    }
  }

  editMessageRoom() {
    Map<String, dynamic> map = {
      'name': messageRoomName,
    };

    map.addAll(
        {'description': description
            .trim()
            .isNotEmpty ? description : null});

    print('edit message room $map');
    print('edit message room $detailsNode  ${chatRoomModel.id}');
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('info')
        .update(map);
  }

  deleteMessageRoom() {
    Map<String, dynamic> map = {
      'status': 'deleted',
      'delete_date': ServerValue.timestamp,
    };
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('info')
        .update(map);
  }

  sendNotificationRequest(
      {@required String messageTypeString, @required String message}) async {
    print('sendNotificationRequest');

    Map<String, dynamic> requestBody = {
      'type': 'message_room',
      'message_room_type': chatRoomModel.messageRoomType,
      'message': messageTypeString == 'text' ? message : messageTypeString,
      'sender_id': AppData().userId.toString(),
      'message_room_id': chatRoomModel.id,
      'user_ids': userContactModels.map((e) => e.id).toList(),
    };
    print(requestBody);
    try {
      var body = await postDataRequest(
          myBody: requestBody, address: 'firebase/notification');
    } catch (e) {
      print(e);
    }
  }

  Future<void> reloadStates() async {
    emit(InfoDetails(chatRoomModel: chatRoomModel));
    await Future.delayed(Duration(microseconds: 1));
    emit(MembersState(userContactModels: userContactModels));
    await Future.delayed(Duration(microseconds: 1));
    emit(TextMessageState(
        userRole: userRole,
        messageRoomStatus: messageRoomStatus,
        message: textEditingController.text,
        messageRoomUserStatus: messageRoomUserStatus));
  }

  changeGroupIcon(BuildContext context) async {
    try {
      File groupIcon;
      groupIcon = await selectImage(
        imageFile: groupIcon,
        context: context,
        aspectRatios: [CropAspectRatioPreset.square],
      );
      if (chatRoomModel.imageId != null) {
        try {
          var body =
          deleteDataRequest(address: ' media/${chatRoomModel.imageId}');
        } catch (e) {}
      }
      try {
        Map<String, String> requestBody = {};

        var body = await postImageDataRequest(
            imageAddress: 'images',
            address: 'media',
            imageFile: groupIcon,
            myBody: requestBody);
        if (body['url'] != null) {
          var mediaBody = {
            'icon_url': body['url'].toString(),
            'icon_id': body['id'].toString(),
          };
          chatRoomModel.imageId = body['id'].toString();
          chatRoomModel.imageUrl =
              Urls().serverAddress + body['url'].toString();
          emit(InfoDetails(chatRoomModel: chatRoomModel));
          reference
              .child(detailsNode)
              .child(chatRoomModel.id)
              .child('info')
              .update(mediaBody);
        } else {
          throw Exception('Image Uploading  Failed');
        }
      } catch (e) {
        emit(ErrorMessageState(e: e));
      }
    } catch (e) {
      emit(ErrorMessageState(e: e));
      print(e);
    }
  }

  makeAsAdmin(String userId) {
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('members')
        .child(userId)
        .child('user_type')
        .set('admin');
  }

  dismissAsAdmin(String userId) {
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('members')
        .child(userId)
        .child('user_type')
        .set('user');
  }

  removeUserFromMessageRoom(String userId) {
    if (chatRoomModel.messageRoomType == 'group') {
      Map<String, dynamic> map = {
        'status': 'removed',
        'removed_date': ServerValue.timestamp,
      };
      reference
          .child(detailsNode)
          .child(chatRoomModel.id)
          .child('members')
          .child(userId)
          .update(map);
    } else {
      Map<String, dynamic> map = {
        'status': 'removed',
        'removed_date': ServerValue.timestamp,
      };
      reference
          .child(detailsNode)
          .child(chatRoomModel.id)
          .child('members')
          .child(userId)
          .update(map);
      reference
          .child('Users')
          .child(userId)
          .child('ChannelRooms')
          .child(chatRoomModel.id)
          .remove();
    }
  }

  addUserFromMessageRoom(String userId) {
    Map<String, dynamic> map = {
      'user_type': 'user',
      'joining_date': ServerValue.timestamp,
      'status': 'active'
    };
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('members')
        .child(userId)
        .update(map);
    reference
        .child('Users')
        .child(userId)
        .child(chatRoomModel.messageRoomType == 'group'
        ? 'ChatRooms'
        : 'ChannelRooms')
        .child(chatRoomModel.id)
        .set(chatRoomModel.id);
  }

  deleteUserFromGroup() {
    reference
        .child('Users')
        .child(AppData().userId)
        .child('ChatRooms')
        .child(chatRoomModel.id)
        .remove();
  }

  Future<void> messageRoomNameChanged(String value) async {
    messageRoomName = value;
    print('group name changed $value');
    emit(MessageRoomNameChanged(value: value));
  }

  Future<void> descriptionChanged(String value) async {
    description = value;
    print('group name changed $value');
  }



  showAndHideEmoji() {
    emojiShowing=!emojiShowing;

    emit(TextMessageState(
        message: textEditingController.text,
        messageRoomUserStatus: messageRoomUserStatus,
        messageRoomStatus: messageRoomStatus,
        userRole: userRole));
  }
  onEmojiSelected(Emoji emoji) {
    textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  onBackspacePressed() {
    textEditingController
      ..text = textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }
  selectUnselectMessage(MessageModel messageModel){
    messageModels[messageModels.map((e) => e.id).toList().indexOf(messageModel.id)].isSelected=! messageModel.isSelected;
    emit(LoadList(messageModels: messageModels));
  }
}
