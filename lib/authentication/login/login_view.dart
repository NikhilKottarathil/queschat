import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/login/login_bloc.dart';
import 'package:queschat/authentication/login/login_events.dart';
import 'package:queschat/authentication/login/login_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
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
                            'Login',
                            style: TextStyles.largeRegularTertiary,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                            return CustomTextField(
                                hint: "Phone  Number",
                                text: state.phoneNumber,
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
                                    color: AppColors.SecondaryColorLight),
                                textInputType: TextInputType.number);
                          }),
                          SizedBox(
                            height: 20,
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
                                    color: AppColors.SecondaryColorLight),
                                textInputType: TextInputType.visiblePassword);
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                context.read<AuthCubit>().showForgotPassword() ;
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyles.smallBoldTextPrimary,
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
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Don't have account?",
                                    style: TextStyles.smallMediumTextPrimary,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: InkWell(
                                      child: Text("Sign Up",
                                          style: TextStyles
                                              .mediumBoldPrimaryColor),
                                      onTap: () {
                                        context.read<AuthCubit>().showSignUp();
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


}
