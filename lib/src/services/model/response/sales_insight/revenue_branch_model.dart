import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class RevenueBranchModel extends BaseResponseModel {
  final String resultBranchKey = "resultObject";

  List<RevenueBranchItem> revenueBranchList;

  RevenueBranchModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    revenueBranchList = List();
    if (parsedJson.containsKey(resultBranchKey) &&
        parsedJson[resultBranchKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      parsedJson[resultBranchKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);

        revenueBranchList.add(RevenueBranchItem.fromJson(json, color));
      });
    }
  }
}

class RevenueBranchItem {
  String branch;
  String brand;
  String category;
  double totalValue;
  double purchaseAmount;
  double margin;
  double marginPerc;
  MaterialColor color;

  RevenueBranchItem.fromJson(Map<String, dynamic> json, this.color) {
    branch = BaseJsonParser.goodString(json, "branch");
    brand = BaseJsonParser.goodString(json, "brand");
    category = BaseJsonParser.goodString(json, "category");
    totalValue = BaseJsonParser.goodDouble(json, "totalvalue");
    purchaseAmount = BaseJsonParser.goodDouble(json, "purchaseamount");
    margin = BaseJsonParser.goodDouble(json, "margin");
    marginPerc = BaseJsonParser.goodDouble(json, "marginperc");
  }
}
