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
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_button_2.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';


class OTPLoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return BlocProvider(
        create: (context) => OTPLoginBloc(authRepo: authRepository),
        child: BlocListener<OTPLoginBloc, OTPLoginState>(
          listener: (context, state) async {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            } else if (formStatus is SubmissionSuccess) {
              // Navigator.of(context).pop();
              await setRepositoryAndBloc();
              Navigator.pushReplacementNamed(context, '/home');
            }else if (formStatus is RegisterNewUser) {
              // Navigator.of(context).pop();
              Navigator.pushNamed(context, '/signUp',arguments: {'phoneNumber':formStatus.phoneNumber});
            }
          },
          child: BlocBuilder<OTPLoginBloc, OTPLoginState>(
            builder: (context,state) {
              return Scaffold(
                appBar:state.otpState != OTPState.showPhoneNumber ?AppBar(
                  backgroundColor:Colors.grey.shade50,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: (){

                      context.read<OTPLoginBloc>().add(ChangeNumberPressed());
                    },
                    child: Icon(Icons.arrow_back,color: AppColors.IconColor,),
                  ),
                ):AppBar(leading: null,backgroundColor:Colors.grey.shade50,
                  elevation: 0,),
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
                                  height: MediaQuery.of(context).size.width * .25,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset('images/logo_with_name.png',
                                      width: MediaQuery.of(context).size.width * .6,
                                      fit: BoxFit.contain),
                                ),
                                Spacer(flex: 1),
                                SizedBox(height: 30,),
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
                                            text: state.phoneNumber,
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
                                            maxLength: 6,
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
                                // SizedBox(
                                //   height: 32,
                                // ),
                                // Center(
                                //   child: CustomTextButton2(
                                //     text: 'LOGIN WITH PASSWORD',
                                //     textColor: AppColors.PrimaryColor,
                                //     action: () {
                                //       Navigator.pushNamed(context, '/login');
                                //     },
                                //   ),
                                // ),
                                Spacer(flex: 3,),
                                // SizedBox(height: 130,),
                                // Align(
                                //   alignment: Alignment.center,
                                //   child: Column(
                                //     children: [
                                //       Text(
                                //         "Don't have account?",
                                //         style: TextStyles.bodyTextSecondary,
                                //       ),
                                //       SizedBox(
                                //         height: 4,
                                //       ),
                                //       InkWell(
                                //         child: Text("SIGN UP",
                                //             style: TextStyles.buttonPrimary),
                                //         onTap: () {
                                //           Navigator.pushNamed(context, '/signUp');
                                //         },
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
              );
            }
          ),
        ),
      );
  }
}
