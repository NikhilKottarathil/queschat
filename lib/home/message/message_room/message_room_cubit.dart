import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/models/user_contact_model.dart';
import 'package:queschat/models/value_model.dart';
import 'package:queschat/router/app_router.dart';

class MessageRoomCubit extends Cubit<MessageRoomState> {
  String parentPage;
  ChatRoomModel chatRoomModel;

  List<UserContactModel> userContactModels = [];

  DatabaseReference reference = FirebaseDatabase.instance.reference();
  TextEditingController textEditingController = TextEditingController();

  List<String> ids = [];
  List<MessageModel> messageModels = [];

  DateTime todayDateTime = DateTime.now();

  DateTime messageLoadedDateTime = DateTime.now();

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

  MessageRoomCubit({@required this.parentPage, @required this.chatRoomModel})
      : super(InitialState()) {
    todayDateTime = DateTime(todayDateTime.year, todayDateTime.month,
        todayDateTime.day, 0, 0, 0, 0, 0);
    messageLoadedDateTime = todayDateTime;
    if (parentPage == 'channelRoomsView' ||
        parentPage == 'dynamicLinkChannel' ||
        parentPage == 'newChannelCreateView' ||
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
        .child(dataNode)
        .child(chatRoomModel.id)
        .child(getDayNode(todayDateTime))
        .orderByChild('createAt')
        .onValue
        .listen((event) {
      reference
          .child(detailsNode)
          .child(chatRoomModel.id)
          .child('un_seen_message_count')
          .child(AppData().userId)
          .set(0);
      Map<dynamic, dynamic> data = event.snapshot.value;
      if (data != null) {
        if (!ids.contains(getDisplayDate(todayDateTime))) {
          messageModels.insert(
              0,
              MessageModel(
                  messageType: MessageType.date,
                  message: getDisplayDate(todayDateTime),
                  createdAt: todayDateTime));
          ids.insert(0, getDisplayDate(todayDateTime));
          // if (chatRoomModel.messageRoomType == 'group') {
          //   if (messageRoomUserStatus == MessageRoomUserStatus.Removed) {
          //     if (todayDateTime.millisecondsSinceEpoch <
          //         removedDateTime.millisecondsSinceEpoch && todayDateTime.millisecondsSinceEpoch >
          //         joiningDateTime.millisecondsSinceEpoch) {
          //       messageModels.insert(
          //           0,
          //           MessageModel(
          //               messageType: MessageType.date,
          //               message: getDisplayDate(todayDateTime),
          //               createdAt:todayDateTime ));
          //       ids.insert(0, getDisplayDate(todayDateTime));
          //     }
          //   } else
          //     if (todayDateTime.millisecondsSinceEpoch >
          //         joiningDateTime.millisecondsSinceEpoch) {
          //       messageModels.insert(
          //           0,
          //           MessageModel(
          //               messageType: MessageType.date,
          //               message: getDisplayDate(todayDateTime),
          //               createdAt: todayDateTime));
          //       ids.insert(0, getDisplayDate(todayDateTime));
          //     }
          //
          // } else {
          //   messageModels.insert(
          //       0,
          //       MessageModel(
          //           messageType: MessageType.date,
          //           message: getDisplayDate(todayDateTime),
          //           createdAt:todayDateTime));
          //   ids.insert(0, getDisplayDate(todayDateTime));
          // }
        }

        data.forEach((id, value) {
          MessageModel messageModel = convertDataToMessageModel(value);

          if (!ids.contains(id)) {
            messageModels.insert(0, messageModel);
            ids.insert(0, id);
          } else {
            messageModels[ids.indexOf(id)] = messageModel;
          }

          // if (chatRoomModel.messageRoomType == 'group') {
          //   if (messageRoomUserStatus == MessageRoomUserStatus.Removed) {
          //     if (messageModel.createdAt.millisecondsSinceEpoch <
          //             removedDateTime.millisecondsSinceEpoch &&
          //         todayDateTime.millisecondsSinceEpoch >
          //             joiningDateTime.millisecondsSinceEpoch) {
          //       if (!ids.contains(id)) {
          //         messageModels.insert(0, messageModel);
          //         ids.insert(0, id);
          //       } else {
          //         messageModels[ids.indexOf(id)] = messageModel;
          //       }
          //     }
          //   } else {
          //     if (messageModel.createdAt.millisecondsSinceEpoch >
          //         joiningDateTime.millisecondsSinceEpoch) {
          //       if (!ids.contains(id)) {
          //         messageModels.insert(0, messageModel);
          //         ids.insert(0, id);
          //       } else {
          //         messageModels[ids.indexOf(id)] = messageModel;
          //       }
          //     }
          //   }
          // } else {
          //   //the code here
          // }
        });
      }
      updateMessageList();
    });
  }

  loadMoreMessages() async {
    messageLoadedDateTime = messageLoadedDateTime.subtract(Duration(days: 1));
    if (messageLoadedDateTime.millisecondsSinceEpoch >=
        (chatRoomModel.createdTime.millisecondsSinceEpoch - (86400000 * 1))) {
      if (ids.length > 25) {
        emit(LoadMoreState());
      }
      await reference
          .child(dataNode)
          .child(chatRoomModel.id)
          .child(getDayNode(messageLoadedDateTime))
          .orderByChild('createAt')
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> data = snapshot.value;
        if (data != null) {
          List<MessageModel> tempModels = [];
          data.forEach((id, value) {
            MessageModel messageModel = convertDataToMessageModel(value);
            if (!ids.contains(id)) {
              tempModels.add(messageModel);
              ids.add(id);
            } else {
              tempModels[ids.indexOf(id)] = messageModel;
            }
            // if (chatRoomModel.messageRoomType == 'group') {
            //   if (messageRoomUserStatus == MessageRoomUserStatus.Removed) {
            //     if (messageModel.createdAt.millisecondsSinceEpoch <
            //         removedDateTime.millisecondsSinceEpoch &&
            //         messageModel.createdAt.millisecondsSinceEpoch >
            //             joiningDateTime.millisecondsSinceEpoch) {
            //       if (!ids.contains(id)) {
            //         tempModels.add(messageModel);
            //         ids.add(id);
            //       } else {
            //         tempModels[ids.indexOf(id)] = messageModel;
            //       }
            //     }
            //   } else if (messageModel.createdAt.millisecondsSinceEpoch >
            //       joiningDateTime.millisecondsSinceEpoch) {
            //     if (!ids.contains(id)) {
            //       tempModels.add(messageModel);
            //       ids.add(id);
            //     } else {
            //       tempModels[ids.indexOf(id)] = messageModel;
            //     }
            //   }
            // } else {
            //
            // }

            // sortChartData();
          });
          // List<MessageModel> models = tempModels.reversed;
          messageModels.addAll(tempModels.reversed);

          if (tempModels.isNotEmpty) {
            if (!ids.contains(getDisplayDate(messageLoadedDateTime))) {
              messageModels.add(MessageModel(
                  messageType: MessageType.date,
                  message: getDisplayDate(messageLoadedDateTime),
                  createdAt: DateTime(
                      messageLoadedDateTime.year,
                      messageLoadedDateTime.month,
                      messageLoadedDateTime.day,
                      0,
                      0,
                      0,
                      0,
                      0)));
              ids.add(getDisplayDate(messageLoadedDateTime));
            }
          }
        }
      });
      updateMessageList();
    }

    // if ((messageLoadedDateTime.millisecondsSinceEpoch >=
    //     (joiningDateTime.millisecondsSinceEpoch - (86400000 * 1)) &&
    //     chatRoomModel.messageRoomType == 'group') ||
    //     chatRoomModel.messageRoomType != 'group')
  }

  updateMessageList() {
    emit(LoadList().copyWith(messageModels: messageModels));
    if (ids.length < 25) {
      print('load messages');

      // loadMoreMessages();
      print('load messages complete');
    } else {
      print('ids.length is high');
    }
  }

  MessageModel convertDataToMessageModel(Map<dynamic, dynamic> value) {
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
      messageType = MessageType.deleted;
    }

    List<SeenStatus> seenStatuses = [];
    MessageStatus seenStatus = MessageStatus.sent;
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
                .child(getDayNode(messageLoadedDateTime))
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
    MessageModel messageModel = new MessageModel(
        senderID: value['sender_id'].toString(),
        messageType: messageType,
        message: value['message'],
        mediaUrl: value['media'] != null
            ? Urls().serverAddress + value['media']
            : null,
        id: value['id'],
        feedId: feedId,
        seenStatues: seenStatuses,
        messageStatus: seenStatus,
        isSingleMessage: chatRoomModel.isSingleChat,
        createdAt: DateTime.fromMillisecondsSinceEpoch(value['created_at']));
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
    reference.child('Presence/$messengerId').onValue.listen((event) async {
      print('statusAndLastSeen2');

      if (event.snapshot.value != null) {
        print('statusAndLastSeen3');
        if (event.snapshot.value == 'online') {
          lastSeenAndStatus = event.snapshot.value;
          emit(StatusAndLastSeenState(statusAndLastSeen: event.snapshot.value));
        } else {
          lastSeenAndStatus =
              'last seen at ${getDisplayDateOrTime(DateTime.fromMillisecondsSinceEpoch(event.snapshot.value))}';
          emit(StatusAndLastSeenState(
              statusAndLastSeen:
                  'last seen at ${getDisplayDateOrTime(DateTime.fromMillisecondsSinceEpoch(event.snapshot.value))}'));
        }
      }
    });
    print('statusAndLastSeen');

    // return statusAndLastSeen;
  }

  listenTypingUsers() async {
    reference
        .child('TypingListener')
        .child(chatRoomModel.id)
        .child('is_typing')
        .onValue
        .listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value;
      List<ValueModel> valueModels = [];

      if (data != null) {
        data.forEach((key, value) async {
          if (AppData().userId != key) {
            // {
            valueModels.add(ValueModel(
                // key: authRepository.getNameOfSelectedUserByContact(key),
                key: key,
                value: value));
          }
          print('value models length 00  ${valueModels.length}');
        });
        emit(TypingUserState(valueModels: valueModels));

        print('value models length ${valueModels.length}');
      } else {
        emit(TypingUserState(valueModels: valueModels));
      }
    });
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

            if (isInInitialState) {
              getLiveChat();
            }
          }
          if (mapEntry.value['status'].toString() == 'active') {
            tempUserContactModels.add(
                await authRepository.getDetailsOfSelectedUser(
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
        emit(MembersState(userContactModels: userContactModels));
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
          String messengerId = map['messenger_id'];
          int unSeenMessageCount = 0;
          String imageUrl = map['icon_url'] != null
              ? Urls().serverAddress + map['icon_url'].toString()
              : null;
          String imageId =
              map['icon_id'] != null ? map['icon_id'].toString() : null;
          bool isSingleChat =
              map['is_single_chat'].toString() == 'True' ? true : false;
          if (isSingleChat) {
            UserContactModel userContactModel = await authRepository
                .getDetailsOfSelectedUser(messengerId, 'any');
            ChatRoomModel tempChatRoomModel = new ChatRoomModel(
                id: chatRoomModel.id.toString(),
                name: userContactModel.name,
                messengerId: messengerId,
                imageUrl: userContactModel.profilePic,
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
          emit(InfoDetails(chatRoomModel: chatRoomModel));
          if (chatRoomModel.messageRoomType == 'chat') {
            listenUserPresenceStatus(chatRoomModel.messengerId);
          }

          getMembers();

          listenTypingUsers();
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

  sendMessage(
      {MessageType messageType, List<File> files, String feedId}) async {
    String message = textEditingController.text;
    Map<String, dynamic> chatRoomMap = {};
    Map<String, String> seenStatus = {};

    if (messageRoomStatus == MessageRoomStatus.NotCreated) {
      String messageRoomId = reference.push().key;
      chatRoomModel.id = messageRoomId;

      Map<String, dynamic> unSeenMessageCountMap = {};
      Map<String, dynamic> memberMap = {};

      memberMap.addAll({
        chatRoomModel.messengerId: {
          'user_type': 'owner',
          'joining_date': DateTime.now().millisecondsSinceEpoch,
          'status': 'active'
        }
      });
      unSeenMessageCountMap.addAll({chatRoomModel.messengerId: 0});
      seenStatus.addAll({chatRoomModel.messengerId: 'sent'});

      memberMap.addAll({
        AppData().userId: {
          'user_type': 'owner',
          'joining_date': DateTime.now().millisecondsSinceEpoch,
          'status': 'active'
        }
      });
      unSeenMessageCountMap.addAll({AppData().userId: 0});
      seenStatus.addAll({AppData().userId: 'sent'});

      Map<String, dynamic> infoMap = {
        'created_time': DateTime.now().millisecondsSinceEpoch,
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
          String messageId = reference.push().key;
          messageModels.insert(
              0,
              MessageModel(
                  id: messageId,
                  createdAt: DateTime.now(),
                  messageType: MessageType.loading));
          ids.insert(0, messageId);
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
              'created_at': DateTime.now().millisecondsSinceEpoch,
              'id': messageId,
              'message_type': messageType == MessageType.voice_note
                  ? 'voice_note'
                  : getFileTypeFromPath(file.path),
              'seen_status': seenStatus
            };
            String dayNode = getCurrentDayNode();
            incrementUnSeenMessageCount();

            reference
                .child(dataNode)
                .child(chatRoomModel.id)
                .child(dayNode)
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
        String messageId = reference.push().key;

        Map<String, dynamic> data = {
          'sender_id': AppData().userId,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'id': messageId,
          'seen_status': seenStatus
        };
        if (messageType == MessageType.text) {
          data.addAll({
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

        String dayNode = getCurrentDayNode();
        incrementUnSeenMessageCount();

        reference
            .child(dataNode)
            .child(chatRoomModel.id)
            .child(dayNode)
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
    }
  }

  deleteMessage(MessageModel messageModel) {
    if (messageModel.messageType == MessageType.feed) {
      feedRepository.deleteFeed(feedId: messageModel.feedId);
      if (homeFeedBloc.state.feedIds.contains(messageModel.feedId)) {
        homeFeedBloc.add(DeleteFeed(feedId: messageModel.feedId));
      }
      if (savedFeedBloc.state.feedIds.contains(messageModel.feedId)) {
        savedFeedBloc.add(DeleteFeed(feedId: messageModel.feedId));
      }
      if (myFeedsBloc.state.feedIds.contains(messageModel.feedId)) {
        myFeedsBloc.add(DeleteFeed(feedId: messageModel.feedId));
      }
    }
    reference
        .child(dataNode)
        .child(chatRoomModel.id)
        .child(getDayNode(messageModel.createdAt))
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

      getLiveChat();
      listenTypingUsers();
    }
  }

  editMessageRoom() {
    Map<String, dynamic> map = {
      'name': messageRoomName,
    };

    map.addAll(
        {'description': description.trim().isNotEmpty ? description : null});

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
      'delete_date': DateTime.now().millisecondsSinceEpoch,
    };
    reference
        .child(detailsNode)
        .child(chatRoomModel.id)
        .child('info')
        .update(map);
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
        'removed_date': DateTime.now().millisecondsSinceEpoch,
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
        'removed_date': DateTime.now().millisecondsSinceEpoch,
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
      'joining_date': DateTime.now().millisecondsSinceEpoch,
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

  Future<void> messageRoomNameChanged(String value) async {
    messageRoomName = value;
    print('group name changed $value');
    emit(MessageRoomNameChanged(value: value));
  }

  Future<void> descriptionChanged(String value) async {
    description = value;
    print('group name changed $value');
  }
}
