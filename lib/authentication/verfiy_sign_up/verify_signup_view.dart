import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_bloc.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_events.dart';
import 'package:queschat/authentication/verfiy_sign_up/verify_signup_state.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_button_2.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';


class VerifySignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarWithBackButton(context: context, titleString: 'Register'),
      body: BlocListener<VerifySignUpBloc, VerifySignUpState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            showSnackBar(context, formStatus.exception);
          } else if (formStatus is SubmissionSuccess) {
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
                        Text(
                          'Verify OTP',
                          style: TextStyles.heading2TextPrimary,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
                            builder: (context, state) {
                              return CustomTextField(
                                  hint: 'Enter OTP',
                                  validator: (value) {
                                    return state.otpValidationText;
                                  },
                                  text: state.otp,
                                  onChange: (value) {
                                    context.read<VerifySignUpBloc>().add(
                                      VerifySignUpOtpChanged(otp: value),
                                    );
                                  },
                                  textInputType: TextInputType.number);
                            }),
                        BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
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
                                              .read<VerifySignUpBloc>()
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
                        BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
                            builder: (context, state) {
                              return state.formStatus is FormSubmitting
                                  ? CustomProgressIndicator()
                                  : CustomButton(
                                  text: 'Verify & Register',
                                  action: () {
                                    if (_formKey.currentState.validate()) {
                                      context
                                          .read<VerifySignUpBloc>()
                                          .add(VerifySignUpSubmitted());
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
    );
  }
}

// class VerifySignUpView extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarWithBackButton(
//           context: context,
//           titleString: 'Register',),
//       body: BlocListener<VerifySignUpBloc, VerifySignUpState>(
//         listener: (context, state) {
//           final formStatus = state.formStatus;
//           if (formStatus is SubmissionFailed) {
//             showSnackBar(context, formStatus.exception);
//           } else if (formStatus is SubmissionSuccess) {
//             Navigator.pushReplacementNamed(context, '/home');
//           }
//         },
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: LayoutBuilder(builder: (context, constraints) {
//               return SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                       minWidth: constraints.maxWidth,
//                       minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         SizedBox(
//                           height: 100,
//                         ),
//
//                         Text(
//                           'Verify OTP',
//                           style: TextStyles.largeRegularTertiary,
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
//                             builder: (context, state) {
//                           return CustomTextField(
//                               hint: "Enter OTP",
//                               validator: (value) {
//                                 return state.otpValidationText;
//                               },
//                               text: state.otp,
//                               onChange: (value) {
//                                 context.read<VerifySignUpBloc>().add(
//                                       VerifySignUpOtpChanged(otp: value),
//                                     );
//                               },
//                               icon: new Icon(Icons.phone_android,
//                                   color: AppColors.SecondaryColor),
//                               textInputType: TextInputType.number);
//                         }),
//                         BlocBuilder<VerifySignUpBloc, VerifySignUpState>(
//                             builder: (context, state) {
//                           return state.formStatus is FormSubmitting
//                               ? CustomProgressIndicator()
//                               : CustomButton(
//                                   text: "REGISTER",
//                                   action: () {
//                                     if (_formKey.currentState.validate()) {
//                                       context
//                                           .read<VerifySignUpBloc>()
//                                           .add(VerifySignUpSubmitted());
//                                     }
//                                   });
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
