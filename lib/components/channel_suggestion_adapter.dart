import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/pages/channel_detailed_view.dart';
import 'package:queschat/uicomponents/AppColors.dart';

class ChannelAdapter extends StatefulWidget {
  ChannelGS channelGS;

  ChannelAdapter({Key key, this.channelGS}) : super(key: key);

  @override
  _ChannelAdapterState createState() => _ChannelAdapterState();
}

class _ChannelAdapterState extends State<ChannelAdapter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      width: MediaQuery.of(context).size.width * .5,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey)],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(widget.channelGS.imgUrl),
                    )),
              )),
          Expanded(
              flex: 6,
              
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.channelGS.channelName,
                      style: TextStyle(
                          color: AppColors.TextSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      widget.channelGS.channelDescription,
                      style: TextStyle(color: AppColors.TextSecondary),textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChannelDetailedView()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.PrimaryColorLight),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Follow Channel",
                          style: TextStyle(color: AppColors.PrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class ChannelSuggestionAdapter extends StatefulWidget {
  ChannelSuggestionGS channelSuggestionGS;

  ChannelSuggestionAdapter({this.channelSuggestionGS});

  @override
  _ChannelSuggestionAdapterState createState() =>
      _ChannelSuggestionAdapterState();
}

class _ChannelSuggestionAdapterState extends State<ChannelSuggestionAdapter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .35,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.channelSuggestionGS.channelGSs.length,
          itemBuilder: (BuildContext context, int index) {
            return ChannelAdapter(
                channelGS: widget.channelSuggestionGS.channelGSs[index]);
          }),
    );
  }
}

class ChannelGS {
  String imgUrl, channelName, channelDescription;

  ChannelGS(this.imgUrl, this.channelDescription, this.channelName);
}

class ChannelSuggestionGS {
  String channelCategory;
  List<ChannelGS> channelGSs = new List<ChannelGS>();

  ChannelSuggestionGS(this.channelCategory, this.channelGSs);
}
