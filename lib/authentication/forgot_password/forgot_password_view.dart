import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_event.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_state.dart';
import 'package:queschat/authentication/forgot_password/forgot_password_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';

class ForgotPasswordView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(
          context: context,
          titleString: 'Reset Password',
          action: () {
            ForgotPasswordStatus formStatus =
                context.read<ForgotPasswordBloc>().state.formStatus;

            if (formStatus is InitialStatus ||
                formStatus is MobileNumberSubmitting ||
                formStatus is MobileNumberSubmitFailed ||
                formStatus is NewPasswordSubmittedSuccessfully) {
              Navigator.of(context).pop();
            } else {
              print('reverse buttn submit');

              context.read<ForgotPasswordBloc>().add(ReverseButtonSubmitted());
            }
          }),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is MobileNumberSubmitFailed) {
            showSnackBar(context, formStatus.exception);
          }
          if (formStatus is OTPSubmitFailed) {
            showSnackBar(context, formStatus.exception);
          }
          if (formStatus is NewPasswordSubmitFailed) {
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
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            return state.formStatus is InitialStatus ||
                                    state.formStatus
                                        is MobileNumberSubmitting ||
                                    state.formStatus is MobileNumberSubmitFailed
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Enter mobile number',
                                        style: TextStyles.largeRegularTertiary,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      CustomTextField(
                                          hint: "phone number",
                                          validator: (value) {
                                            return state
                                                .phoneNumberValidationText;
                                          },
                                          text: state.phoneNumber,
                                          onChange: (value) {
                                            context
                                                .read<ForgotPasswordBloc>()
                                                .add(
                                                  ForgotPhoneNumberChanged(
                                                      phoneNumber: value),
                                                );
                                          },
                                          icon: new Icon(Icons.person,
                                              color: AppColors
                                                  .SecondaryColor),
                                          textInputType: TextInputType.phone),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            return state.formStatus
                                        is MobileNumberSubmittedSuccessfully ||
                                    state.formStatus is OTPSubmitting ||
                                    state.formStatus is OTPSubmitFailed
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Verify OTP',
                                        style: TextStyles.largeRegularTertiary,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      CustomTextField(
                                          hint: "Enter OTP",
                                          validator: (value) {
                                            return state.otpValidationText;
                                          },
                                          text: state.otp,
                                          onChange: (value) {
                                            context
                                                .read<ForgotPasswordBloc>()
                                                .add(
                                                  ForgotOTPChanged(otp: value),
                                                );
                                          },
                                          icon: new Icon(Icons.phone_android,
                                              color: AppColors
                                                  .SecondaryColor),
                                          textInputType: TextInputType.number),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            return state.formStatus
                                        is OTPSubmittedSuccessfully ||
                                    state.formStatus is NewPasswordSubmitting ||
                                    state.formStatus is NewPasswordSubmitFailed
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Enter New Password',
                                        style: TextStyles.largeRegularTertiary,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      CustomTextField(
                                          hint: "Password",
                                          validator: (value) {
                                            return state.passwordValidationText;
                                          },
                                          text: state.password,
                                          onChange: (value) {
                                            context
                                                .read<ForgotPasswordBloc>()
                                                .add(
                                                  ForgotPasswordChanged(
                                                      password: value),
                                                );
                                          },
                                          icon: new Icon(Icons.lock,
                                              color: AppColors
                                                  .SecondaryColor),
                                          textInputType:
                                              TextInputType.visiblePassword),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            return state.formStatus
                                    is NewPasswordSubmittedSuccessfully
                                ? Text(
                                    'Password Changed Successfully',
                                    style: TextStyles.largeRegularTertiary,
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            return state.formStatus is NewPasswordSubmitting ||
                                    state.formStatus
                                        is MobileNumberSubmitting ||
                                    state.formStatus is OTPSubmitting
                                ? CustomProgressIndicator()
                                : CustomButton(
                                    text: state.formStatus is InitialStatus
                                        ? "Send OTP"
                                        : state.formStatus
                                                is MobileNumberSubmittedSuccessfully
                                            ? 'Verify'
                                            : state.formStatus
                                                    is OTPSubmittedSuccessfully
                                                ? 'Reset Password'
                                                : 'Login',
                                    action: () {
                                      if (state.formStatus
                                          is NewPasswordSubmittedSuccessfully) {
                                        Navigator.of(context).pop();
                                      } else {
                                        if (_formKey.currentState.validate()) {
                                          context
                                              .read<ForgotPasswordBloc>()
                                              .add(ButtonSubmitted());
                                        }
                                      }
                                    },
                                  );
                          },
                        ),
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
