import 'package:flutter/material.dart';
import 'package:queschat/components/custom_progress_indicator.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomProgressIndicator(),
    );
  }
}
