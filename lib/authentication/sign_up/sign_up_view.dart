import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_credentials.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_bloc.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_view.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/sign_up/sign_up_bloc.dart';
import 'package:queschat/authentication/sign_up/sign_up_events.dart';
import 'package:queschat/authentication/sign_up/sign_up_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            showSnackBar(context, formStatus.exception);
          } else if (formStatus is SubmissionSuccess) {
            print('signup');
            print(context.read<SignUpBloc>().generatedOTP);
            AuthCredentials authCredentials = AuthCredentials(
                userName: state.userName,
                phoneNumber: state.phoneNumber,
                password: state.password,

                generatedOTP: context.read<SignUpBloc>().generatedOTP);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (__) => VerifySignUpBloc(
                        authRepo: context.read<SignUpBloc>().authRepo,
                        authCredentials: authCredentials),
                    child: VerifySignUpView(),
                  ),
                ));
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
                                text: state.userName,
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
                                text: state.phoneNumber,
                                onChange: (value) {
                                  context.read<SignUpBloc>().add(
                                        SignUpPhoneNumberChanged(
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
                                text: state.password,
                                onChange: (value) {
                                  context.read<SignUpBloc>().add(
                                        SignUpPasswordChanged(
                                            password: value),
                                      );
                                },
                                icon: new Icon(Icons.lock,
                                    color: AppColors.SecondaryColorLight),
                                textInputType: TextInputType.visiblePassword);
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

                                      Navigator.pushNamed(context, '/login');
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
    );
  }

}
