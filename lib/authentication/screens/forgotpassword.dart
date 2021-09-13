import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/authentication/screens/LoginPage.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/uicomponents/custom_ui_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController phoneNumberTextEditingController =
      new TextEditingController();
  TextEditingController passWordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  bool isPhoneNumberSection = true;
  bool isOTPSection = false;
  bool isPasswordSection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height) *
                        .09,
                alignment: Alignment.center,
                child: Text(
                  "Queschat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.lightBlue.shade900,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  "Always a step ahead",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Stack(
                children: [
                  Visibility(
                    visible: isPhoneNumberSection ? true : false,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height) *
                                .1,
                            alignment: Alignment.topLeft,
                            child: Text("Verification",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400))),
                        Container(
                            width: MediaQuery.of(context).size.width * .75,
                            margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height) *
                                .13,
                            alignment: Alignment.center,
                            child: Text(
                                "We will send you a One Time Password on your phone number",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        CustomTextField(
                            textEditingController:
                                phoneNumberTextEditingController,
                            hint: "Phone Number",
                            icon: new Icon(Icons.phone_android,
                                color: Colors.blueGrey)),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            text: "GET OTP",
                            action: () {
                              setState(() {
                                isPhoneNumberSection = false;
                                isOTPSection = true;
                              });
                            }),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isOTPSection ? true : false,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height) *
                                .12,
                            alignment: Alignment.center,
                            child: Text("You will get OPT via SMS",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          obscuringCharacter: '*',
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,

                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeColor: Colors.white,
                              disabledColor: Colors.white,
                              selectedColor: Colors.white,
                              selectedFillColor: Colors.white,
                              activeFillColor: Colors.white,
                              inactiveColor: Colors.white,
                              inactiveFillColor: Colors.white
                              // activeFillColor:
                              // hasError ? Colors.orange : Colors.white,
                              ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.white,
                          enableActiveFill: true,
                          // errorAnimationController: errorController,
                          // controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            print("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              // currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            text: "Proceed",
                            action: () {
                              setState(() {
                                isPasswordSection = true;
                                isPhoneNumberSection = false;
                                isOTPSection = false;
                              });
                            }),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isPasswordSection ? true : false,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height) *
                                .1,
                            alignment: Alignment.topLeft,
                            child: Text("Change password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400))),
                        Container(
                            width: MediaQuery.of(context).size.width * .75,
                            margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height) *
                                .04,
                            alignment: Alignment.center,
                            child: Text(
                                "Please confirm your password before continuing",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        CustomTextField(
                            textEditingController:
                                passWordTextEditingController,
                            hint: "Password",
                            icon: new Icon(Icons.lock, color: Colors.blueGrey)),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            textEditingController:
                                confirmPasswordTextEditingController,
                            hint: "Confirm Password",
                            icon: new Icon(Icons.lock, color: Colors.blueGrey)),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            text: "Confirm",
                            action: () {
                              setState(() {
                                isPhoneNumberSection = true;
                                isOTPSection = false;
                                isPasswordSection = false;
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
