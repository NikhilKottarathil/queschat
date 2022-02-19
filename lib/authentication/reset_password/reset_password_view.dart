import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/reset_password/reset_password_bloc.dart';
import 'package:queschat/authentication/reset_password/reset_password_event.dart';
import 'package:queschat/authentication/reset_password/reset_password_state.dart';
import 'package:queschat/authentication/reset_password/reset_password_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';


class ResetPasswordView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext buildContext) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
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
      child: Scaffold(
        appBar: appBarWithBackButton(
            context: buildContext,
            titleString: 'Reset Password',
            action:  () {
              ResetPasswordStatus formStatus =
                  buildContext.read<ResetPasswordBloc>().state.formStatus;
              if (formStatus is InitialStatus ||
                  formStatus is MobileNumberSubmitting ||
                  formStatus is MobileNumberSubmitFailed ||
                  formStatus is NewPasswordSubmittedSuccessfully) {
                Navigator.of(buildContext).pop();
              } else {
                print('reverse buttn submit');

                buildContext
                    .read<ResetPasswordBloc>()
                    .add(ReverseButtonSubmitted());
              }
            }),
        body: Form(
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
                        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
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
                                        style: TextStyles.largeRegularTextTertiary,
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
                                                .read<ResetPasswordBloc>()
                                                .add(
                                                  ForgotPhoneNumberChanged(
                                                      phoneNumber: value),
                                                );
                                          },
                                          icon: Icon(Icons.phone),
                                          textInputType: TextInputType.phone),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
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
                                        style: TextStyles.largeRegularTextTertiary,
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
                                                .read<ResetPasswordBloc>()
                                                .add(
                                                  ForgotOTPChanged(otp: value),
                                                );
                                          },
                                          textInputType: TextInputType.number),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
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
                                        style: TextStyles.largeRegularTextTertiary,
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
                                                .read<ResetPasswordBloc>()
                                                .add(
                                                  ResetPasswordChanged(
                                                      password: value),
                                                );
                                          },
                                          icon: Icon(Icons.lock),
                                          textInputType:
                                              TextInputType.visiblePassword),
                                    ],
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                          builder: (context, state) {
                            return state.formStatus
                                    is NewPasswordSubmittedSuccessfully
                                ? Text(
                                    'Password Changed Successfully',
                                    style: TextStyles.largeRegularTextTertiary,
                                  )
                                : Container();
                          },
                        ),
                        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
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
                                                : 'OK',
                                    action: () {
                                      if (state.formStatus
                                          is NewPasswordSubmittedSuccessfully) {
                                        Navigator.of(context).pop();
                                      } else {
                                        if (_formKey.currentState.validate()) {
                                          context
                                              .read<ResetPasswordBloc>()
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
