import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queschat/constants/styles.dart';

class ImageViewer extends StatefulWidget {
  String imageUrl;
  File imageFile;

  ImageViewer({Key key, this.imageUrl, this.imageFile}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool isAppBarVisible = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: isAppBarVisible
            ? AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  // Status bar color
                  statusBarColor: Colors.transparent,

                  // systemStatusBarContrastEnforced: true,
                  // Status bar brightness (optional)
                  statusBarIconBrightness: Brightness.light,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),

                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: Colors.black45,
                shadowColor: Colors.transparent,
              )
            : null,
        body: GestureDetector(
          onTap: () {
            isAppBarVisible = !isAppBarVisible;
            if (isAppBarVisible) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
            } else {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: []);
            }
            setState(() {});
            // showBackPressScreen(buildContext: context);
          },
          child: InteractiveViewer(
            panEnabled: true,
            // boundaryMargin: EdgeInsets.all(50),

            minScale: 1,
            maxScale: 3,

            child: widget.imageUrl != null
                ? CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: widget.imageUrl,
                    errorWidget: (context, url, error) => Icon(Icons.error,color: AppColors.IconColor),
                  )
                : Image.file(
                    widget.imageFile,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}
//
// Future<void> showBackPressScreen({@required BuildContext buildContext})  {
//
//    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//                   overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//               SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//                   statusBarColor: Colors.black45,
//                   statusBarIconBrightness: Brightness.light));
//   showDialog(
//     context: buildContext,
//     barrierDismissible: false,
//
//     barrierColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return Scaffold(
//         backgroundColor: Colors.transparent,
//         drawerScrimColor: Colors.transparent,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//               Navigator.of(context).pop();
//             },
//           ),
//           backgroundColor: Colors.black45,
//           shadowColor: Colors.transparent,
//         ),
//         body: InkWell(
//           onTap: () {
//             Navigator.of(context).pop();
//
//           },
//         ),
//       );
//     },
//   ).then((value) =>
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []));
// }
