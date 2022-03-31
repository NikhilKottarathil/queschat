import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/multi_file_view.dart';
import 'package:queschat/components/text_editor.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_event.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_state.dart';
import 'package:queschat/models/radio_model.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_text_field.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class PostBlogView extends StatelessWidget {
  List<RadioModel> radioData = new List<RadioModel>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<PostBlogBloc>().add(ClearAllFields());
        return null;
      },
      child: Scaffold(
        appBar:
            appBarWithBackButton(context: context, titleString: "Post A Blog"),
        body: BlocListener<PostBlogBloc, PostBlogState>(
          listener: (context, state) {
            final formStatus = state.formSubmissionStatus;
            if (formStatus is SubmissionFailed) {
              showSnackBar(context, formStatus.exception);
            }
            if (formStatus is SubmissionSuccess) {
              // context.read<FeedsBloc>().add(UserAddedNewFeed(id: formStatus.id));
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
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    color: Colors.transparent,
                                    constraints: BoxConstraints(
                                        minHeight: 500,
                                        minWidth: double.infinity),
                                    child: BlocBuilder<PostBlogBloc,
                                        PostBlogState>(
                                      builder: (context, state) {
                                        return TextEditor(
                                          controller: context
                                              .read<PostBlogBloc>()
                                              .controller,
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                // BlocBuilder<PostBlogBloc, PostBlogState>(
                                //   builder: (context, state) {
                                //     return Visibility(
                                //       visible: state.media.length > 0,
                                //       child: MultiFileView(media: state.media),
                                //     );
                                //   },
                                // ),
                                // CustomButtonWithIcon(
                                //   icon: Icons.camera,
                                //   text: "Attach Media",
                                //   action: () async {
                                //     context
                                //         .read<PostBlogBloc>()
                                //         .add(SelectMedia(context: context));
                                //   },
                                // ),
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
                                  text: "NEXT",
                                  action: () async {
                                    print(context
                                        .read<PostBlogBloc>()
                                        .controller
                                        .document
                                        .isEmpty());
                                    // if (_formKey.currentState.validate()) {
                                    if (context
                                        .read<PostBlogBloc>()
                                        .controller
                                        .document
                                        .isEmpty()) {
                                      showSnackBar(context,
                                          Exception('Enter your blog post'));
                                    }
                                    // else if (context
                                    //         .read<PostBlogBloc>()
                                    //         .controller
                                    //         .getPlainText()
                                    //         .length <
                                    //     100) {
                                    //   showSnackBar(context,
                                    //       Exception('Blog is too short'));
                                    // }
                                    else {
                                      if (context.read<PostBlogBloc>().feedId !=
                                          null) {
                                        context
                                            .read<PostBlogBloc>()
                                            .add(EditBlogSubmitted());
                                      } else {
                                        context
                                            .read<PostBlogBloc>()
                                            .add(PostBlogSubmitted());
                                      }
                                    }
                                    //
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
