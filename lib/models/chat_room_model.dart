import 'package:queschat/models/message_model.dart';

class ChatRoomModel{
  String name,id,imageUrl,imageId,mobile,description;

  int unreadMessageCount;
  DateTime lastMessageTime;
  DateTime createdTime;
  bool isSingleChat;
  MessageModel lastMessage;
  String messengerId;
  String messageRoomType;
  bool isMessageRoomActive;


  ChatRoomModel({this.id,this.isMessageRoomActive,this.messengerId,this.messageRoomType,this.description,this.name,this.imageUrl,this.lastMessage,this.unreadMessageCount,this.createdTime,this.isSingleChat,this.lastMessageTime,this.mobile,this.imageId});
}