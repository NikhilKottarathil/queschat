import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/login/login_view.dart';
import 'package:queschat/authentication/screens/forgotpassword.dart';
import 'package:queschat/authentication/sign_up/sign_up_bloc.dart';
import 'package:queschat/authentication/sign_up/sign_up_events.dart';
import 'package:queschat/authentication/sign_up/sign_up_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: BlocListener<SignUpBloc, SignUpState>(
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
                            'Sign up',
                            style: TextStyles.largeRegularTertiary,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<SignUpBloc, SignUpState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hint: "UserName",
                                  validator: (value) {
                                    return state.userNameValidationText;
                                  },
                                  onChange: (value) {
                                    context.read<SignUpBloc>().add(
                                      SignUpUsernameChanged(
                                          username: value),
                                    );
                                  },
                                  icon: new Icon(Icons.person,
                                      color: AppColors.SecondaryColorLight),
                                  textInputType: TextInputType.text);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<SignUpBloc, SignUpState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hint: "Phone  Number",
                                  validator: (value) {
                                    return state.phoneNumberValidationText;
                                  },
                                  onChange: (value) {
                                    context.read<SignUpBloc>().add(
                                          SignUpPhoneNumberChangeChanged(
                                              phoneNumber: value),
                                        );
                                  },
                                  icon: new Icon(Icons.phone_android,
                                      color: AppColors.SecondaryColorLight),
                                  textInputType: TextInputType.number);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<SignUpBloc, SignUpState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hint: "Password",
                                  validator: (value) {
                                    return state.passwordValidationText;
                                  },
                                  onChange: (value) {
                                    context.read<SignUpBloc>().add(
                                          SignUpPasswordChanged(
                                              password: value),
                                        );
                                  },
                                  icon: new Icon(Icons.lock,
                                      color: AppColors.SecondaryColorLight),
                                  textInputType: TextInputType.number);
                            },
                          ),
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
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyles.smallMediumTextPrimary,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: InkWell(
                                      child: Text("Login",
                                          style: TextStyles
                                              .mediumBoldPrimaryColor),
                                      onTap: () {
                                        context.read<AuthCubit>().showLogin();
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
              }),
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
