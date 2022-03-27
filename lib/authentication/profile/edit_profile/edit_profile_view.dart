import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/repository/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_bloc.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_event.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_state.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';

import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';
import 'package:queschat/uicomponents/custom_text_field_3.dart';

class EditProfileView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: appBarWithBackButton(
          context: buildContext, titleString: 'Edit Profile'),
      body: BlocProvider(
        create: (context) {
          return EditProfileBloc(
              authRepo: authRepository);
        },
        child: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            } else if (formStatus is SubmissionSuccess) {
              // buildContext.read<ProfileBloc>().getUserData();
              Navigator.of(buildContext).pop();
            }
          },
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                            minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return CustomTextField3(
                                      label: "User Name",
                                      hint: "Enter your name",
                                      validator: (value) {
                                        return state.userNameValidationText;
                                      },
                                      text: state.userName,
                                      onChange: (value) {
                                        context.read<EditProfileBloc>().add(
                                              EditProfileUsernameChanged(
                                                  username: value),
                                            );
                                      },
                                      textInputType: TextInputType.text);
                                },
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return CustomTextField3(
                                      label: "Phone Number",
                                      hint: "Phone Number",
                                      validator: (value) {
                                        return state.phoneNumberValidationText;
                                      },
                                      text: state.phoneNumber,
                                      onChange: (value) {
                                        context.read<EditProfileBloc>().add(
                                              EditProfilePhoneNumberChanged(
                                                  phoneNumber: value),
                                            );
                                      },
                                      textInputType: TextInputType.number);
                                },
                              ),


                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return CustomTextField3(
                                      label: "About me",
                                      hint: "About me",
                                      validator: (value) {
                                        return null;
                                      },
                                      text: state.bio,
                                      onChange: (value) {
                                        context.read<EditProfileBloc>().add(
                                              EditProfileBioChanged(bio: value),
                                            );
                                      },
                                      textInputType: TextInputType.text);
                                },
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return CustomTextField3(
                                      label: "FaceBook (Optional)",
                                      hint: "FaceBook Profile Link",
                                      validator: (value) {
                                        return null;
                                      },
                                      text: state.facebookLink,
                                      onChange: (value) {
                                        context.read<EditProfileBloc>().add(
                                              EditProfileFacebookLinkChanged(
                                                  value: value),
                                            );
                                      },
                                      textInputType: TextInputType.text);
                                },
                              ),


                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return CustomTextField3(
                                      label: "Instagram  (Optional)",
                                      hint: "Instagram Profile Link",
                                      validator: (value) {
                                        return null;
                                      },
                                      text: state.instagramLink,
                                      onChange: (value) {
                                        context.read<EditProfileBloc>().add(
                                              EditProfileInstagramLinkChanged(
                                                  value: value),
                                            );
                                      },
                                      textInputType: TextInputType.text);
                                },
                              ),


                              SizedBox(
                                height: 20,
                              ),

                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return CustomTextField3(
                                      label: "LinkedIn (Optional)",
                                      hint: "LinkedIn Profile Link",
                                      validator: (value) {
                                        return null;
                                      },
                                      text: state.linkedinLink,
                                      onChange: (value) {
                                        context.read<EditProfileBloc>().add(
                                              EditProfileLinkedinLinkChanged(
                                                  value: value),
                                            );
                                      },
                                      textInputType: TextInputType.text);
                                },
                              ),



                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<EditProfileBloc, EditProfileState>(
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date of Birth (Optional)',
                                        style: TextStyles.tinyRegularTextTertiary,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final datePick = await showDatePicker(
                                              context: context,
                                              initialDate: state.birthDate != null
                                                  ? state.birthDate
                                                  : new DateTime.now(),
                                              firstDate: new DateTime(1900),
                                              lastDate: new DateTime(2050));
                                          if (datePick != null) {
                                            context.read<EditProfileBloc>().add(
                                                  EditProfileBirthDateChanged(
                                                      value: datePick),
                                                );
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              state.birthDate != null
                                                  ?getDisplayDate(state.birthDate)
                                                  : '',
                                              style: TextStyles
                                                  .smallRegularTextSecondary,
                                            )),
                                            Icon(Icons.calendar_today,color: AppColors.IconColor,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),



                              SizedBox(
                                height: 100,
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BlocBuilder<EditProfileBloc, EditProfileState>(
                        builder: (context, state) {
                          return state.formStatus is FormSubmitting
                              ? CustomProgressIndicator()
                              : CustomButton(
                            text: "Save",
                            action: () {
                              if (_formKey.currentState.validate()) {
                                context
                                    .read<EditProfileBloc>()
                                    .add(EditProfileSubmitted());
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
