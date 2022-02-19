import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class CustomRadioButtonBlue extends StatefulWidget {
  bool isSelected=false;

  CustomRadioButtonBlue({this.isSelected});

  @override
  _CustomRadioButtonBlueState createState() => _CustomRadioButtonBlueState();
}

class _CustomRadioButtonBlueState extends State<CustomRadioButtonBlue> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // border: Border.all(color: AppColors.BorderColor),
        ),
        height: 30,
        width: 30,
        child: MaterialButton(
          onPressed: () {
            setState(() {
              widget.isSelected?widget.isSelected=false:widget.isSelected=true;
            });
          },
          shape: CircleBorder(),
          child: widget.isSelected
              ? Icon(Icons.radio_button_checked, color: Colors.blue)
              : Icon(Icons.radio_button_unchecked,color: AppColors.IconColor,),
        ),
      ),
    );

  }
}



class CustomRadioButton extends StatelessWidget {
  bool isSelected;
  String optionKey;
  Function function;

  CustomRadioButton({Key key, this.isSelected, this.optionKey, this.function});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.IconColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.BorderColor),
        ),
        height: 50,
        width: 50,
        child: MaterialButton(
          onPressed: () {
            function();
            print("clicked ");
          },
          shape: CircleBorder(),
          child: Center(
            child: Text(
              optionKey,
              style: TextStyle(color: AppColors.TextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
