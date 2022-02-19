import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queschat/components/custom_web_view.dart';
import 'package:queschat/components/video_player.dart';
import 'package:queschat/constants/styles.dart';

import 'package:queschat/models/message_model.dart';

class MultiFormatFileViewer extends StatefulWidget {
  MessageModel messageModel;

  MultiFormatFileViewer({Key key, this.messageModel}) : super(key: key);

  @override
  State<MultiFormatFileViewer> createState() => _MultiFormatFileViewerState();
}

class _MultiFormatFileViewerState extends State<MultiFormatFileViewer> {
  bool isBackButtonVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
        statusBarIconBrightness: Brightness.light));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.White,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Center(
          child: widget.messageModel.messageType == MessageType.unsupported
              ? Text('This file is not supported')
              : widget.messageModel.messageType == MessageType.image
                  ? Image.network(
                      widget.messageModel.mediaUrl,
                      fit: BoxFit.fill,
                    )
                  : widget.messageModel.messageType == MessageType.video ||
                          widget.messageModel.messageType == MessageType.audio
                      ? CustomVideoPlayer(
                          url: widget.messageModel.mediaUrl,
                        )
                      : CustomWebView(
                          file: widget.messageModel.mediaUrl,
                        ),
        ),
      ),
    );
  }
}

// Future<void> showBackPressScreen({@required BuildContext buildContext}) async {
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//       overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.black54,
//       statusBarIconBrightness: Brightness.light));
//   showDialog(
//     context: buildContext,
//     barrierColor: Colors.transparent,
//     builder: (BuildContext context) {
//
//
//       return Scaffold(
//         backgroundColor: Colors.transparent,
//         drawerScrimColor: Colors.transparent,
//         appBar: AppBar(
//
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: AppColors.White,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//               Navigator.of(context).pop();
//             },
//           ),
//           backgroundColor: Colors.black54,
//           shadowColor: Colors.transparent,
//         ),
//         body: InkWell(
//           onTap: () {
//
//             Navigator.of(context).pop();
//             SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//
//           },
//         ),
//       );
//
//
//
//     },
//   );
// }
