import 'package:flutter/cupertino.dart';
import 'package:queschat/models/chat_room_model.dart';
import 'package:queschat/router/app_router.dart';

void checkAlreadyMessagedToUser({
  BuildContext context,
  String id,
  name,
  profilePic,
}) {
  if (allChatMessageRoomListBloc.state.models
      .any((element) => element.messengerId == id && element.isSingleChat)) {
    Navigator.pushReplacementNamed(
      context,
      '/messageRoom',
      arguments: {
        'parentPage': 'newChatExisting',
        'chatRoomModel': ChatRoomModel(
            id: allChatMessageRoomListBloc.state.models
                .singleWhere((element) =>
                    element.messengerId == id && element.isSingleChat)
                .id),
      },
    );
  } else {
    Navigator.pushReplacementNamed(
      context,
      '/messageRoom',
      arguments: {
        'parentPage': 'newChat',
        'chatRoomModel': ChatRoomModel(
            name: name,
            imageUrl: profilePic,
            messageRoomType: 'chat',
            isSingleChat: true,
            messengerId: id),
      },
    );
  }
}
