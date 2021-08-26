import 'package:flutter/material.dart';
import 'package:queschat/components/channel_suggestion_adapter.dart';
import 'package:queschat/components/chat_list_adapter.dart';

class AllChats extends StatefulWidget {
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  List<ChatAndChannelGS> chatAndChannelGSs = new List<ChatAndChannelGS>();
  List<ChannelGS> channelGSs=new List<ChannelGS>();

  @override
  Widget build(BuildContext context) {

    ChatListGS emptyChatListGS=new ChatListGS("","", "", "", "", "");
    ChannelSuggestionGS emptyChannelSuggestionGS=new ChannelSuggestionGS("",channelGSs);
    channelGSs.add(new ChannelGS("https://d1csarkz8obe9u.cloudfront.net/posterpreviews/futuristic-gamer-youtube-channel-art-banner-design-template-9c0720c5b05bb1bbc4e3c01aab8ee398_screen.jpg?ts=1568041588", "channelDescription kfjdghkdf uifhgifdhg fughdfiu kjhfdgjdfg iukjdg diun ddiunmg u ujndgbudg uijdf gu iunfdkg sbi dsig isdgkj", "channelName"));
    channelGSs.add(new ChannelGS("https://d1csarkz8obe9u.cloudfront.net/posterpreviews/futuristic-gamer-youtube-channel-art-banner-design-template-9c0720c5b05bb1bbc4e3c01aab8ee398_screen.jpg?ts=1568041588", "channelDescription", "channelName"));
    channelGSs.add(new ChannelGS("https://d1csarkz8obe9u.cloudfront.net/posterpreviews/futuristic-gamer-youtube-channel-art-banner-design-template-9c0720c5b05bb1bbc4e3c01aab8ee398_screen.jpg?ts=1568041588", "channelDescription", "channelName"));
    // chatAndChannelGSs.add(new ChatAndChannelGS("Chat",emptyChatListGS,emptyChannelSuggestionGS));
    chatAndChannelGSs.add(new ChatAndChannelGS("Chat",new ChatListGS("single",
        "Sophia Valdern",
        "Can you help me to solve..",
        "1h  ago",
        "12",
        "http://img-cdn.tid.al/o/6dc39fec4427c4f9f759c1f2c44137bec7366e4c.png"),emptyChannelSuggestionGS));
    chatAndChannelGSs.add(new ChatAndChannelGS("Chat",new ChatListGS("group",
        "#Astrophysics",
        "Can you help me to solve..",
        "1h  ago",
        "11",
        "https://i.pinimg.com/474x/56/30/54/5630545479534d80619662340e800839--the-beards-old-mans.jpg"),emptyChannelSuggestionGS));
    chatAndChannelGSs.add(new ChatAndChannelGS("Chat",new ChatListGS("single",
        "Jacob Jyane",
        "Are you ready for the lecture ...",
        "15m  ago",
        "1245",
        "https://images.unsplash.com/photo-1534564237113-5ecbde66661c?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80"),emptyChannelSuggestionGS));
    chatAndChannelGSs.add(new ChatAndChannelGS("Chat",new ChatListGS("single",
        "Isabella Fierda",
        "Are you ready for the lecture ...",
        "15m  ago",
        "1465",
        "https://images.unsplash.com/photo-1534564237113-5ecbde66661c?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80"),emptyChannelSuggestionGS));

    // chatAndChannelGSs.add(new ChatAndChannelGS("Channel",emptyChatListGS,new ChannelSuggestionGS("Physics",channelGSs)));
    chatAndChannelGSs.add(new ChatAndChannelGS("Chat",new ChatListGS("single",
        "Emma Kiw",
        "Are you ready for the lecture ...",
        "15m  ago",
        "134",
        "https://images.unsplash.com/photo-1534564237113-5ecbde66661c?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80"),emptyChannelSuggestionGS));
        chatAndChannelGSs.add(new ChatAndChannelGS("Chat",new ChatListGS("single",
        "Nourdeen Shah",
        "Are you ready for the lecture ...",
        "15m  ago",
        "1000",
        "https://images.unsplash.com/photo-1534564237113-5ecbde66661c?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80"),emptyChannelSuggestionGS));
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: chatAndChannelGSs.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatAndChannelAdapter(chatAndChannelGSs[index]);
          }),
    );
  }
}
