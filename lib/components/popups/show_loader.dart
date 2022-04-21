import 'package:flutter/material.dart';
import 'package:queschat/components/custom_progress_indicator.dart';


void showLoader(BuildContext buildContext,double opacity) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(opacity),
    transitionDuration: Duration(milliseconds: 500),
    context: buildContext,
    pageBuilder: (context, __, ___) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
            alignment: Alignment.center,
            child: CustomProgressIndicator()),

      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}