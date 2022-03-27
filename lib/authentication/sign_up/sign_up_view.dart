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
                          height: MediaQuery.of(context).size.width * .25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset('images/app_logo.png',
                              height: MediaQuery.of(context).size.width * .28,
                              width: MediaQuery.of(context).size.width * .28,
                              fit: BoxFit.contain),
                        ),

                        Spacer(),
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
                                    SignUpUsernameChanged(
                                        username: value),
                                  );
                                },
                                icon:  new Icon(Icons.person,
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
                        SizedBox(
                          height: 18,
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
                                    color: AppColors.IconColor),
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
                        SizedBox(height: 70,),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyles.bodyTextSecondary,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: InkWell(
                                  child: Text("LOGIN",
                                      style: TextStyles
                                          .buttonPrimary),
                                  onTap: () {

                                    Navigator.pushNamed(context, '/login');
                                    },
                                ),
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
