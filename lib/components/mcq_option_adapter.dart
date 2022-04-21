import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class MCQOptionAdapter extends StatelessWidget {
  bool isSelected;
  bool isAnswerCorrect;
  String optionKey;
  String option;
  Function function;
  double answeredPercentage;
  String feedType;

  MCQOptionAdapter(
      {this.isSelected,
      this.answeredPercentage,
      this.optionKey,
      this.function,
      this.isAnswerCorrect,
      this.feedType,
      this.option});

  @override
  Widget build(BuildContext context) {
    // print('answeredPercentage $option $answeredPercentage');

    return InkWell(
      onTap: () {
        function();
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              gradient: isAnswerCorrect == null
                  ? LinearGradient(colors: [AppColors.StatusBar], stops: [0.0])
                  : LinearGradient(
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      colors: [
                          AppColors.BorderColor,
                          AppColors.BorderColor,
                          AppColors.ShadowColor,
                        ],
                      stops: [
                          0.0,
                          answeredPercentage,
                          answeredPercentage,
                        ]),
            ),
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
                    backgroundColor: feedType == 'poll'
                        ? isSelected
                            ? AppColors.PrimaryColorLight
                            : AppColors.White
                        : isAnswerCorrect != null
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
        ],
      ),
    );
  }
}

class MCQOptionImagedAdapter extends StatelessWidget {
  bool isSelected;
  bool isAnswerCorrect;
  String optionKey;
  String option;
  Function function;
  double answeredPercentage;

  MCQOptionImagedAdapter(
      {this.isSelected,
      this.optionKey,
      this.function,
      this.answeredPercentage,
      this.isAnswerCorrect,
      this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: isAnswerCorrect == null
                ? LinearGradient(colors: [AppColors.StatusBar], stops: [0.0])
                : LinearGradient(
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    colors: [
                        Colors.black45,
                        Colors.black45,
                        Colors.transparent
                      ],
                    stops: [
                        0.0,
                        answeredPercentage,
                        answeredPercentage,
                      ]),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2,
              color: isAnswerCorrect != null
                  ? isAnswerCorrect
                      ? AppColors.GreenPrimary
                      : AppColors.RedPrimary
                  : isSelected
                      ? AppColors.IconColor
                      : AppColors.BorderColor,
            )),
        child: Image.network(
          'https://api.queschat.com/' + option,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
