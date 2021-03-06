// import 'package:flutter/material.dart';
// import 'package:queschat/constants/styles.dart';
//
// class ChatAdapter extends StatelessWidget {
//   ChatGS chatGS;
//
//   ChatAdapter(this.chatGS);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width set up issue pending
//       padding: EdgeInsets.all(15),
//       margin: EdgeInsets.only(
//           top: 10,
//           bottom: 10,
//           left: chatGS.type == "Send"
//               ? MediaQuery.of(context).size.width * .25
//               : 0,
//           right: chatGS.type != "Send"
//               ? MediaQuery.of(context).size.width * .25
//               : 0),
//       width: 100,
//       decoration: BoxDecoration(
//           color: chatGS.type != "Send"
//               ? AppColors.BorderColor
//               : Colors.transparent,
//           border: Border.all(color: AppColors.BorderColor),
//           borderRadius: BorderRadius.only(
//               bottomLeft: chatGS.type != "Send"
//                   ? Radius.circular(0)
//                   : Radius.circular(30),
//               bottomRight: chatGS.type == "Send"
//                   ? Radius.circular(0)
//                   : Radius.circular(30),
//               topRight: Radius.circular(30),
//               topLeft: Radius.circular(30))),
//       child: Column(
//         children: [
//           chatGS.isSingleChat?Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 chatGS.userName,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(color: AppColors.SecondaryColor),
//               )):Container(),
//           Container(padding: EdgeInsets.all(10), child: Text(chatGS.message)),
//           Align(
//               alignment: Alignment.bottomRight,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     chatGS.time,
//                     style: TextStyle(color: AppColors.TextTertiary),
//                   ),
//                   Icon(Icons.check)
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
// }
//
class ChatGS {
  String message, type, userName, time;
  bool isSingleChat;

  ChatGS(this.isSingleChat,this.type, this.message, this.userName, this.time);
}
