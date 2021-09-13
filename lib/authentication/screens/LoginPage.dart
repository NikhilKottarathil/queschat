import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/authentication/screens/forgotpassword.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/authentication/screens/signup.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/uicomponents/custom_ui_widgets.dart';
import 'package:queschat/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberTextEditingController =
      new TextEditingController();

  TextEditingController passWordTextEditingController =
      new TextEditingController();

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
                      fontWeight: FontWeight.w400,fontFamily: 'NunitoSans_Regular'),
                ),
              ),
              Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).size.height) *
                          .1,
                  alignment: Alignment.topLeft,
                  child: Text("Login",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppColors.TextPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w400))),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                  textEditingController: phoneNumberTextEditingController,
                  hint: "Phone Number",
                  icon: new Icon(Icons.phone_android, color:AppColors.SecondaryColorLight),
                  textInputType: TextInputType.number),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  textEditingController: passWordTextEditingController,
                  hint: "Password",
                  icon: new Icon(Icons.lock, color: AppColors.SecondaryColorLight)),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Text(
                    "forgot password?",
                    style: TextStyle(fontSize: 13,fontFamily: 'NunitoSans_SemiBold',color: AppColors.TextPrimary),
                  ),
                ),
              ),
              CustomButton(
                  text: "Login",
                  action: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }),
              Container(
                margin: EdgeInsets.only(top: 40),
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.height * .06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: 1.5, color: Colors.lightBlue.shade200)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/google_logo.png',
                        height: MediaQuery.of(context).size.height * .04,
                        width: MediaQuery.of(context).size.height * .04),
                    Text(
                      "   Sign in with Google",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text("Don't have account?"),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: InkWell(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: AppColors.PrimaryColor,fontFamily: 'NunitoSans_Bold'),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
