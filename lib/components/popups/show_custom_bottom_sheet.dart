import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_button.dart';

showCustomBottomSheet({
  BuildContext context,
  String heading,
  String positiveText,
  String negativeText,
  String content,
  Function positiveAction,
  Function negativeAction,
}) async {
  await showModalBottomSheet(
      elevation: 10,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      )),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: heading!=null,
                child: Text(heading!=null?heading:'', style: TextStyles.xMediumBoldTextTertiary)),

            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Visibility(
                visible: content!=null,
                child: Text(content!=null?content:'', style: TextStyles.mediumRegularTextTertiary)),

           Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [


               TextButton(
                 child: Text(
                   negativeText == null ? 'Cancel' : negativeText,
                   style: TextStyles.mediumMediumPrimaryColor,

                 ),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               ),
               SizedBox(
                 height: MediaQuery.of(context).size.height * .02,
               ),
               TextButton(
                 child: Text(
                   positiveText == null ? 'Yes' : positiveText,
                   style: TextStyles.mediumBoldPrimaryColor,
                 ),
                 onPressed: () {
                   positiveAction();
                   Navigator.pop(context);

                 },
               ),
             ],
           )
          ],
        ));
      });
}
