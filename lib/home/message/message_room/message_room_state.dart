import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/models/message_model.dart';
import 'package:queschat/models/user_contact_model.dart';
enum MessageRoomStatus { NotCreated, Active, Deleted, NotExist }
enum MessageRoomUserStatus {NotJoined,Active, Removed,UnKnown}

abstract class MessageRoomState {}

class InitialState extends MessageRoomState {}
class LoadMoreState extends MessageRoomState {}
class ErrorMessageState extends MessageRoomState {
  Exception e;

  ErrorMessageState({this.e});
}

class InfoDetails extends MessageRoomState {
  ChatRoomModel chatRoomModel;

  InfoDetails({this.chatRoomModel});
}class MembersState extends MessageRoomState {
  List<UserContactModel> userContactModels;

  MembersState({this.userContactModels});
}

class StatusAndLastSeenState extends MessageRoomState {
  String statusAndLastSeen;

  StatusAndLastSeenState({this.statusAndLastSeen});
}
class MessageRoomNameChanged extends MessageRoomState {
  String value;

  MessageRoomNameChanged({this.value});
}

class TextMessageState extends MessageRoomState {
  String message;
  MessageRoomStatus messageRoomStatus;
  MessageRoomUserStatus messageRoomUserStatus;
  String userRole;

  TextMessageState({this.message,this.messageRoomStatus,this.messageRoomUserStatus,this.userRole});
}
class LoadList extends MessageRoomState {
  final List<MessageModel> messageModels;

  LoadList({this.messageModels});

  LoadList copyWith({
    List<MessageModel> messageModels,
  }) {
    return LoadList(
      messageModels: messageModels ?? this.messageModels,
    );
  }

  @override
  List<Object> get props => [messageModels];
}
class TypingUserState extends MessageRoomState {
  final List<String> typingUsers;

  TypingUserState({this.typingUsers});

  TypingUserState copyWith({
    List<String> typingUsers,
  }) {
    return TypingUserState(
      typingUsers: typingUsers ?? this.typingUsers,
    );
  }

  @override
  List<Object> get props => [typingUsers];
}
