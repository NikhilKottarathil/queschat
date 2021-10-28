import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/auth_cubit.dart';
import 'package:queschat/authentication/auth_repo.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_bloc.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_event.dart';
import 'package:queschat/authentication/profile/edit_profile/edit_profile_state.dart';
import 'package:queschat/authentication/profile/profile_bloc.dart';

import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
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
            authRepo: context.read<AuthRepository>(),
            profileBloc: context.read<ProfileBloc>(),
          );
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
                          // Text(
                          //   'Edit Profile',
                          //   style: TextStyles.largeRegularTertiary,
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          BlocBuilder<EditProfileBloc, EditProfileState>(
                            builder: (context, state) {
                              return CustomTextField3(
                                  hint: "UserName",
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
                          dividerDefault,
                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<EditProfileBloc, EditProfileState>(
                            builder: (context, state) {
                              return CustomTextField3(
                                  hint: "Phone  Number",
                                  validator: (value) {
                                    return state.phoneNumberValidationText;
                                  },
                                  text: state.phoneNumber,
                                  onChange: (value) {
                                    context.read<EditProfileBloc>().add(
                                          EditProfilePhoneNumberChangeChanged(
                                              phoneNumber: value),
                                        );
                                  },

                                  textInputType: TextInputType.number);
                            },
                          ),
                          dividerDefault,

                          SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<EditProfileBloc, EditProfileState>(
                            builder: (context, state) {
                              return CustomTextField3(
                                  hint: "About  me",
                                  validator: (value) {
                                    return null;
                                  },
                                  text: state.bio,
                                  onChange: (value) {
                                    context.read<EditProfileBloc>().add(
                                      EditProfileBioChangeChanged(
                                          bio: value),
                                    );
                                  },

                                  textInputType: TextInputType.text);
                            },
                          ),
                          dividerDefault,

                          SizedBox(height: 20,),

                          BlocBuilder<EditProfileBloc, EditProfileState>(
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
