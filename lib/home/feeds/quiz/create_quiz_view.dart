import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/multi_file_view.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/quiz/add_mcqs_view.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_bloc.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_event.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_state.dart';
import 'package:queschat/models/radio_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

import 'package:duration_picker/duration_picker.dart';

class CreateQuizView extends StatelessWidget {
  List<RadioModel> radioData = new List<RadioModel>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext buildContext) {
    return WillPopScope(
      onWillPop: () {
        buildContext.read<PostQuizBloc>().add(ClearAllFields());
        return null;
      },
      child: Scaffold(
        appBar: appBarWithBackButton(
            context: buildContext, titleString: "Post A Quiz"),
        body: BlocListener<PostQuizBloc, PostQuizState>(
          listener: (context, state) {
            final formStatus = state.formSubmissionStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            }
            if (formStatus is SubmissionSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: buildContext.read<PostQuizBloc>(),
                            ),
                          ],
                          child: AddMCQsView(),
                        )),
              );
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                BlocBuilder<PostQuizBloc, PostQuizState>(
                                  builder: (context, state) {
                                    return TextFieldWithBoxBorder(
                                      hint: 'Enter title',
                                      text: state.heading,
                                      heading: 'Title',
                                      height: 120,
                                      textInputType: TextInputType.multiline,
                                      validator: (value) {
                                        return state.headingValidationText;
                                      },
                                      onChange: (value) {
                                        context.read<PostQuizBloc>().add(
                                              HeadingChanged(heading: value),
                                            );
                                      },
                                    );
                                  },
                                ),
                                BlocBuilder<PostQuizBloc, PostQuizState>(
                                  builder: (context, state) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10,),

                                        Text(
                                          'Total time for quiz',
                                          style: TextStyles
                                              .mediumMediumTextSecondary,
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: () async {
                                            var duration =
                                                await showDurationPicker(
                                              context: context,
                                              initialTime: Duration(minutes: 5),
                                            );
                                            print(duration);
                                            context.read<PostQuizBloc>().add(
                                                  DurationChanged(
                                                      value: duration
                                                          .inMilliseconds),
                                                );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.IconColor),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  getDurationTime(state.duration
                                                      .toString()),
                                                  style: TextStyles
                                                      .smallRegularTextSecondary,
                                                )),
                                                Icon(Icons.calendar_today,color: AppColors.IconColor)
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),

                                      ],
                                    );
                                  },
                                ),
                                BlocBuilder<PostQuizBloc, PostQuizState>(
                                  builder: (context, state) {
                                    return TextFieldWithBoxBorder(
                                      hint: 'Enter point for one question',
                                      heading: 'Point for one question',
                                      text: state.point,
                                      height: 80,
                                      textInputType: TextInputType.number,
                                      validator: (value) {
                                        return value == null
                                            ? 'Please fill'
                                            : null;
                                      },
                                      onChange: (value) {
                                        context.read<PostQuizBloc>().add(
                                              PointChanged(value: value),
                                            );
                                      },
                                    );
                                  },
                                ),
                                BlocBuilder<PostQuizBloc, PostQuizState>(
                                  builder: (context, state) {
                                    return TextFieldWithBoxBorder(
                                      hint: 'Enter description',
                                      text: state.content,
                                      heading: 'Description',
                                      height: 300,
                                      textInputType: TextInputType.multiline,
                                      validator: (value) {
                                        return state.contentAValidationText;
                                      },
                                      onChange: (value) {
                                        context.read<PostQuizBloc>().add(
                                              ContentChanged(content: value),
                                            );
                                      },
                                    );
                                  },
                                ),
                                BlocBuilder<PostQuizBloc, PostQuizState>(
                                  builder: (context, state) {
                                    return Visibility(
                                      visible: state.images.length > 0,
                                      child: MultiFileView(media: state.images),
                                    );
                                  },
                                ),
                                CustomButtonWithIcon(
                                  icon: Icons.camera,
                                  text: "Add an Image",
                                  action: () async {
                                    context
                                        .read<PostQuizBloc>()
                                        .add(SelectMedia(context: context));
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: BlocBuilder<PostQuizBloc, PostQuizState>(
                        builder: (context, state) {
                          return state.formSubmissionStatus is FormSubmitting
                              ? CustomProgressIndicator()
                              : CustomButton(
                                  text: "Add Polls",
                                  action: () async {
                                    if (_formKey.currentState.validate()) {
                                      context
                                          .read<PostQuizBloc>()
                                          .add(CreateQuizSubmitted());
                                    }
                                  },
                                );
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
