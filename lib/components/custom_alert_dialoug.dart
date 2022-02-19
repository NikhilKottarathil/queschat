import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_button.dart';

customAlertDialog({
  BuildContext context,
  String heading,
  String positiveText,
  String negativeText,
  String content,
  Function positiveAction,
  Function negativeAction,
}) async {
  await showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              padding:
                  EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(heading, style: TextStyles.largeMediumTextSecondary),

                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * .02,
                  // ),
                  // Text()
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  CustomButton(
                    text: positiveText == null ? 'Yes' : positiveText,
                    action: () {
                      positiveAction();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  TextButton(
                    child: Text(
                      negativeText == null ? 'No' : negativeText,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ));
  return false;
}
