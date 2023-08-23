import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class BrandConnectAnalysisModel extends BaseResponseModel {
  final String resultBranchKey = "resultObject";

  List<BrandConnectList> brandConnectList;

  BrandConnectAnalysisModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    brandConnectList = List();

    if (parsedJson.containsKey(resultBranchKey) &&
        parsedJson[resultBranchKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      parsedJson[resultBranchKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);
        brandConnectList.add(BrandConnectList.fromJson(json, color));
      });
    }
  }
}

class BrandConnectList {
  String brand;
  int qty;
  double revenue;
  MaterialColor color;

  BrandConnectList.fromJson(Map<String, dynamic> json, this.color) {
    brand = BaseJsonParser.goodString(json, "brand");
    qty = BaseJsonParser.goodInt(json, "qty");
    revenue = BaseJsonParser.goodDouble(json, "revenue");
  }
}
