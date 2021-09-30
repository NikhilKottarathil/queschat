import 'package:flutter/material.dart';
import 'package:queschat/pages/mcq_description.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';

class PostAMCQ extends StatefulWidget {
  @override
  _PostAMCQState createState() => _PostAMCQState();
}

class _PostAMCQState extends State<PostAMCQ> {
  TextEditingController aTextEditingController = new TextEditingController();
  TextEditingController bTextEditingController = new TextEditingController();
  TextEditingController cTextEditingController = new TextEditingController();
  TextEditingController dTextEditingController = new TextEditingController();

  List<RadioModel> radioData = new List<RadioModel>();

  @override
  Widget build(BuildContext context) {
    // radioData.clear();
    if (radioData.isEmpty) {
      radioData.add(new RadioModel(false, "A"));
      radioData.add(new RadioModel(false, "B"));
      radioData.add(new RadioModel(false, "C"));
      radioData.add(new RadioModel(false, "D"));
    }
    return Scaffold(
      appBar: appBarWithBackButton(context:context, titleString: "Post a MCQ"),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .75,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter your question here",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.IconColor),
                      ),
                    ),
                    OptionListAdapter(
                      optionKey: "A",
                      textEditingController: aTextEditingController,
                    ),
                    OptionListAdapter(
                      optionKey: "B",
                      textEditingController: bTextEditingController,
                    ),
                    OptionListAdapter(
                      optionKey: "C",
                      textEditingController: cTextEditingController,
                    ),
                    OptionListAdapter(
                      optionKey: "D",
                      textEditingController: dTextEditingController,
                    ),
                    // OptionListAdapter(),
                    // OptionListAdapter(),
                    // OptionListAdapter(),

                    Row(
                      children: [
                        Text("Correct Answer : \t"),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .5,
                          child: ListView.builder(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: radioData.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return CustomRadioButton(
                                  optionKey: radioData[index].text,
                                  isSelected: radioData[index].isSelected,
                                  function: () {
                                    // int i=0;
                                    print("dgjkdshgjsdhgj");
                                    for (int i = 0; i < 4; i++) {
                                      RadioModel radioModel = radioData[i];
                                      radioModel.isSelected = false;
                                      if (i == index) {
                                        radioModel.isSelected = true;

                                        print("iii true");
                                        radioData[i] = radioModel;
                                      }
                                    }
                                    // radioData.forEach((element) {
                                    //   element.isSelected=false;
                                    //   if(i==index){
                                    //     element.isSelected=true;
                                    //     print("is trueee");
                                    //   }
                                    //
                                    //     i++;
                                    //   setState(() {});
                                    //
                                    // });
                                    setState(() {});
                                  },
                                );
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: "NEXT",
                action: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MCQDescription()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionListAdapter extends StatefulWidget {
  TextEditingController textEditingController;
  String optionKey;

  OptionListAdapter({Key key, this.optionKey, this.textEditingController})
      : super(key: key);

  @override
  _OptionListAdapterState createState() => _OptionListAdapterState();
}

class _OptionListAdapterState extends State<OptionListAdapter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * .09,
        width: MediaQuery.of(context).size.width,
        color: AppColors.ShadowColor,
        padding: EdgeInsets.only(left: 5),
        child: Center(
          child: TextField(
            // maxLines: null,
            decoration: InputDecoration(
              hintText: "Enter here",
              border: InputBorder.none,
              prefixIcon: Container(
                width: MediaQuery.of(context).size.height * .045,
                height: MediaQuery.of(context).size.height * .045,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.BorderColor),
                ),
                child: Center(
                  child: Text(
                    widget.optionKey,
                    style: TextStyle(color: AppColors.TextSecondary),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRadioButtonBlue extends StatefulWidget {
  bool isSelected=false;

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

// class CustomRadioButton extends StatefulWidget {
//   bool isSelected;
//   String optionKey;
//   Function action;
//
//   CustomRadioButton({Key key, this.isSelected, this.optionKey, this.action})
//       : super(key: key);
//
//   @override
//   _CustomRadioButtonState createState() => _CustomRadioButtonState();
// }
//
// class _CustomRadioButtonState extends State<CustomRadioButton> {
//   @override
//   Widget build(BuildContext context) {
//
//     return RaisedButton(onPressed: (){
//       widget.action;
//     },child: Text("gs"),);
//
//     // return ClipRRect(
//     //   borderRadius: BorderRadius.circular(35),
//     //
//     //   clipBehavior: Clip.hardEdge,
//     //   child: Container(
//     //     decoration: BoxDecoration(
//     //       color: widget.isSelected?Colors.grey:Colors.transparent,
//     //       shape: BoxShape.circle,
//     //       border: Border.all(color: AppColors.BorderColor),
//     //     ),
//     //     height: 50,
//     //     width: 50,
//     //     child: MaterialButton(
//     //       onPressed: (){
//     //        widget.action;
//     //         print("clicked ");
//     //       },
//     //       shape: CircleBorder(),
//     //       child: Center(
//     //         child: Text(
//     //           widget.optionKey,
//     //           style: TextStyle(color: AppColors.TextSecondary),
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
// }

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}
