import 'dart:io';
import 'package:flutter/material.dart';
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
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // print('pdf link');
    // print('https://api.queschat.com/'+widget.file);
    // print(widget.file);
    return WebView(
      initialUrl: widget.file,

    );
  }
}