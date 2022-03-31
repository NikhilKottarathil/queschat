import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/alert_grid.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
import 'package:queschat/home/feeds/post_a_mcq/post_mcq_view.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_view.dart';
import 'package:queschat/home/feeds/quiz/create_quiz_view.dart';
import 'package:queschat/home/feeds/quiz/post_quiz_bloc.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/router/app_router.dart';

void showNewFeedAlert(BuildContext buildContext) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.8),
    transitionDuration: Duration(milliseconds: 500),
    context: buildContext,
    pageBuilder: (context, __, ___) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * .02,top: AppBar().preferredSize.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // AlertGrid(
                    //     heading: "Ask a Doubt",
                    //     description: "Feeling stuck, let us help",
                    //     action: () {
                    //       // print("passed sueess");
                    //       Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => AskADoubt()));
                    //     }),
                    AlertGrid(
                        heading: "Post A Poll",
                        description: "Create a multi choice question",
                        action: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => PostMcqBloc(
                                    parentPage: 'messageRoomView',
                                    messageRoomCubit:
                                        buildContext.read<MessageRoomCubit>(),
                                    feedRepo: feedRepository),
                                child: PostAMCQView(),
                              ),
                            ),
                          );
                        }),
                    AlertGrid(
                        heading: "Post A Quiz",
                        description: "Create a quiz with multiple questions",
                        action: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => PostQuizBloc(
                                    parentPage: 'messageRoomView',
                                    messageRoomCubit:
                                        buildContext.read<MessageRoomCubit>(),
                                    feedRepo: feedRepository),
                                child: CreateQuizView(),
                              ),
                            ),
                          );
                        }),
                    if (buildContext
                            .read<MessageRoomCubit>()
                            .chatRoomModel
                            .messageRoomType ==
                        'channel')
                      AlertGrid(
                          heading: "Post A Blog",
                          description: "Write a blog to share your knowledge",
                          description2: 'Blogs posted in a channel will be visible for everyone in the platform as a feed in home page',
                          action: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => PostBlogBloc(
                                      parentPage: 'messageRoomView',
                                      messageRoomCubit:
                                          buildContext.read<MessageRoomCubit>(),
                                      feedRepo: feedRepository),
                                  child: PostBlogView(),
                                ),
                              ),
                            );
                          }),
                  ],
                ),
              )),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * .085,
          //     width: MediaQuery.of(context).size.height * .085,
          //     decoration:
          //         BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          //     child: Icon(Icons.close, color: Colors.black, size: 40),
          //   ),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
