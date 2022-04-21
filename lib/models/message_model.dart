

/// All possible message types.
enum MessageType { date, file, video,audio,voice_note,document, image, text, unsupported, deleted,loading,feed,forward,forward_deleted}

/// All possible statuses message can have.
enum MessageStatus { delivered, error, seen, sending, sent }

class ForwardMessage{
  String messageId,messageRoomId,messageRoomType,message;

  ForwardMessage({this.messageId, this.messageRoomId,
      this.messageRoomType});
}

class MessageModel  {
  String senderID, senderName, senderProfilePic;
  DateTime createdAt;
  String id, roomId;
  MessageType messageType;
  MessageStatus messageStatus;
  String message;
  String mediaUrl;
  String mediaId;
  String messageMediaType;
  String feedId;
  bool isSingleMessage;
  List<SeenStatus> seenStatues;
  ForwardMessage forwardMessage;
  bool isSelected;

  MessageModel({
    this.senderID,
    this.feedId,
    this.forwardMessage,
    this.mediaId,
    this.senderName,
    this.senderProfilePic,
    this.createdAt,
    this.isSelected=false,
    this.id,
    this.roomId,
    this.messageStatus,
    this.messageMediaType,
    this.mediaUrl,
    this.seenStatues,
    this.message, this.messageType, this.isSingleMessage
  });



}
class SeenStatus {
  String userName,userId;
  MessageStatus messageStatus;
  SeenStatus({this.messageStatus,this.userId,this.userName});
}

// getStringFromMessageType(MessageType messageType){
//   if()
// }


