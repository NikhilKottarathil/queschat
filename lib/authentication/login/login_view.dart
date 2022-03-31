import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/login/login_bloc.dart';
import 'package:queschat/authentication/login/login_events.dart';
import 'package:queschat/authentication/login/login_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_button_2.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            showSnackBar(context, formStatus.exception);
          } else if (formStatus is SubmissionSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * .25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset('images/logo_with_name.png',
                              width: MediaQuery.of(context).size.width * .6,
                              fit: BoxFit.contain),
                        ),

                        Spacer(),
                        SizedBox(height: 30,),
                        Text('Login', style: TextStyles.heading2TextPrimary),
                        SizedBox(
                          height: 18,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                          return CustomTextField(
                              hint: "Phone  Number",
                              text: state.phoneNumber,
                              maxLength: 10,
                              validator: (value) {
                                return state.phoneNumberValidationText;
                              },
                              onChange: (value) {
                                context.read<LoginBloc>().add(
                                      LoginPhoneNumberChanged(
                                          phoneNumber: value),
                                    );
                              },
                              icon: new Icon(Icons.phone_android,
                                  color: AppColors.IconColor),
                              textInputType: TextInputType.number);
                        }),
                        SizedBox(
                          height: 18,
                        ),
                        // _usernameField(),
                        BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                          return CustomTextField(
                              hint: "Password",
                              validator: (value) {
                                return state.passwordValidationText;
                              },
                              text: state.password,
                              onChange: (value) {
                                context.read<LoginBloc>().add(
                                      LoginPasswordChanged(password: value),
                                    );
                              },
                              icon: new Icon(Icons.lock,
                                  color: AppColors.IconColor),
                              textInputType: TextInputType.visiblePassword);
                        }),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/resetPassword');
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyles.buttonTextPrimary,
                            ),
                          ),
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                          return state.formStatus is FormSubmitting
                              ? CustomProgressIndicator()
                              : CustomButton(
                                  text: "LOGIN",
                                  action: () {
                                    if (_formKey.currentState.validate()) {
                                      context
                                          .read<LoginBloc>()
                                          .add(LoginSubmitted());
                                    }
                                  });
                        }),
                        SizedBox(
                          height: 32,
                        ),
                        Center(
                          child: CustomTextButton2(
                            text: 'LOGIN WITH OTP',
                            textColor: AppColors.PrimaryColor,
                            action: () {
                              Navigator.pushNamed(context, '/otpLogin');
                            },
                          ),
                        ),
                        Spacer(),
                        SizedBox(height: 70,),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "Don't have account?",
                                style: TextStyles.bodyTextSecondary,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              InkWell(
                                child: Text("SIGN UP",
                                    style: TextStyles.buttonPrimary),
                                onTap: () {
                                  Navigator.pushNamed(context, '/signUp');
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
