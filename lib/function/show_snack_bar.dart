
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, Exception exception) {
  String message = exception.toString().substring(10);
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}