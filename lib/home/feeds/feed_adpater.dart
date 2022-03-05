import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/mcq_option_adapter.dart';
import 'package:queschat/components/multi_file_view_url.dart';
import 'package:queschat/components/text_edit_viewer.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/firebase_dynamic_link.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/comment/comment_bloc.dart';
import 'package:queschat/home/feeds/comment/comment_view.dart';
import 'package:queschat/home/feeds/comment/connection_repo.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_state.dart';
import 'package:queschat/home/feeds/post_blog/edit_blog_view.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_bloc.dart';
import 'package:queschat/home/feeds/post_blog/post_blog_view.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_bloc.dart';
import 'package:queschat/home/feeds/quiz/quiz_play/quiz_play_view.dart';
import 'package:queschat/home/report_a_content/report_view.dart';
import 'package:queschat/models/blog_nodel.dart';
import 'package:queschat/models/mcq_model.dart';
import 'package:queschat/models/quiz_model.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/custom_button.dart';

class FeedAdapter extends StatelessWidget {
  int index;

  String parentPage;

  FeedAdapter(this.index, this.parentPage);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<FeedsBloc, FeedsState>(buildWhen: (prevState, state) {
      return state.feedModelList.isNotEmpty;
    }, builder: (context, state) {
      if (state.feedModelList.isNotEmpty) {
        var feedModel = state.feedModelList[index];
        return GestureDetector(
          onTap: () {
            if (parentPage != 'singleView') {
              Navigator.pushNamed(context, '/feedSingleView', arguments: {
                'parentPage': 'feedAdapter',
                'feedId': feedModel.id
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.White,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.ShadowColor,
                      offset: Offset(0, 3),
                      blurRadius: 6)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                parentPage != 'messageRoom'
                    ? Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, right: 5, left: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          feedModel.profilePicUrl.toString()),
                                    ),
                                  ),
                                ),
                                Text(
                                  feedModel.userName.toString(),
                                  style: TextStyles.mediumMediumTextSecondary,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: AppColors.IconColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  feedModel.uploadedTime,
                                  style: TextStyle(
                                      color: AppColors.IconColor, fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    iconSize: 24,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: Image.asset(
                                        'images/three_dot_vertical.png',
                                        color: AppColors.TextTertiary),
                                    onPressed: () {
                                      if (feedModel.userId ==
                                          AppData().userId) {
                                        // print(feedModel.id);
                                        // print(AppData().userId);
                                        if (feedModel.feedType == 'blog') {
                                          showOptionAlert(
                                              context, index, feedModel.id);
                                        } else {
                                          showConfirmDeleteAlert(
                                              context, index, feedModel.id);
                                        }
                                      } else {
                                        showReportAlert(
                                            buildContext: context,
                                            reportedModel: 'Feed',
                                            reportedModelId: feedModel.id);
                                        print(
                                            'Wrong  feed in my Feeds or id not matching');
                                      }
                                    }),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: feedModel.feedType == 'mcq'
                      ? MCQFeed(index)
                      : feedModel.feedType == 'blog'
                          ? BlogFeed(index)
                          : feedModel.feedType == 'quiz'
                              ? QuizFeed(index)
                              : Container(
                                  height: height * .5,
                                  color: Colors.grey.shade100,
                                ),
                ),
                Container(
                  height: height * .05,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.favorite,
                              color: feedModel.isLiked
                                  ? AppColors.RedPrimary
                                  : AppColors.IconColor),
                          splashRadius: 20,
                          padding: EdgeInsets.only(left: 14, right: 5),
                          constraints: BoxConstraints(),
                          onPressed: () {
                            context
                                .read<FeedsBloc>()
                                .add(LikeAndUnLikeFeed(feedIndex: index));
                          }),
                      Text(
                        feedModel.likeCount,
                        style:
                            TextStyle(color: AppColors.IconColor, fontSize: 14),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.insert_comment_sharp,
                              color: AppColors.IconColor),
                          padding: EdgeInsets.only(right: 5),
                          constraints: BoxConstraints(),
                          onPressed: () {
                            ConnectionRepository connectionRepository =
                                ConnectionRepository();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => CommentBloc(
                                          connectionRepository:
                                              connectionRepository,
                                          feedId: feedModel.id),
                                    ),
                                    BlocProvider.value(
                                        value: context.read<FeedsBloc>()),
                                  ],
                                  child: CommentView(
                                    index: index,
                                    feedId: feedModel.id,
                                  ),
                                ),
                              ),
                            );
                          }),
                      Text(
                        feedModel.commentCount,
                        style:
                            TextStyle(color: AppColors.IconColor, fontSize: 14),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        splashRadius: 20,
                        icon: Icon(
                            feedModel.savedId == null
                                ? Icons.bookmark_outline_sharp
                                : Icons.bookmark,
                            color: AppColors.IconColor),
                        padding: EdgeInsets.only(left: 0, right: 5),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          context
                              .read<FeedsBloc>()
                              .add(SaveAndUnSaveFeed(feedIndex: index));
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          generateFeedDynamicLink(id: feedModel.id);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "SHARE",
                              style: TextStyle(
                                  color: AppColors.IconColor, fontSize: 14),
                            ),
                            IconButton(
                                icon: Icon(Icons.screen_share_sharp,
                                    color: AppColors.IconColor),
                                onPressed: null),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: parentPage=='singleView'?50:5),
        child: Text(
          'The post is removed',
          style: TextStyles.smallMediumTextTertiary,
        ),
      );
    });
  }

  void showOptionAlert(BuildContext buildContext, int index, String feedId) {
    showModalBottomSheet(
        context: buildContext,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return BlocProvider.value(
            value: buildContext.read<FeedsBloc>(),
            child: BlocBuilder<FeedsBloc, FeedsState>(
                builder: (buildContext, state) {
              return WillPopScope(
                onWillPop: () async {
                  // buildContext.read<FeedsBloc>().add(
                  // ShowDeleteAndReport(replayIndex: -1, commentIndex: -1));

                  return true;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showConfirmDeleteAlert(buildContext, index, feedId);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyles.smallRegularTextSecondary,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var element = await buildContext
                            .read<FeedsBloc>()
                            .feedRepository
                            .getSingleFeedDetails(buildContext
                                .read<FeedsBloc>()
                                .state
                                .feedModelList[index]
                                .id);
                        List<String> media = [];
                        element['media'].forEach((value) {
                          media.add('https://api.queschat.com/' + value['url']);
                        });
                        BlogModel blogModel = BlogModel(
                            content: element['description'],
                            images: media,
                            heading: element['name']);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => PostBlogBloc(
                                            feedRepo: buildContext
                                                .read<FeedsBloc>()
                                                .feedRepository,
                                            parentPage: 'myFeeds',
                                            feedId: buildContext
                                                .read<FeedsBloc>()
                                                .state
                                                .feedModelList[index]
                                                .id,
                                            oldBlogModel: blogModel),
                                      ),
                                      BlocProvider.value(
                                        value: buildContext.read<FeedsBloc>(),
                                      ),
                                    ],
                                    child: PostBlogView(),
                                  )),
                        );
                      },
                      child: Text(
                        'Edit',
                        style: TextStyles.smallRegularTextSecondary,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showConfirmDeleteAlert(buildContext, index, feedId);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyles.smallRegularTextSecondary,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  void showConfirmDeleteAlert(
      BuildContext buildContext, int index, String feedId) {
    showModalBottomSheet(
        context: buildContext,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return BlocProvider.value(
            value: buildContext.read<FeedsBloc>(),
            child: BlocBuilder<FeedsBloc, FeedsState>(
                builder: (buildContext, state) {
              return WillPopScope(
                onWillPop: () async {
                  // buildContext.read<FeedsBloc>().add(
                  // ShowDeleteAndReport(replayIndex: -1, commentIndex: -1));

                  return true;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      action: () {
                        if (homeFeedBloc.state.feedIds.contains(feedId)) {
                          homeFeedBloc.add(DeleteFeed(feedId: feedId));
                        }
                        if (savedFeedBloc.state.feedIds.contains(feedId)) {
                          savedFeedBloc.add(DeleteFeed(feedId: feedId));
                        }
                        if (myFeedsBloc.state.feedIds.contains(feedId)) {
                          myFeedsBloc.add(DeleteFeed(feedId: feedId));
                        }

                        Navigator.pop(context);
                      },
                      text: 'Delete',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyles.smallRegularTextSecondary,
                          )),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }
}

// media,media with text,x

class ImageFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class VideoFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MCQFeed extends StatelessWidget {
  int index;

  MCQFeed(this.index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsBloc, FeedsState>(builder: (context, state) {
      MCQModel mcqModel = state.feedModelList[index].contentModel;

      // print(mcqModel.selectedAnswer);
      // print(mcqModel.correctAnswer);
      // print(mcqModel.optionA);
      return Container(
        color: Colors.transparent,
        // decoration: BoxDecoration(
        //   color: AppColors.White,
        //   boxShadow: [
        //     BoxShadow(color: AppColors.ShadowColor,offset: Offset(0,3),blurRadius: 6)
        //   ]
        // ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q:',
                    style: TextStyles.mediumBoldTextSecondary,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Text(
                    mcqModel.question,
                    style: TextStyles.mediumRegularTextSecondary,
                  )),
                ],
              ),
            ),
            Visibility(
              visible: mcqModel.media.length > 0,
              child: Center(
                child: SizedBox(
                  height: 300,
                  child: MultiFileViewUrl(
                    mediaUrl: mcqModel.media,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: mcqModel.optionType == 'text',
              child: Column(
                children: [
                  MCQOptionAdapter(
                    isSelected: false,
                    answeredPercentage: mcqModel.optionAPercentage,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'A',
                            answer: mcqModel.optionA));
                    },
                    option: mcqModel.optionA.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'A' ||
                                mcqModel.correctAnswer == 'A')
                            ? mcqModel.correctAnswer == 'A'
                            : null
                        : null,
                    optionKey: 'A',
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'B',
                            answer: mcqModel.optionB));
                    },
                    option: mcqModel.optionB.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'B' ||
                                mcqModel.correctAnswer == 'B')
                            ? mcqModel.correctAnswer == 'B'
                            : null
                        : null,
                    optionKey: 'B',
                    answeredPercentage: mcqModel.optionBPercentage,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'C',
                            answer: mcqModel.optionC));
                    },
                    option: mcqModel.optionC.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'C' ||
                                mcqModel.correctAnswer == 'C')
                            ? mcqModel.correctAnswer == 'C'
                            : null
                        : null,
                    optionKey: 'C',
                    answeredPercentage: mcqModel.optionCPercentage,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  MCQOptionAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'D',
                            answer: mcqModel.optionD));
                    },
                    option: mcqModel.optionD.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'D' ||
                                mcqModel.correctAnswer == 'D')
                            ? mcqModel.correctAnswer == 'D'
                            : null
                        : null,
                    optionKey: 'D',
                    answeredPercentage: mcqModel.optionDPercentage,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: mcqModel.optionType == 'image',
              child: GridView(
                padding: EdgeInsets.all(14),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                children: [
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'A',
                            answer: mcqModel.optionA));
                    },
                    option: mcqModel.optionA.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'A' ||
                                mcqModel.correctAnswer == 'A')
                            ? mcqModel.correctAnswer == 'A'
                            : null
                        : null,
                    answeredPercentage: mcqModel.optionAPercentage,
                    optionKey: 'A',
                  ),
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'B',
                            answer: mcqModel.optionB));
                    },
                    option: mcqModel.optionB.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'B' ||
                                mcqModel.correctAnswer == 'B')
                            ? mcqModel.correctAnswer == 'B'
                            : null
                        : null,
                    answeredPercentage: mcqModel.optionBPercentage,
                    optionKey: 'B',
                  ),
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'C',
                            answer: mcqModel.optionC));
                    },
                    option: mcqModel.optionC.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'C' ||
                                mcqModel.correctAnswer == 'C')
                            ? mcqModel.correctAnswer == 'C'
                            : null
                        : null,
                    answeredPercentage: mcqModel.optionCPercentage,
                    optionKey: 'C',
                  ),
                  MCQOptionImagedAdapter(
                    isSelected: false,
                    function: () {
                      if (mcqModel.selectedAnswer == null)
                        context.read<FeedsBloc>().add(McqAnswered(
                            feedIndex: index,
                            option: 'D',
                            answer: mcqModel.optionD));
                    },
                    option: mcqModel.optionD.toString(),
                    isAnswerCorrect: mcqModel.selectedAnswer != null
                        ? (mcqModel.selectedAnswer == 'D' ||
                                mcqModel.correctAnswer == 'D')
                            ? mcqModel.correctAnswer == 'D'
                            : null
                        : null,
                    answeredPercentage: mcqModel.optionDPercentage,
                    optionKey: 'D',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      );
    });
  }
}

class QuizFeed extends StatelessWidget {
  int index;
  final CarouselController _controller = CarouselController();

  QuizFeed(this.index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsBloc, FeedsState>(builder: (context, state) {
      QuizModel quizModel = state.feedModelList[index].contentModel;

      return Container(
        width: double.infinity,
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quizModel.heading,
                    style: TextStyles.xMediumMediumTextSecondary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    quizModel.content,
                    style: TextStyles.smallRegularTextSecondary,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Total time : ${getDurationTime(quizModel.duration.toString())}',
                    style: TextStyles.smallRegularTextSecondary,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Point for one question : ${quizModel.point}',
                    style: TextStyles.smallRegularTextSecondary,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: quizModel.images.length > 0,
              child: Center(
                child: SizedBox(
                  height: 300,
                  child: MultiFileViewUrl(
                    mediaUrl: quizModel.images,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  quizModel.noOfQuestions + '\n Questions',
                  style: TextStyles.smallRegularTextTertiary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Container(
                    child: RaisedButton(
                      color: AppColors.GreenSecondary,
                      onPressed: () {
                        if(quizModel.isQuizAttended){
                          Navigator.pushNamed(context, '/leaderBoard',arguments: {'quizId':state.feedModelList[index].id});

                        }else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                BlocProvider(
                                  create: (context) =>
                                      QuizPlayBloc(
                                          quizId: state.feedModelList[index].id,
                                          totalDuration: quizModel.duration,
                                          point: quizModel.point,
                                          feedRepository: feedRepository,
                                          mcqIDs: quizModel.mcqIDs),
                                  child: QuizPlayView(),
                                ),
                          ));
                        }
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Text(
                          quizModel.isQuizAttended?'LEADER BOARD':'START QUIZ',
                          style: TextStyles.smallMediumWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      );
    });
  }
}

class BlogFeed extends StatelessWidget {
  int index;
  final CarouselController _controller = CarouselController();

  BlogFeed(this.index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsBloc, FeedsState>(builder: (context, state) {
      BlogModel blogModel = state.feedModelList[index].contentModel;

      return Container(
        width: double.infinity,
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: blogModel.images.length > 0,
              child: Center(
                child: SizedBox(
                  height: 300,
                  child: MultiFileViewUrl(
                    mediaUrl: blogModel.images,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   blogModel.heading,
                  //   style: TextStyles.xMediumMediumTextSecondary,
                  // ),
                  // SizedBox(height: 8),
                  TextEditorView(
                    incomingJSONText: blogModel.content,
                  ),
                  // Text(
                  //   blogModel.content,
                  //   style: TextStyles.smallRegularTextSecondary,
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
