import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/multi_file_view.dart';
import 'package:queschat/components/option_text_field.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/poll/post_poll/post_poll_bloc.dart';
import 'package:queschat/home/feeds/poll/post_poll/post_poll_event.dart';
import 'package:queschat/home/feeds/poll/post_poll/post_poll_state.dart';
import 'package:queschat/models/radio_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class PostPollView extends StatefulWidget {
  @override
  _PostPollViewState createState() => _PostPollViewState();
}

class _PostPollViewState extends State<PostPollView>
    with SingleTickerProviderStateMixin {
  List<RadioModel> radioData = new List<RadioModel>();
  final _formKey = GlobalKey<FormState>();

  FeedRepository feedRepo;
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    feedRepo = new FeedRepository();
    if (radioData.isEmpty) {
      radioData.add(new RadioModel(isSelected: false, text: "A"));
      radioData.add(new RadioModel(isSelected: false, text: "B"));
      radioData.add(new RadioModel(isSelected: false, text: "C"));
      radioData.add(new RadioModel(isSelected: false, text: "D"));
    }
    // create: (context) => PostPollBloc(feedRepo: feedRepo),

    return Scaffold(
      appBar:
          appBarWithBackButton(context: context, titleString: "Post a Poll"),
      body: BlocListener<PostPollBloc, PostPollState>(
        listener: (context, state) {
          final formStatus = state.formSubmissionStatus;
          if (formStatus is SubmissionFailed) {
            showSnackBar(context, formStatus.exception);
          }
          if (formStatus is SubmissionSuccess) {
            // context.read<FeedsBloc>().add(UserAddedNewFeed(id: formStatus.id));
            context.read<PostPollBloc>().add(ClearAllFields());

            Navigator.pop(context);
            Navigator.pop(context);
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<PostPollBloc, PostPollState>(
                                builder: (context, state) {
                                  return TextFieldWithBoxBorder(
                                    hint: 'Enter your question here',
                                    text: state.question,
                                    height:
                                        MediaQuery.of(context).size.height * .3,
                                    heading: 'Enter your Question',
                                    textInputType: TextInputType.multiline,
                                    validator: (value) {
                                      return state.questionValidationText;
                                    },
                                    onChange: (value) {
                                      context.read<PostPollBloc>().add(
                                            QuestionChanged(question: value),
                                          );
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<PostPollBloc, PostPollState>(
                                builder: (context, state) {
                                  return state.questionImages.length > 0
                                      ? MultiFileView(
                                          media: state.questionImages)
                                      : Container();
                                },
                              ),
                              // CustomButtonWithIcon(
                              //   icon: Icons.camera,
                              //   text: "Add an Image",
                              //   action: () async {
                              //     context.read<PostPollBloc>().add(
                              //         SelectQuestionImages(context: context));
                              //   },
                              // ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Options',
                                style: TextStyles.mediumMediumTextSecondary,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BlocBuilder<PostPollBloc, PostPollState>(
                                  builder: (context, state) {
                                return Column(
                                  children: [
                                    OptionTextField(
                                      hint: 'Enter first option here',
                                      optionKey: "A",
                                      text: state.optionA,
                                      textInputType: TextInputType.multiline,
                                      validator: (value) {
                                        return state.optionAValidationText;
                                      },
                                      onChange: (value) {
                                        context.read<PostPollBloc>().add(
                                              OptionAChanged(optionA: value),
                                            );
                                      },
                                    ),
                                    OptionTextField(
                                      hint: 'Enter second option here',
                                      optionKey: "B",
                                      text: state.optionB,
                                      validator: (value) {
                                        return state.optionBValidationText;
                                      },
                                      onChange: (value) {
                                        context.read<PostPollBloc>().add(
                                              OptionBChanged(optionB: value),
                                            );
                                      },
                                    ),
                                    Visibility(
                                      visible: state.numberOfOption == 3 ||
                                          state.numberOfOption == 4,
                                      child: OptionTextField(
                                        hint: 'Enter third option here',
                                        optionKey: "C",
                                        text: state.optionC,
                                        validator: (value) {
                                          return state.optionCValidationText;
                                        },
                                        onChange: (value) {
                                          context.read<PostPollBloc>().add(
                                                OptionCChanged(optionC: value),
                                              );
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: state.numberOfOption == 4,
                                      child: OptionTextField(
                                        hint: 'Enter fourth option here',
                                        optionKey: "D",
                                        text: state.optionD,
                                        validator: (value) {
                                          return state.optionDValidationText;
                                        },
                                        onChange: (value) {
                                          context.read<PostPollBloc>().add(
                                                OptionDChanged(optionD: value),
                                              );
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: state.numberOfOption == 2|| state.numberOfOption == 3,
                                      
                                      child: GestureDetector(
                                        onTap: (){
                                          context.read<PostPollBloc>().add(NumberOfOptionChanged());
                                        },
                                        child: Container(
                                          // width:double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.TextTertiary),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                 Container(
                                                  width: 32,
                                                  height: 32,
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: AppColors.BorderColor),
                                                  ),

                                                  child: Center(
                                                    child:Icon(Icons.add,color: AppColors.IconColor,),
                                                  ),
                                                ),
                                                Text(
                                                  'Add another option',
                                                  style: TextStyles.smallBoldTextTertiary,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              SizedBox(
                                height: 100,
                              )
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
                    child: BlocBuilder<PostPollBloc, PostPollState>(
                      builder: (context, state) {
                        return state.formSubmissionStatus is FormSubmitting
                            ? CustomProgressIndicator()
                            : CustomButton(
                                text: "POST",
                                action: () async {
                                  if( _formKey.currentState.validate()){
                                    context
                                        .read<PostPollBloc>()
                                        .add(PostPollSubmitted());
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
