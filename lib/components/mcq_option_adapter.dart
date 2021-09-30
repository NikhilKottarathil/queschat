import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class MCQOptionAdapter extends StatelessWidget {
  bool isSelected;
  bool isAnswerCorrect;
  String optionKey;
  String option;
  Function function;

  MCQOptionAdapter(
      {this.isSelected,
      this.optionKey,
      this.function,
      this.isAnswerCorrect,
      this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              clipBehavior: Clip.hardEdge,
              child: CircleAvatar(
                radius: 16,
                child: Center(
                  child: Text(
                    optionKey,
                    style: isAnswerCorrect == null
                        ? TextStyles.smallMediumTextSecondary
                        : TextStyles.smallMediumWhite,
                  ),
                ),
                backgroundColor: isAnswerCorrect != null
                    ? isAnswerCorrect
                        ? AppColors.GreenPrimary
                        : AppColors.RedPrimary
                    : isSelected
                        ? AppColors.IconColor
                        : AppColors.White,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                option,
                style: TextStyles.smallRegularTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
