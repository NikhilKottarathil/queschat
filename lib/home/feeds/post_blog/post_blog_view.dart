import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/text_editor.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_event.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_state.dart';
import 'package:queschat/uicomponents/appbars.dart';

class PostBlogView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<PostBlogBloc>().add(ClearAllFields());
        return null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar:
        appBarWithBackButton(context: context, titleString: "Post A Blog"),


        floatingActionButton: BlocBuilder<PostBlogBloc, PostBlogState>(
            builder: (context, state) {
              return state.formSubmissionStatus is FormSubmitting
                  ? CustomProgressIndicator()
                  : GestureDetector(
                onTap: () {


                  if (context
                      .read<PostBlogBloc>()
                      .controller
                      .document
                      .isEmpty()) {
                    showSnackBar(context,
                        Exception('Enter your blog post'));
                  }
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
                },
                child: Card(
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: AppColors.PrimaryColorLight,
                      width: 2.0,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.PrimaryColorLight,
                      border: Border.all(
                          color: AppColors.PrimaryColorLight, width: 1.3),
                      borderRadius: BorderRadius.circular(32),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: AppColors.ShadowColor,
                      //       offset: Offset(1, 3),
                      //       spreadRadius: 4,
                      //       blurRadius: 6)
                      // ],
                    ),

                    child: Text(
                      'POST BLOG',
                      style: TextStyles.buttonWhite
                      ,
                    )
                    ,
                  ),
                )
                ,
              );
            }

        )

        ,

        body
            :

        BlocListener<PostBlogBloc, PostBlogState>

          (

          listener
              :

              (context

              ,

              state) {
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

          child
              :

          Container

            (

            // padding: EdgeInsets.all(4),
            color
                :

            AppColors.PrimaryColorLight

            ,

            constraints
                :

            BoxConstraints

              (

                minHeight
                    :

                500

                ,

                minWidth
                    :

                double.infinity

            )

            ,

            child
                :

            BlocBuilder<PostBlogBloc, PostBlogState>

              (

              builder
                  :

                  (context

                  ,

                  state) {
                return TextEditor(
                  controller: context
                      .read<PostBlogBloc>()
                      .controller,
                  postBlogBlocContext: context,
                );
              },
            ),
          ),
        ),
      ),

    );
  }
}
