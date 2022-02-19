import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/comment/comment_bloc.dart';
import 'package:queschat/home/feeds/comment/comment_event.dart';
import 'package:queschat/home/feeds/comment/comment_model.dart';
import 'package:queschat/home/feeds/comment/comment_state.dart';
import 'package:queschat/home/feeds/comment/replay_adapter.dart';

class CommentAdapter extends StatelessWidget {
  int index;

  CommentAdapter(this.index);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
      CommentModel commentModel = state.commentModelList[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(commentModel.profilePicUrl.toString()),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                commentModel.userName,
                style: TextStyles.smallMediumTextSecondary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                " " + commentModel.uploadedTime,
                style: TextStyles.tinyRegularTextTertiary,
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            commentModel.comment,
            style: TextStyles.smallRegularTextSecondary,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      child: Icon(Icons.favorite,
                          size: 18,
                          color: commentModel.isLiked
                              ? AppColors.RedPrimary
                              : AppColors.TextTertiary),
                      onTap: () {
                        context
                            .read<CommentBloc>()
                            .add(LikeAndUnLikeComment(index: index));
                      }),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    commentModel.likeCount,
                    style:
                        TextStyle(color: AppColors.TextTertiary, fontSize: 14),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () {
                        context
                            .read<CommentBloc>()
                            .add(CommentSelectedForReplay(index: index));
                      },
                      child: Text('Replay',
                          style: TextStyles.smallRegularTextTertiary)),
                ],
              ),
              IconButton(
                  splashRadius: 20,
                  iconSize: 15,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Image.asset('images/three_dot_vertical.png',
                      color: AppColors.TextTertiary),
                  onPressed: (){
                    context
                        .read<CommentBloc>()
                        .add(ShowDeleteAndReport(commentIndex: index));
                  }),
            ],
          ),
          Visibility(
              visible: commentModel.replayCount != '0' && commentModel.isShowReplay,
              child: ListView.separated(
                padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: commentModel.replays.length,
                itemBuilder: (BuildContext context, int replayIndex) {
                  return ReplayAdapter(commentIndex: index,replayIndex: replayIndex,commentModel: commentModel.replays[replayIndex],);
                },
                separatorBuilder:
                    (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              )),
          Visibility(
              visible:commentModel.replayCount != '0' && commentModel.isShowReplay,
              child: InkWell(
                onTap: () {
                  context
                      .read<CommentBloc>()
                      .add(ShowAndHideReplays(index: index));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hide replays',
                      style: TextStyles.smallRegularTextTertiary,
                    ),
                  ],
                ),
              )),
          Visibility(
              visible: commentModel.replayCount != '0' && !commentModel.isShowReplay,
              child: InkWell(
                onTap: () {
                  context
                      .read<CommentBloc>()
                      .add(ShowAndHideReplays(index: index));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View ${commentModel.replayCount} replay',
                      style: TextStyles.smallRegularTextTertiary,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: AppColors.DividerBase,
            thickness: 1,
            height: 0,
          )
        ],
      );
    });
  }
}
