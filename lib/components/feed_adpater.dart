import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class FeedAdapter extends StatefulWidget {
  FeedGS feedGS;
  FeedAdapter(this.feedGS);
  @override
  _FeedAdapterState createState() => _FeedAdapterState();
}

class _FeedAdapterState extends State<FeedAdapter> {
  @override
  Widget build(BuildContext context) {
    FeedGS feedGS=widget.feedGS;
    return Container(

      margin: EdgeInsets.only(top: 8,bottom: 8,right: 15,left: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200,blurRadius: 2)
          ],
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * .07,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .05,
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * .05,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(feedGS.profilePicUrl.toString()),
                    ),
                  ),
                ),
                Expanded(child: Text(feedGS.userName,style: TextStyle(color: AppColors.TextSecondary,fontSize: 18),)),
                Icon(Icons.access_time_rounded,color: AppColors.IconColor,),
                Text(" "+feedGS.uploadedTime,style: TextStyle(color: AppColors.IconColor,fontSize: 14),)
              ],
            ),

          ),
          Container(height: MediaQuery.of(context).size.height*.5,color: Colors.grey,),
          Container(
            height: MediaQuery.of(context).size.height*.05,
            child: Row(
              children: [
                IconButton(icon: Icon(Icons. favorite,color: AppColors.IconColor), onPressed: null),
                Text(feedGS.likeCount,style: TextStyle(color: AppColors.IconColor,fontSize: 14),),
                SizedBox(width: 20,),
                IconButton(icon: Icon(Icons. insert_comment_sharp,color: AppColors.IconColor), onPressed: null),
                Text(feedGS.commentCount,style: TextStyle(color: AppColors.IconColor,fontSize: 14),),
                Expanded(child:Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("SHARE",style: TextStyle(color: AppColors.IconColor,fontSize: 14),),
                      IconButton(icon: Icon(Icons. screen_share_sharp,color: AppColors.IconColor), onPressed: null),
                    ],
                  ),
                )),


              ],
            ),
          )
        ],
      ),
    );
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class MCQQuizFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class BlogFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class FeedGS{

  String userName,profilePicUrl,uploadedTime,likeCount,commentCount;
  FeedGS(this.userName,this.profilePicUrl,this.uploadedTime,this.likeCount,this.commentCount);
}