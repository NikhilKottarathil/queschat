import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class InfoWidget extends StatelessWidget {
  String message;
   InfoWidget({Key key,this.message}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.IconColor,
            size: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.TextSecondary),
            ),
          )
        ],
      ),
    );
  }
}
