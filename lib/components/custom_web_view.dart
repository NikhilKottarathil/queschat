import 'dart:io';

import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  String file;

  CustomWebView({this.file});

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: WebView(

        javascriptMode: JavascriptMode.unrestricted,

       onWebResourceError: (value){
         print('webview on  onWebResourceError $value');

       },
        onProgress: (value){
          print('webview on  onProgress $value');
        },
        onPageStarted: (value){
          print('webview on  onPageStarted $value');

        },
       onWebViewCreated: (value){
         print('webview on  onWebViewCreated $value');

       },
        onPageFinished: (value){
          print('webview on  onPageFinished $value');

        },

        backgroundColor: AppColors.White,
        initialUrl: 'https://docs.google.com/viewer?url=${widget.file}',
        zoomEnabled: true,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
