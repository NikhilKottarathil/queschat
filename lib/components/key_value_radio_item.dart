import 'package:flutter/material.dart';
import 'package:queschat/constants/styles.dart';

class KeyValueRadioModel {
  String key, value;
  bool isSelected;
  List<KeyValueRadioModel> subKeyValueModels;

  KeyValueRadioModel({this.isSelected, this.key, this.value,this.subKeyValueModels});
}


class KeyValueRadioItem extends StatelessWidget {
  final KeyValueRadioModel _item;

  KeyValueRadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 10),
      padding: new EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 8),
      child: new Text(_item.key,
          style: _item.isSelected
              ? TextStyles.bodyPrimary
              : TextStyles.bodyTextSecondary),
      decoration: new BoxDecoration(
        color: AppColors.White,
        border: new Border.all(
            color: _item.isSelected
                ? AppColors.PrimaryColorLight
                : AppColors.BorderColor),
        borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
      ),
    );
  }
}