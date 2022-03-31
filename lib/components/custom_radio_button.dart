

import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class CustomRadioButton extends StatelessWidget {
  bool isSelected;
  String optionKey;
  Function function;

  CustomRadioButton({Key key, this.isSelected, this.optionKey, this.function});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.PrimaryColorLight : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.BorderColor),
        ),
        height: 50,
        width: 50,
        child: MaterialButton(
          onPressed: () {
            function();
            print("clicked ");
          },
          shape: CircleBorder(),
          child: Center(
            child: Text(
              optionKey,
              style:isSelected?TextStyles.smallMediumWhite: TextStyles.smallMediumTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
