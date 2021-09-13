import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class QuesBlogAdapter extends StatelessWidget {
  QuesBlogGS quesBlogGS;
  QuesBlogAdapter(this.quesBlogGS);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 3),
      height: MediaQuery.of(context).size.height*.142,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(quesBlogGS.title,style: TextStyle(color: AppColors.TextSecondary,fontSize: 18),),
                Text(quesBlogGS.uploadedTime,style: TextStyle(color: AppColors.IconColor,fontSize: 14),),
              ],
            ),
          ),
          Expanded(flex:3,child: Container(decoration: BoxDecoration(
            image: DecorationImage(
              image:NetworkImage(quesBlogGS.imageUrl),
            ),
          ),
          ),)
        ],
      ),
    );
  }
}


class QuesBlogGS{
  String title,uploadedTime,imageUrl;
  QuesBlogGS(this.title,this.uploadedTime,this.imageUrl);
}