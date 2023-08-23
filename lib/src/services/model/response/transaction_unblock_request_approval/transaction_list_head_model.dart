import 'dart:convert';
import 'dart:ui';

import 'package:base/services.dart';

import '../../../../../utility.dart';

class TransactionUnblockListHead extends BaseResponseModel {
  List<TransactionUnblockListHeading> transactionUnblockListHeading;

  TransactionUnblockListHead.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    transactionUnblockListHeading =
        BaseJsonParser.goodList(json, "resultObject")
            .map((e) => TransactionUnblockListHeading.fromJson(e))
            .toList();
  }
}

class TransactionUnblockListHeading {
  String actionflg;
  List<Dtl> dtl;
  String formatcode;
  String formatname;
  int id;
  String isdrilldownyn;
  int optionid;
  String procedurename;
  int reportengineid;
  String subflag;
  int tableid;
  var approval_reportFormatModel;
  var mappedData;
  TransactionUnblockListHeading.fromJson(Map<String, dynamic> parsedJson) {
    approval_reportFormatModel = parsedJson["dtl"];

    // dtl = List();
    actionflg = BaseJsonParser.goodString(parsedJson, "actionflg");
    formatcode = BaseJsonParser.goodString(parsedJson, "formatcode");
    formatname = BaseJsonParser.goodString(parsedJson, "formatname");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    isdrilldownyn = BaseJsonParser.goodString(parsedJson, "isdrilldownyn");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    procedurename = BaseJsonParser.goodString(parsedJson, "procedurename");
    reportengineid = BaseJsonParser.goodInt(parsedJson, "reportengineid");
    subflag = BaseJsonParser.goodString(parsedJson, "subflag");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");

//    parsedJson["dtl"]?.forEach((d) {
//      dtl.add(Dtl.fromJson(d));
//    });
    dtl = BaseJsonParser.goodList(parsedJson, "dtl")
        .map((e) => Dtl.fromJson(e))
        .toList();
    mappedData =
        BaseJsonParser.goodList(parsedJson, "dtl").map((e) => Dtl.fromJson(e));
  }
}

class Dtl {
  TextAlign align;
  String dataindex;
  bool formatnumberyn;
  String grouptitle;
  String header;
  int id;
  bool isdrilldowncolumnyn;
  String isvisibleyn;
  String lastmoddate;
  int lastmoduserid;
  int parenttabledataid;
  int parenttableid;
  int sortorder;
  int tableid;
  int width;
  var value;
  Map<String, dynamic> dtlData;
  List<Map<String, dynamic>> list = [];
  Dtl.fromJson(Map<String, dynamic> parsedJson) {
    dtlData = parsedJson;
    align = getTextAlign(BaseJsonParser.goodString(parsedJson, "align"));
    dataindex = BaseJsonParser.goodString(parsedJson, "dataindex");
    formatnumberyn = BaseJsonParser.goodString(parsedJson, "formatnumberyn")=="Y";
    grouptitle = BaseJsonParser.goodString(parsedJson, "grouptitle");
    header = BaseJsonParser.goodString(parsedJson, "header");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    isdrilldowncolumnyn =
        BaseJsonParser.goodString(parsedJson, "isdrilldowncolumnyn")=="Y";
    isvisibleyn = BaseJsonParser.goodString(parsedJson, "isvisibleyn");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    width = BaseJsonParser.goodInt(parsedJson, "width");
    value = parsedJson["value"];
    list.add(dtlData);
  }

  TextAlign getTextAlign(String align) {
    switch (align) {
      case "left":
        return TextAlign.left;
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.right;
    }
    return TextAlign.left;
  }
}
