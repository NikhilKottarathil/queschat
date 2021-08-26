import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/components/channel_suggestion_adapter.dart';
import 'package:queschat/pages/chats.dart';
import 'package:queschat/pages/group_chat.dart';
import 'package:queschat/uicomponents/AppColors.dart';

class ChatAndChannelAdapter extends StatefulWidget {
  ChatAndChannelGS chatAndChannelGS;

  ChatAndChannelAdapter(this.chatAndChannelGS);

  @override
  _ChatAndChannelAdapterState createState() => _ChatAndChannelAdapterState();
}

class _ChatAndChannelAdapterState extends State<ChatAndChannelAdapter> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
            visible: widget.chatAndChannelGS.type == "Chat",
            child: ChatListAdapter(widget.chatAndChannelGS.chatListGS)),
        Visibility(
            visible: widget.chatAndChannelGS.type == "Channel",
            child: ChannelSuggestionAdapter(
                channelSuggestionGS:
                    widget.chatAndChannelGS.channelSuggestionGS)),
      ],
    );
  }
}

class ChatListAdapter extends StatelessWidget {
  Function singleClick, longClick;
  ChatListGS chatListGS;

  ChatListAdapter(this.chatListGS);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        chatListGS.type == "single"
            ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => Chats()))
            : Navigator.push(
                context, MaterialPageRoute(builder: (context) => GroupChat()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        color: Colors.white,
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * .1,
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(5),
                //
                // color: Colors.green,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(chatListGS.imageUrl.toString()),
                    // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRuJdRZgCdojDsemBQqxOAg9UAGIYem6inQg&usqp=CAU"),
                  ),
                ),
              )),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatListGS.name,
                  style: TextStyle(color: AppColors.TextSecondary),
                ),
                Text(chatListGS.message, style: TextStyle(color: Colors.black))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  chatListGS.receivedTime,
                  style: TextStyle(color: AppColors.IconColor),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    decoration: BoxDecoration(
                        color: AppColors.IconColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      chatListGS.messageCount,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
          // Divider(color: Colors./,)
        ]),
      ),
    );
  }
}

class ChatAndChannelGS {
  String type;
  ChannelSuggestionGS channelSuggestionGS;
  ChatListGS chatListGS;

  ChatAndChannelGS(this.type, this.chatListGS, this.channelSuggestionGS);
}

class ChatListGS {
  String type, name, message, receivedTime, messageCount, imageUrl;

  // Url url;

  ChatListGS(this.type, this.name, this.message, this.receivedTime,
      this.messageCount, this.imageUrl);
}
