import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator(color: AppColors.PrimaryColor,)),
    );
  }
}
