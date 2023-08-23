import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class RevenueAnalysisModel extends BaseResponseModel {
  final String _resultBranchKey = "resultBranchList";
  final String _resultCategoryKey = "resultCategoryList";
  final String _resultBrandKey = "resultBrandList";

  List<RevenueBranchList> revenueBranchList;
  List<RevenueCategoryList> revenueCategoryList;
  List<RevenueBrandList> revenueBrandList;

  RevenueAnalysisModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey(_resultBranchKey) &&
        parsedJson[_resultBranchKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      revenueBranchList = List();

      parsedJson[_resultBranchKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);
        revenueBranchList.add(RevenueBranchList.fromJson(json, color));
      });
    }
    if (parsedJson.containsKey(_resultCategoryKey) &&
        parsedJson[_resultCategoryKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      revenueCategoryList = List();
      parsedJson[_resultCategoryKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);

        revenueCategoryList.add(RevenueCategoryList.fromJson(json, color));
      });
    }
    if (parsedJson.containsKey(_resultBrandKey) &&
        parsedJson[_resultBrandKey] != null) {
      RandomColorPicker _colorPicker = RandomColorPicker();
      revenueBrandList = List();

      parsedJson[_resultBrandKey]?.forEach((json) {
        final color = _colorPicker.getRandomColor(getUniqueColor: true);

        revenueBrandList.add(RevenueBrandList.fromJson(json, color));
      });
    }
  }
}

class RevenueList {
  String title;
  double revenue;
  double margin;
  MaterialColor color;
}

class RevenueBranchList extends RevenueList {
  String branch;
  int branchId;
  double marginPerc;
  double purchaseAmount;

  RevenueBranchList.fromJson(Map<String, dynamic> json, MaterialColor color) {
    branch = BaseJsonParser.goodString(json, "branch");
    branchId = BaseJsonParser.goodInt(json, "branchid");
    revenue = BaseJsonParser.goodDouble(json, "revenue");
    purchaseAmount = BaseJsonParser.goodDouble(json, "purchaseamount");
    margin = BaseJsonParser.goodDouble(json, "margin");
    marginPerc = BaseJsonParser.goodDouble(json, "marginperc");
    title = branch;
    this.color = color;
  }
}

class RevenueCategoryList extends RevenueList {
  int sortOrder;
  String attribute;
  int attributeId;
  int attributeValueId;
  double marginPerc;
  double purchaseAmount;

  RevenueCategoryList.fromJson(Map<String, dynamic> json, MaterialColor color) {
    sortOrder = BaseJsonParser.goodInt(json, "sortorder");
    attribute = BaseJsonParser.goodString(json, "attribute");
    attributeId = BaseJsonParser.goodInt(json, "attributeid");
    attributeValueId = BaseJsonParser.goodInt(json, "attributevalueid");
    revenue = BaseJsonParser.goodDouble(json, "revenue");
    purchaseAmount = BaseJsonParser.goodDouble(json, "purchaseamount");
    margin = BaseJsonParser.goodDouble(json, "margin");
    marginPerc = BaseJsonParser.goodDouble(json, "marginperc");
    title = attribute;
    this.color = color;
  }
}

class RevenueBrandList extends RevenueList {
  int sortOrder;
  String attribute;
  int attributeId;
  int attributeValueId;
  double marginPerc;
  double purchaseAmount;

  RevenueBrandList.fromJson(Map<String, dynamic> json, MaterialColor color) {
    sortOrder = BaseJsonParser.goodInt(json, "sortorder");
    attribute = BaseJsonParser.goodString(json, "attribute");
    attributeId = BaseJsonParser.goodInt(json, "attributeid");
    attributeValueId = BaseJsonParser.goodInt(json, "attributevalueid");
    revenue = BaseJsonParser.goodDouble(json, "revenue");
    purchaseAmount = BaseJsonParser.goodDouble(json, "purchaseamount");
    margin = BaseJsonParser.goodDouble(json, "margin");
    marginPerc = BaseJsonParser.goodDouble(json, "marginperc");
    title = attribute;
    this.color = color;
  }
}
