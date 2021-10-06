
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/multi_file_viewer.dart';
import 'package:queschat/components/multi_file_viewer_url.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_event.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_state.dart';
import 'package:queschat/models/radio_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';



class EditBlogView extends StatelessWidget {
  List<RadioModel> radioData = new List<RadioModel>();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        context.read<PostBlogBloc>().add(ClearAllFields());
        return null;
      },
      child: Scaffold(
        appBar:
        appBarWithBackButton(context: context, titleString: "Edit Blog"),
        body: BlocListener<PostBlogBloc, PostBlogState>(
          listener: (context, state) {
            final formStatus = state.formSubmissionStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            }
            if (formStatus is SubmissionSuccess) {
              context.read<FeedsBloc>().add(EditedAFeed(feedId: context.read<PostBlogBloc>().feedId));
              context.read<PostBlogBloc>().add(ClearAllFields());

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
                              children: [
                                BlocBuilder<PostBlogBloc, PostBlogState>(
                                  builder: (context, state) {
                                    return Visibility(
                                      visible: state.media.length > 0,
                                      child: MultiFileViewerUrl(mediaUrl: state.mediaUrls),
                                    );
                                  },
                                ),
                                BlocBuilder<PostBlogBloc, PostBlogState>(
                                  builder: (context, state) {
                                    return TextFieldWithBoxBorder(
                                      hint: 'Enter blog title',
                                      text: state.heading,
                                      heading: 'Title',
                                      height: 150,
                                      textInputType: TextInputType.multiline,
                                      validator: (value) {
                                        return state.headingValidationText;
                                      },
                                      onChange: (value) {
                                        context.read<PostBlogBloc>().add(
                                          HeadingChanged(heading: value),
                                        );
                                      },
                                    );
                                  },
                                ),
                                BlocBuilder<PostBlogBloc, PostBlogState>(
                                  builder: (context, state) {
                                    return TextFieldWithBoxBorder(
                                      hint: 'Enter your blog',
                                      text: state.content,
                                      heading: 'blog',
                                      height: 300,
                                      textInputType: TextInputType.multiline,
                                      validator: (value) {
                                        return state.contentAValidationText;
                                      },
                                      onChange: (value) {
                                        context.read<PostBlogBloc>().add(
                                          ContentChanged(content: value),
                                        );
                                      },
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: BlocBuilder<PostBlogBloc, PostBlogState>(
                        builder: (context, state) {
                          return state.formSubmissionStatus is FormSubmitting
                              ? CustomProgressIndicator()
                              : CustomButton(
                            text: "Save",
                            action: () async {
                              if (_formKey.currentState.validate()) {
                                context
                                    .read<PostBlogBloc>()
                                    .add(EditBlogSubmitted());
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
