import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class RevenueItemModel extends BaseResponseModel {
  final String _resultKey = "resultObject";

  List<RevenueItemList> revenueItemList;

  RevenueItemModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    revenueItemList = List();
    if (parsedJson.containsKey(_resultKey) && parsedJson[_resultKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      parsedJson[_resultKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);
        revenueItemList.add(RevenueItemList.fromJson(json, color));
      });
    }
  }
}

class RevenueItemList {
  MaterialColor color;
  String brand;
  String category;
  String itemName;
  double revenue;

  RevenueItemList.fromJson(Map<String, dynamic> json, this.color) {
    brand = BaseJsonParser.goodString(json, "brand");
    category = BaseJsonParser.goodString(json, "category");
    itemName = BaseJsonParser.goodString(json, "itemname");
    revenue = BaseJsonParser.goodDouble(json, "revenue");
  }
}
