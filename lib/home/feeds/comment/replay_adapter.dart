import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/comment/comment_bloc.dart';
import 'package:queschat/home/feeds/comment/comment_event.dart';
import 'package:queschat/home/feeds/comment/comment_model.dart';
import 'package:queschat/home/feeds/comment/comment_state.dart';

class ReplayAdapter extends StatelessWidget {
  CommentModel commentModel;
  int commentIndex,replayIndex;

  ReplayAdapter({this.commentModel,this.commentIndex,this.replayIndex});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ),

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
                        .add(ShowDeleteAndReport(commentIndex: commentIndex,replayIndex: replayIndex));
                  }),
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
            height: 10,
          ),
        ],
      );
    });
  }
}
