import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';


import 'package:queschat/authentication/screens/forgotpassword.dart';
import 'package:queschat/authentication/screens/signup.dart';
import 'package:queschat/authentication/sign_up/sign_up_view.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_bloc.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_events.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class VerifySignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () {
        context.read<AuthCubit>().showLogin();
        return null;
      },
      child: Scaffold(
        body: BlocProvider(
          create: (context) => VerifySignUpBloc(
            authRepo: context.read<AuthRepository>(),
            authCubit: context.read<AuthCubit>(),

          ),
          child: BlocListener<VerifySignUpBloc, VerifySignUpState>(
            listener: (context, state) {
              final formStatus = state.formStatus;
              if (formStatus is SubmissionFailed) {
                _showSnackBar(context, formStatus.exception);
              }
            },
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: LayoutBuilder(
                    builder: (context,constraints) {
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
                                  height: 100,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Queschat",
                                    style: TextStyle(
                                        color: Colors.lightBlue.shade900,
                                        fontSize: 43,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text("Always a step ahead",
                                      textAlign: TextAlign.center,
                                      style: TextStyles.mediumRegularTextPrimary),
                                ),
                                SizedBox(
                                  height: 70,
                                ),
                                Text(
                                  'Login',
                                  style: TextStyles.largeRegularTertiary,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
                                    builder: (context, state) {
                                      return CustomTextField(
                                          hint: "Enter OTP",

                                          validator: (value) {
                                            return state.otpValidationText;
                                          },
                                          onChange: (value) {
                                            context.read<VerifySignUpBloc>().add(
                                              VerifySignUpOtpChanged(otp: value),
                                            );
                                          },
                                          icon: new Icon(Icons.phone_android,
                                              color: AppColors.SecondaryColorLight),
                                          textInputType: TextInputType.number);
                                    }),

                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: Text(
                                      "Forgot password?",
                                      style: TextStyles.smallBoldTextPrimary,
                                    ),
                                  ),
                                ),
                                BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
                                    builder: (context, state) {
                                      return state.formStatus is FormSubmitting
                                          ? CustomProgressIndicator()
                                          : CustomButton(
                                          text: "LOGIN",
                                          action: () {
                                            if (_formKey.currentState.validate()) {
                                              context
                                                  .read<VerifySignUpBloc>()
                                                  .add(VerifySignUpSubmitted());
                                            }
                                          });
                                    }),
                                Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        Text("Don't have account?",style: TextStyles.smallMediumTextPrimary,),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            child: Text(
                                                "Sign Up",
                                                style:TextStyles.smallMediumPrimaryColor
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => SignUpView()));
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _showSnackBar(BuildContext context, Exception exception) {
    String message=exception.toString().substring(10);
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
