import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/otp_login/otp_login_bloc.dart';
import 'package:queschat/authentication/otp_login/otp_login_events.dart';
import 'package:queschat/authentication/otp_login/otp_login_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_button_2.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';


class OTPLoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarWithBackButton(context: context, titleString: 'Login with OTP'),
      body: BlocProvider(
        create: (context) => OTPLoginBloc(authRepo: authRepository),
        child: BlocListener<OTPLoginBloc, OTPLoginState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            } else if (formStatus is SubmissionSuccess) {
              Navigator.of(context).pop();



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
                            height: height * .08,
                          ),
                          BlocBuilder<OTPLoginBloc, OTPLoginState>(
                              builder: (context, state) {
                            return Text(
                              state.otpState == OTPState.showPhoneNumber
                                  ? 'Enter mobile number'
                                  : 'Verify OTP',
                              style: TextStyles.heading2TextPrimary,
                            );
                          }),
                          SizedBox(height: 18,),
                          BlocBuilder<OTPLoginBloc, OTPLoginState>(
                              builder: (context, state) {
                            return Visibility(
                              visible:
                                  state.otpState == OTPState.showPhoneNumber,
                              child: CustomTextField(
                                  hint: 'Mobile Number',
                                  validator: (value) {
                                    return state.phoneNumberValidationText;
                                  },
                                  text: state.otp,
                                  icon: new Icon(Icons.phone_android,
                                      color: AppColors.IconColor),
                                  onChange: (value) {
                                    context.read<OTPLoginBloc>().add(
                                          PhoneNumberChanged(
                                              phoneNumber: value),
                                        );
                                  },
                                  textInputType: TextInputType.number),
                            );
                          }),
                          BlocBuilder<OTPLoginBloc, OTPLoginState>(
                              builder: (context, state) {
                            return Visibility(
                              visible:
                                  state.otpState != OTPState.showPhoneNumber,
                              child: CustomTextField(
                                  hint: 'Enter OTP',
                                  validator: (value) {
                                    return state.otpValidationText;
                                  },
                                  text: state.otp,
                                  onChange: (value) {
                                    context.read<OTPLoginBloc>().add(
                                          OTPChanged(otp: value),
                                        );
                                  },
                                  textInputType: TextInputType.number),
                            );
                          }),
                          SizedBox(
                            height: 5,
                          ),
                          BlocBuilder<OTPLoginBloc, OTPLoginState>(
                              builder: (context, state) {
                            return Column(
                              children: [
                                Visibility(
                                  visible:
                                      state.otpState == OTPState.showResendOTP,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomTextButton2(
                                      text: 'Resend OTP',
                                      action: () {
                                        context
                                            .read<OTPLoginBloc>()
                                            .add(ResendOTPSubmitted());
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: state.otpState == OTPState.showTimer,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      getDurationTime(
                                          state.pendingTimeInMills.toString()),
                                      style: TextStyles.bodyTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          SizedBox(
                            height: 16,
                          ),
                          BlocBuilder<OTPLoginBloc, OTPLoginState>(
                              builder: (context, state) {
                            return state.formStatus is FormSubmitting
                                ? CustomProgressIndicator()
                                : CustomButton(
                                    text: state.otpState ==
                                            OTPState.showPhoneNumber
                                        ? 'Send OTP'
                                        : 'Verify & Login',
                                    action: () {
                                      if (_formKey.currentState.validate()) {
                                        if (state.otpState ==
                                            OTPState.showPhoneNumber) {
                                          context
                                              .read<OTPLoginBloc>()
                                              .add(GetOTPSubmitted());
                                        } else {
                                          context
                                              .read<OTPLoginBloc>()
                                              .add(OTPLoginSubmitted());
                                        }
                                      }
                                    });
                          }),
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
