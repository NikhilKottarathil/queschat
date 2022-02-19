import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class AlertGrid extends StatefulWidget {
  String heading, description;
  Function action;



  @override
  _AlertGridState createState() => _AlertGridState();
  AlertGrid({Key key, this.heading, this.description, this.action})
      : super(key: key);
}

class _AlertGridState extends State<AlertGrid> {
  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: (){
        widget.action();

      },
      child: Container(
        height: MediaQuery.of(context).size.height * .1,
        width: double.infinity,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.heading,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start),
               if(widget.description!=null) Text(
                  widget.description,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            // IconButton(
            //   // icon: Image.asset("image/ic_keyboard_backspace_24px"),
                 new Icon(Icons.navigate_next,color: AppColors.PrimaryColor,size:MediaQuery.of(context).size.height*.04 ,),
            //     onPressed: widget.action),
          ],
        ),
      ),
    );
  }
}


//
// class CustomButton extends StatefulWidget {
//   @override
//   _CustomButtonState createState() => _CustomButtonState();
//   String text;
//   Function action;
//   CustomButton({Key key,this.text,this.action}):super (key: key);
// }
//
// class _CustomButtonState extends State<CustomButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 30),
//       height: MediaQuery
//           .of(context)
//           .size
//           .height * .07,
//       width: MediaQuery
//           .of(context)
//           .size
//           .width * .9,
//       child: RaisedButton(
//         color: Colors.lightBlue.shade900,
//         onPressed:widget.action,
//         shape: new RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5)),
//         child: Text(
//           widget.text,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
