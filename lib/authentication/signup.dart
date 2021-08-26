import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/authentication/LoginPage.dart';
import 'file:///C:/Users/WhiteBeast/StudioProjects/queschat/lib/uicomponents/custom_ui_widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameTextEditingController, phoneNumberTextEditingController,passWordTextEditingController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:   Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin:  EdgeInsets.only(top:MediaQuery.of(context).size.height)*.09,
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
              Container(
                  margin: EdgeInsets.only(top:MediaQuery.of(context).size.height)*.1,
                  alignment: Alignment.topLeft,
                  child: Text("SignUp",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400))),
              SizedBox(
                height: 20,
              ),
              CustomTextField(textEditingController:userNameTextEditingController,hint: "Username",icon:new Icon(Icons.person,
                  color: Colors.blueGrey)),
              SizedBox(
                height: 10,
              ),
              CustomTextField(textEditingController:phoneNumberTextEditingController,hint: "Phone Number",icon:new Icon(Icons.phone_android,
                  color: Colors.blueGrey),textInputType: TextInputType.number,),
              SizedBox(
                height: 10,
              ),
              CustomTextField(textEditingController:passWordTextEditingController,hint: "Password",icon:new Icon(Icons.lock,
                  color: Colors.blueGrey)),

              CustomButton(text:"Sign up",action: (){}),

              Container(
                margin: EdgeInsets.only(top: 25),
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [

                    Text("Already have account?"),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: InkWell(
                        child: Text("Login", style: TextStyle(
                            color: Colors.blue.shade600),), onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                      },),

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

