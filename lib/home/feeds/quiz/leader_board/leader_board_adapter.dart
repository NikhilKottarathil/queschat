import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_model.dart';

class LeaderBoardAdapter extends StatelessWidget {
  LeaderBoardModel model;
  Function onPressed;
  int index;

  LeaderBoardAdapter({Key key, this.model, this.index,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.White,
      leading: leading(),
      title: Text(
        model.userName == null ? 'Deleted user' : model.userName,
        style: TextStyles.mediumBoldTextTertiary,
      ),
      subtitle: Text(
        model.completedTime == null
            ? 'unKnown'
            : getDurationTime(model.completedTime.toString()),
        style: TextStyles.smallRegularTextTertiary,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Score :  ${model.score == null ? '0' : model.score.toString()} pts',
            style: TextStyles.mediumBoldTextTertiary,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'correct ${model.correctAnswers == null ? '0' : model.correctAnswers.toString()}',
                style: TextStyles.smallRegularTextTertiary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'wrong ${model.wrongAnswers == null ? '0' : model.wrongAnswers.toString()}',
                style: TextStyles.smallRegularTextTertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  leading() {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Text((index+1).toString(),style: TextStyles.mediumBoldTextTertiary,),
        SizedBox(width: 10,),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          child: model.profilePic != null
              ? CircleAvatar(
                  radius: 21,
                  backgroundImage: NetworkImage(model.profilePic),
                  backgroundColor: Colors.transparent,
                )
              : Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  size: 38,
              color: AppColors.IconColor
                ),
        ),
      ],
    );
  }
}

class LeaderBoardWinnerAdapter extends StatelessWidget {
  LeaderBoardModel model;
  Function onPressed;
  int rank;

  LeaderBoardWinnerAdapter({Key key, this.model, this.onPressed, this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 150;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: (rank == 1 ? width * .4 : width * .3)+28,
          width: (rank == 1 ? width * .4 : width * .3)+28,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.PrimaryLighter,
                      width: 3.0,
                    ),
                  ),
                  child:model!=null&& model.profilePic != null
                      ? CircleAvatar(
                          radius: rank == 1 ? width * .4 : width * .3,
                          backgroundImage: NetworkImage(model.profilePic),
                          backgroundColor: Colors.transparent,
                        )
                      : ClipOval(
                          child: ColoredBox(
                            color: AppColors.ShadowColor,
                            child: Icon(
                              Icons.person,
                              color: AppColors.White,
                              size: rank == 1 ? width * .4 : width * .3,
                            ),
                          ),
                        ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipOval(
                    child: Container(
                      width: 28,
                      height: 28,

                      color: AppColors.PrimaryLighter,

                      child: Center(
                        child: Text(
                          rank.toString(),
                          style: TextStyles.mediumBoldPrimaryColor,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          model==null?'Winner ?' :model.userName == null ? 'Deleted user' : model.userName,
          style: TextStyles.mediumBoldTextTertiary,
        ),
      ],
    );
  }
}

// class LeaderBoardDummyAdapter extends StatelessWidget {
//
//
//   LeaderBoardDummyAdapter({Key key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       tileColor: AppColors.White,
//       leading: leading(),
//       title: ShimmerRectangle(height: 14,),
//       subtitle: Text(model.completedTime==null?'unKnown':getDurationTime(model.completedTime.toString()),style: TextStyles.smallRegularTextTertiary,),
//       trailing: Column(
//         children: [
//           Text(model.score==null?'0':model.score.toString(),style: TextStyles.mediumBoldTextTertiary,),
//           Row(
//             children: [
//               Text(model.correctAnswers==null?'0':model.correctAnswers.toString(),style: TextStyles.mediumBoldTextTertiary,),
//               SizedBox(width: 10,),
//               Text(model.wrongAnswers==null?'0':model.wrongAnswers.toString(),style: TextStyles.mediumBoldTextTertiary,),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   leading() {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: Colors.white,
//           width: 1.0,
//         ),
//       ),
//       child: CircleAvatar(
//         radius: 21,
//         backgroundImage: model.profilePic!=null?NetworkImage(model.profilePic):null,
//         child: Icon(CupertinoIcons.person_alt_circle_fill),
//         backgroundColor: Colors.transparent,
//       ),
//     );
//   }
//
// }
