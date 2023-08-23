import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class RevenueSalesmanModel extends BaseResponseModel {
  final String _resultKey = "resultObject";

  List<RevenueSalesmanItem> revenueSalesmanList;

  RevenueSalesmanModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    revenueSalesmanList = List();
    if (parsedJson.containsKey(_resultKey) && parsedJson[_resultKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      parsedJson[_resultKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);
        revenueSalesmanList.add(RevenueSalesmanItem.fromJson(json, color));
      });
    }
  }
}

class RevenueSalesmanItem {
  String branch;
  String salesman;
  double totalValue;
  double margin;
  double marginPerc;
  MaterialColor color;

  RevenueSalesmanItem.fromJson(Map<String, dynamic> json, this.color) {
    branch = BaseJsonParser.goodString(json, "branch");
    salesman = BaseJsonParser.goodString(json, "salesman");
    totalValue = BaseJsonParser.goodDouble(json, "setvalue");
    margin = BaseJsonParser.goodDouble(json, "margin");
    marginPerc = BaseJsonParser.goodDouble(json, "marginperc");
  }
}
