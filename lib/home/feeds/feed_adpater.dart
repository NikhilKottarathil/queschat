import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_radio_button.dart';
import 'package:queschat/components/mcq_option_adapter.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/comment/comment_bloc.dart';
import 'package:queschat/home/feeds/comment/comment_view.dart';
import 'package:queschat/home/feeds/comment/connection_repo.dart';
import 'package:queschat/home/feeds/feeds_bloc.dart';
import 'package:queschat/home/feeds/feeds_event.dart';
import 'package:queschat/home/feeds/feeds_repo.dart';
import 'package:queschat/home/feeds/feeds_state.dart';
import 'package:queschat/home/report_a_content/report_view.dart';
import 'package:queschat/models/blog_nodel.dart';
import 'package:queschat/models/feed_model.dart';
import 'package:queschat/models/mcq_model.dart';

class FeedAdapter extends StatelessWidget {
  int index;

  FeedAdapter(this.index);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<FeedsBloc, FeedsState>(builder: (context, state) {
      var feedModel = state.feedModelList[index];
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 2)],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 14),
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
                            image: NetworkImage(feedModel.profilePicUrl.toString()),
                          ),
                        ),
                      ),
                      Text(
                        feedModel.userName,
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
                      SizedBox(width: 5,),
                      Text(
                        feedModel.uploadedTime,
                        style: TextStyle(color: AppColors.IconColor, fontSize: 14),
                      ),
                      SizedBox(width: 10,),

                      IconButton(
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset('images/three_dot_vertical.png',
                              color: AppColors.TextTertiary),
                          onPressed: (){

                            showReportAlert(buildContext: context,reportedModel: 'Feed',reportedModelId: feedModel.id);
                          }),
                    ],
                  )


                ],
              ),
            ),
            feedModel.feedType == 'mcq'
                ? MCQFeed(index)
                : feedModel.feedType == 'blog'
                    ? BlogFeed(index)
                    : Container(
                        height: height * .5,
                        color: Colors.grey.shade100,
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
                      onPressed: () {
                        context
                            .read<FeedsBloc>()
                            .add(LikeAndUnLikeFeed(feedIndex: index));
                      }),
                  Text(
                    feedModel.likeCount,
                    style: TextStyle(color: AppColors.IconColor, fontSize: 14),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      splashRadius: 20,

                      icon: Icon(Icons.insert_comment_sharp,
                          color: AppColors.IconColor),
                      onPressed: (){
                        ConnectionRepository connectionRepository=ConnectionRepository();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context)=>CommentBloc(connectionRepository: connectionRepository,feedId: feedModel.id),
                                    ),BlocProvider.value(value: context.read<FeedsBloc>()),
                                  ],
                                  // create: (context)=>CommentBloc(connectionRepository: connectionRepository,feedId: feedModel.id),
                                  child: CommentView(index: index,feedId: feedModel.id,),
                                ),
                          ),
                        );
                      }),
                  Text(
                    feedModel.commentCount,
                    style: TextStyle(color: AppColors.IconColor, fontSize: 14),
                  ),
                  Expanded(
                      child: Container(
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
                  )),
                ],
              ),
            )
          ],
        ),
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

      print(mcqModel.selectedAnswer);
      print(mcqModel.correctAnswer);
      print(mcqModel.optionA);
      return Container(
        color: Colors.grey.shade100,
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
            MCQOptionAdapter(
              isSelected: false,
              function: () {
                if (mcqModel.selectedAnswer == null)
                  context
                      .read<FeedsBloc>()
                      .add(McqAnswered(feedIndex: index, option: 'A',answer: mcqModel.optionA));
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
                  context
                      .read<FeedsBloc>()
                      .add(McqAnswered(feedIndex: index, option: 'B',answer: mcqModel.optionB));
              },
              option: mcqModel.optionB.toString(),
              isAnswerCorrect: mcqModel.selectedAnswer != null
                  ? (mcqModel.selectedAnswer == 'B' ||
                          mcqModel.correctAnswer == 'B')
                      ? mcqModel.correctAnswer == 'B'
                      : null
                  : null,
              optionKey: 'B',
            ),
            SizedBox(
              height: 6,
            ),
            MCQOptionAdapter(
              isSelected: false,
              function: () {
                if (mcqModel.selectedAnswer == null)
                  context
                      .read<FeedsBloc>()
                      .add(McqAnswered(feedIndex: index, option: 'C',answer: mcqModel.optionC));
              },
              option: mcqModel.optionC.toString(),
              isAnswerCorrect: mcqModel.selectedAnswer != null
                  ? (mcqModel.selectedAnswer == 'C' ||
                          mcqModel.correctAnswer == 'C')
                      ? mcqModel.correctAnswer == 'C'
                      : null
                  : null,
              optionKey: 'C',
            ),
            SizedBox(
              height: 6,
            ),
            MCQOptionAdapter(
              isSelected: false,
              function: () {
                if (mcqModel.selectedAnswer == null)
                  context
                      .read<FeedsBloc>()
                      .add(McqAnswered(feedIndex: index, option: 'D',answer: mcqModel.optionD));
              },
              option: mcqModel.optionD.toString(),
              isAnswerCorrect: mcqModel.selectedAnswer != null
                  ? (mcqModel.selectedAnswer == 'D' ||
                          mcqModel.correctAnswer == 'D')
                      ? mcqModel.correctAnswer == 'D'
                      : null
                  : null,
              optionKey: 'D',
            ),
          ],
        ),
      );
    });
  }
}

class MCQQuizFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
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
                  child: Stack(children: [
                    blogModel.images.length==1?Image.network(
                      blogModel.images[0],
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ):CarouselSlider(
                      items: blogModel.images
                          .map((item) => Container(
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.fitWidth,
                                      width: double.infinity,
                                    )),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                          autoPlay: true,
                          height: 300,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {}),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blogModel.heading,
                    style: TextStyles.xMediumMediumTextSecondary,
                  ),
                  SizedBox( height:8),
                  Text(
                    blogModel.content,
                    style: TextStyles.smallRegularTextSecondary,
                  ),
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
