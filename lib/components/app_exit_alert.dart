import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_button.dart';

appExitAlert(BuildContext context) async {
  await showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          padding: EdgeInsets.only(top: 40,right: 20,left: 20,bottom: 40),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Exit',style: TextStyles.largeRegularTertiary,),
              SizedBox(height:  MediaQuery.of(context).size.height * .02,),
              Text("Do you want to exit from app name?",style: TextStyles.smallRegularTextSecondary),
              SizedBox(height:  MediaQuery.of(context).size.height * .05,),
              CustomButton(
                text: 'Yes',
                action: () {
                  SystemNavigator.pop();
                },
              ),
              SizedBox(
                height:  MediaQuery.of(context).size.height * .02,
              ),
              TextButton(
                child: Text('No'),
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
