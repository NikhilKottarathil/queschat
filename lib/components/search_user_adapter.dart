import 'package:flutter/material.dart';
import 'package:queschat/components/custom_radio_buttons.dart';
import 'package:queschat/constants/styles.dart';

class SearchUserAdapter extends StatefulWidget {
  SearchUserGS searchUserGS;

  bool isChecked=false;
  SearchUserAdapter(this.searchUserGS);

  @override
  _SearchUserAdapterState createState() => _SearchUserAdapterState();
}

class _SearchUserAdapterState extends State<SearchUserAdapter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*.1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(5),
              //
              // color: Colors.green,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.searchUserGS.imageUrl.toString()),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 3,

              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.searchUserGS.userName),
                    Text(widget.searchUserGS.name),
                  ],
                ),
              )),
          // Expanded(
          //   flex: 1,
          //   child: Checkbox(
          //     value:widget.isChecked,
          //
          //     onChanged:(bool value){
          //       setState(() {
          //         widget.isChecked=value;
          //       });
          //     },
          //   ),
          // ),
          Expanded(
            flex: 1,
            child:widget.searchUserGS.type=="add" ?CustomRadioButtonBlue():widget.searchUserGS.type=="delete" ?IconButton(icon: Icon(Icons.more_vert_rounded,color: AppColors.IconColor,)):Container(),
          )
        ],
      ),
    );

  }
}




class SearchUserGS {
  String type,userName, name, imageUrl;

  SearchUserGS(this.type,this.userName, this.name, this.imageUrl);
}
