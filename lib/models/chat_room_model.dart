import 'package:queschat/models/message_model.dart';

class ChatRoomModel {
  String name, id, imageUrl, imageId, mobile, description;

  int unreadMessageCount;
  DateTime lastMessageTime;
  DateTime createdTime;
  bool isSingleChat;
  MessageModel lastMessage;
  String messengerId;
  String messageRoomType;
  bool isMessageRoomActive;
  bool isSelected;
  int membersCount;

  ChatRoomModel.clone(ChatRoomModel source)
      : this.name = source.name,
        this.id = source.id,
        this.membersCount = source.membersCount,
        this.imageUrl = source.imageUrl,
        this.imageId = source.imageId,
        this.mobile = source.mobile,
        this.description = source.description,
        this.unreadMessageCount = source.unreadMessageCount,
        this.lastMessageTime = source.lastMessageTime,
        this.createdTime = source.createdTime,
        this.isSingleChat = source.isSingleChat,
        this.lastMessage = source.lastMessage,
        this.messengerId = source.messengerId,
        this.messageRoomType = source.messageRoomType,
        this.isMessageRoomActive = source.isMessageRoomActive,
        this.isSelected = source.isSelected;

  ChatRoomModel(
      {this.id,
      this.isSelected = false,
      this.isMessageRoomActive,
      this.membersCount,
      this.messengerId,
      this.messageRoomType,
      this.description,
      this.name,
      this.imageUrl,
      this.lastMessage,
      this.unreadMessageCount,
      this.createdTime,
      this.isSingleChat,
      this.lastMessageTime,
      this.mobile,
      this.imageId});
}
