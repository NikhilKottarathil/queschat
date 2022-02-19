import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

Widget buildTimerWidget(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    buildTimeCardWidget(time: hours, header: 'HOURS'),
    SizedBox(
      width: 8,
    ),
    buildTimeCardWidget(time: minutes, header: 'MINUTES'),
    SizedBox(
      width: 8,
    ),
    buildTimeCardWidget(time: seconds, header: 'SECONDS'),
    SizedBox(
      width: 8,
    ),
  ]);
}

Widget buildTimeCardWidget({@required String time, @ required String header}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: AppColors.ShadowColor, borderRadius: BorderRadius.circular(8)),
          child: Text(
            time,
            style: TextStyles.mediumBoldTextTertiary,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(header, style: TextStyles.tinyBoldTextTertiary),
      ],
    );
