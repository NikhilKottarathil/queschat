import 'package:flutter/material.dart';
import 'package:queschat/components/chat_adapter.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';

class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  List<ChatGS> chatGSs=new List<ChatGS>();
  @override
  Widget build(BuildContext context) {
    chatGSs.add(new ChatGS(true,"Receive","Lorem ipsum dolor sit amet, consetetur sadipscing elitr","Charu","1h ago"));
    chatGSs.add(new ChatGS(true,"Send","Lorem ipsum dolor sit amet","Amal"," 45 min ago"));
    chatGSs.add(new ChatGS(true,"Receive","Lorem ipsum dolor sit amet","Cahru","44 min ago"));
    chatGSs.add(new ChatGS(true,"Send","Lorem ipsum dolor sit amet, consetetur sadipscing elitr","Amal","30 min ago"));
    return Scaffold(
      appBar: appBarForProfile(context, "Frenxc Braf"),
      body: SingleChildScrollView(
        child: Column(

          children: [

            Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*.8,
                child: ListView.builder(
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: chatGSs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatAdapter(chatGSs[index]);
                    })          ),
            // TextField(
            //   decoration: InputDecoration(
            //       hintText: "Write your message…",
            //       prefixIcon: IconButton(
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.attach_file,
            //           color: AppColors.IconColor,
            //         ),
            //       ),
            //       suffixIcon: IconButton(
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.send,
            //           color: AppColors.PrimaryColor,
            //         ),
            //       )),
            // ),
          ],
        ),
      ),

    );
  }
}
