import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/custom_radio_button.dart';
import 'package:queschat/components/option_text_field.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_event.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_state.dart';
import 'package:queschat/models/radio_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class PostAMCQView extends StatefulWidget {
  @override
  _PostAMCQViewState createState() => _PostAMCQViewState();
}

class _PostAMCQViewState extends State<PostAMCQView> {
  List<RadioModel> radioData = new List<RadioModel>();
  final _formKey = GlobalKey<FormState>();

  FeedRepository feedRepo;
  @override
  Widget build(BuildContext context) {
    feedRepo=new FeedRepository();
    if (radioData.isEmpty) {
      radioData.add(new RadioModel(isSelected:false,text: "A"));
      radioData.add(new RadioModel(isSelected:false,text: "B"));
      radioData.add(new RadioModel(isSelected:false,text: "C"));
      radioData.add(new RadioModel(isSelected:false,text: "D"));
    }
    // create: (context) => PostMcqBloc(feedRepo: feedRepo),

    return Scaffold(
      appBar:
          appBarWithBackButton(context: context, titleString: "Post a MCQ"),
      body: BlocListener<PostMcqBloc,PostMcqState>(
        listener: (context, state) {
          final formStatus = state.formSubmissionStatus;
          if (formStatus is SubmissionFailed) {
            showSnackBar(context, formStatus.exception);
          }
          if (formStatus is SubmissionSuccess) {

            context.read<FeedsBloc>().add(UserAddedNewFeed(id: formStatus.id));
            context.read<PostMcqBloc>().add(ClearAllFields());

            Navigator.pop(context);
            Navigator.pop(context);
          }
        },          child: LayoutBuilder(
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
                              BlocBuilder<PostMcqBloc, PostMcqState>(
                                builder: (context, state) {
                                  return CustomTextField2(
                                    hint: 'Enter your question here',
                                    text: state.question,
                                    textInputType: TextInputType.multiline,
                                    validator: (value) {
                                      return state.questionValidationText;
                                    },
                                    onChange: (value) {
                                      context.read<PostMcqBloc>().add(
                                            QuestionChanged(question: value),
                                          );
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<PostMcqBloc, PostMcqState>(
                                builder: (context, state) {
                                  return OptionTextField(
                                    hint: 'Enter here',
                                    optionKey: "A",
                                    text: state.optionA,
                                    textInputType: TextInputType.multiline,
                                    validator: (value) {
                                      return state.optionAValidationText;
                                    },
                                    onChange: (value) {
                                      context.read<PostMcqBloc>().add(
                                            OptionAChanged(optionA: value),
                                          );
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<PostMcqBloc, PostMcqState>(
                                builder: (context, state) {
                                  return OptionTextField(
                                    hint: 'Enter here',
                                    optionKey: "B",
                                    text: state.optionB,
                                    validator: (value) {
                                      return state.optionBValidationText;
                                    },
                                    onChange: (value) {
                                      context.read<PostMcqBloc>().add(
                                            OptionBChanged(optionB: value),
                                          );
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<PostMcqBloc, PostMcqState>(
                                builder: (context, state) {
                                  return OptionTextField(
                                    hint: 'Enter here',
                                    optionKey: "C",
                                    text: state.optionC,
                                    validator: (value) {
                                      return state.optionCValidationText;
                                    },
                                    onChange: (value) {
                                      context.read<PostMcqBloc>().add(
                                            OptionCChanged(optionC: value),
                                          );
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<PostMcqBloc, PostMcqState>(
                                builder: (context, state) {
                                  return OptionTextField(
                                    hint: 'Enter here',
                                    optionKey: "D",
                                    text: state.optionD,
                                    validator: (value) {
                                      return state.optionDValidationText;
                                    },
                                    onChange: (value) {
                                      context.read<PostMcqBloc>().add(
                                            OptionDChanged(optionD: value),
                                          );
                                    },
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  Text("Select Correct Answer : \t"),
                                  BlocBuilder<PostMcqBloc, PostMcqState>(
                                    builder: (context, state) {
                                      for (int i = 0; i < 4; i++) {
                                        RadioModel radioModel = radioData[i];
                                        radioModel.isSelected = false;
                                        if (radioModel.text ==
                                            state.correctOption) {
                                          radioModel.isSelected = true;
                                          radioData[i] = radioModel;
                                        }
                                      }
                                      return Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: radioData.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CustomRadioButton(
                                                optionKey:
                                                    radioData[index].text,
                                                isSelected:
                                                    radioData[index].isSelected,
                                                function: () {
                                                  context
                                                      .read<PostMcqBloc>()
                                                      .add(CorrectOptionChanged(
                                                          correctOption:
                                                              radioData[index]
                                                                  .text));
                                                },
                                              );
                                            }),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: 100,)

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
                    child: BlocBuilder<PostMcqBloc, PostMcqState>(
                      builder: (context, state) {
                        return state.formSubmissionStatus is FormSubmitting
                            ? CustomProgressIndicator()
                            : CustomButton(
                                text: "NEXT",
                                action: () async {
                                  if (_formKey.currentState.validate()) {
                                    context
                                        .read<PostMcqBloc>()
                                        .add(PostMcqSubmitted());

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
    );
  }
}
