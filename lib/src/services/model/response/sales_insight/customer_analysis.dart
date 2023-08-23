import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';

class CustomerEngagementModel extends BaseResponseModel {
  final String _resultBranchKey = "resultObject";

  int totalCustomers;
  int repeat;
  int once;
  double repeatPerc;
  double oncePerc;

  CustomerEngagementModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey(_resultBranchKey) &&
        parsedJson[_resultBranchKey] != null) {
      Map<String, dynamic> json = parsedJson[_resultBranchKey][0];
      totalCustomers = BaseJsonParser.goodInt(json, "totalcustomers");
      repeat = BaseJsonParser.goodInt(json, "repeat");
      once = BaseJsonParser.goodInt(json, "once");
      repeatPerc = BaseJsonParser.goodDouble(json, "repeatperc");
      oncePerc = BaseJsonParser.goodDouble(json, "onceperc");
    }
  }
}

class CustomerBranchAnalysisModel extends BaseResponseModel {
  final String _resultBranchKey = "resultObject";

  List<CustomerBranchList> customerBranchList;

  CustomerBranchAnalysisModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    customerBranchList = List();

    if (parsedJson.containsKey(_resultBranchKey) &&
        parsedJson[_resultBranchKey] != null) {
      parsedJson[_resultBranchKey]?.forEach((json) {
        customerBranchList.add(CustomerBranchList.fromJson(json));
      });
    }
  }
}

class CustomerBranchList {
  String branchName;
  int totalCustomers;
  int repeat;
  int once;
  int repeatPerc;
  int oncePerc;

  CustomerBranchList.fromJson(Map<String, dynamic> json) {
    branchName = BaseJsonParser.goodString(json, "branchname");
    totalCustomers = BaseJsonParser.goodInt(json, "totalcustomers");
    repeat = BaseJsonParser.goodInt(json, "repeat");
    once = BaseJsonParser.goodInt(json, "once");
    repeatPerc = BaseJsonParser.goodInt(json, "repeatperc");
    oncePerc = BaseJsonParser.goodInt(json, "onceperc");
  }
}

class CustomerMarginAnalysisModel extends BaseResponseModel {
  final String _resultBranchKey = "resultObject";

  List<CustomerMarginList> customerMarginList;

  CustomerMarginAnalysisModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    customerMarginList = List();

    if (parsedJson.containsKey(_resultBranchKey) &&
        parsedJson[_resultBranchKey] != null) {
      parsedJson[_resultBranchKey]?.forEach((json) {
        final color = RandomColorPicker().getRandomColor();
        customerMarginList.add(CustomerMarginList.fromJson(json, color));
      });
    }
  }
}

class CustomerMarginList {
  String customerType;
  double totalValue;
  double purchaseAmount;
  double marginAmount;
  double marginPerc;
  MaterialColor color;

  CustomerMarginList.fromJson(Map<String, dynamic> json, this.color) {
    customerType = BaseJsonParser.goodString(json, "customertype");
    totalValue = BaseJsonParser.goodDouble(json, "totalvalue");
    purchaseAmount = BaseJsonParser.goodDouble(json, "purchaseamount");
    marginAmount = BaseJsonParser.goodDouble(json, "marginamount");
    marginPerc = BaseJsonParser.goodDouble(json, "marginperc");
  }
}
