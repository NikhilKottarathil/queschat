import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queschat/main.dart';

copyTextFromField(String text) {
  Clipboard.setData(ClipboardData(text: text));
  final snackBar = SnackBar(
    content: Text('Text Copied'),
    duration: Duration(milliseconds: 500),
  );
  ScaffoldMessenger.of(MyApp.navigatorKey.currentContext).showSnackBar(
    snackBar,
  );
}
