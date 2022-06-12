import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/sign_up/sign_up_bloc.dart';
import 'package:queschat/authentication/sign_up/sign_up_events.dart';
import 'package:queschat/authentication/sign_up/sign_up_state.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_bloc.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_view.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.IconColor,
          ),
        ),
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) async {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            showSnackBar(context, formStatus.exception);
          } else if (formStatus is SubmissionSuccess) {
            await setRepositoryAndBloc();

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

                        Spacer(
                          flex: 1,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Sign up',
                          style: TextStyles.heading2TextPrimary,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        BlocBuilder<SignUpBloc, SignUpState>(
                          builder: (context, state) {
                            return CustomTextField(
                                hint: "User Name",
                                validator: (value) {
                                  return state.userNameValidationText;
                                },
                                text: state.userName,
                                onChange: (value) {
                                  context.read<SignUpBloc>().add(
                                        SignUpUsernameChanged(username: value),
                                      );
                                },
                                icon: new Icon(Icons.person,
                                    color: AppColors.IconColor),
                                textInputType: TextInputType.text);
                          },
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        BlocBuilder<SignUpBloc, SignUpState>(
                          builder: (context, state) {
                            return CustomTextField(
                                hint: "Phone  Number",
                                validator: (value) {
                                  return state.phoneNumberValidationText;
                                },
                                text: state.phoneNumber,
                                enabled: false,
                                onChange: (value) {
                                  context.read<SignUpBloc>().add(
                                        SignUpPhoneNumberChanged(
                                            phoneNumber: value),
                                      );
                                },
                                icon: new Icon(Icons.phone_android,
                                    color: AppColors.IconColor),
                                textInputType: TextInputType.number);
                          },
                        ),
                        // SizedBox(
                        //   height: 18,
                        // ),
                        // BlocBuilder<SignUpBloc, SignUpState>(
                        //   builder: (context, state) {
                        //     return CustomTextField(
                        //         hint: "Password",
                        //         validator: (value) {
                        //           return state.passwordValidationText;
                        //         },
                        //         text: state.password,
                        //         onChange: (value) {
                        //           context.read<SignUpBloc>().add(
                        //                 SignUpPasswordChanged(
                        //                     password: value),
                        //               );
                        //         },
                        //         icon: new Icon(Icons.lock,
                        //             color: AppColors.IconColor),
                        //         textInputType: TextInputType.visiblePassword);
                        //   },
                        // ),
                        SizedBox(
                          height: 10,
                        ),

                        BlocBuilder<SignUpBloc, SignUpState>(
                          builder: (context, state) {
                            return state.formStatus is FormSubmitting
                                ? CustomProgressIndicator()
                                : CustomButton(
                                    text: "SIGN UP",
                                    action: () {
                                      if (_formKey.currentState.validate()) {
                                        context
                                            .read<SignUpBloc>()
                                            .add(SignUpSubmitted());
                                      }
                                    },
                                  );
                          },
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        // SizedBox(height: 70,),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     children: [
                        //       Text(
                        //         "Already have an account?",
                        //         style: TextStyles.bodyTextSecondary,
                        //       ),
                        //       Container(
                        //         margin: EdgeInsets.only(top: 4),
                        //         child: InkWell(
                        //           child: Text("LOGIN",
                        //               style: TextStyles
                        //                   .buttonPrimary),
                        //           onTap: () {
                        //
                        //             Navigator.pushNamed(context, '/otpLogin');
                        //             },
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // )
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
