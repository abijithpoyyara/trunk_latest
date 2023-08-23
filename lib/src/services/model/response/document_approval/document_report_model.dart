import 'dart:ui';

import 'package:base/services.dart';
import 'package:base/utility.dart';

class ReportModel extends BaseResponseModel {
  final String _resultSummaryFormat = "resultSummaryFormat";
  final String _resultDetailFormat = "resultDetailFormat";
  ReportFormatModel reportSummaryFormat;
  ReportFormatModel reportDetailFormat;

  ReportModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey(_resultSummaryFormat) &&
        parsedJson[_resultSummaryFormat] != null)
      reportSummaryFormat =
          ReportFormatModel.fromJson(parsedJson[_resultSummaryFormat]);
    if (parsedJson.containsKey(_resultDetailFormat) &&
        parsedJson[_resultDetailFormat] != null)
      reportDetailFormat =
          ReportFormatModel.fromJson(parsedJson[_resultDetailFormat]);
  }
}

class ReportFormatModel {
  int optionid;
  String flag;
  String formatcode;
  String formatname;
  String procedurename;
  String actionflg;
  String subflag;
  bool isExpandableList;

  List<ReportFormatDtlModel> reportDtl;

  ReportFormatModel.fromJson(Map<String, dynamic> json) {
    reportDtl = List();
    isExpandableList = false;
    optionid = BaseJsonParser.goodInt(json, "optionid");
    flag = BaseJsonParser.goodString(json, "flag");
    formatcode = BaseJsonParser.goodString(json, "formatcode");
    formatname = BaseJsonParser.goodString(json, "formatname");
    procedurename = BaseJsonParser.goodString(json, "procedurename");
    actionflg = BaseJsonParser.goodString(json, "actionflg");
    subflag = BaseJsonParser.goodString(json, "subflag");
    json["columnlist"]?.forEach((dtl) {
      reportDtl.add(ReportFormatDtlModel.fromJson(dtl));
    });
  }
}

class ReportFormatDtlModel {
  int sortOrder;
  String dataIndex;
  String header;
  double width;
  TextAlign align;
  String groupTitle;
  bool isTitle;
  bool bold;
  bool leading;
  bool leadingIcon;
  bool trailing;
  bool trailingIcon;
  int iconColor;
  int color;
  int fontColor;
  bool isVisible;
  bool drillDown;
  bool formatNumberYn;

  String leadingIconIndex;
  String trailingIconIndex;

  ReportFormatDtlModel.fromJson(Map<String, dynamic> json) {
    sortOrder = BaseJsonParser.goodInt(json, "sortorder");
    dataIndex = BaseJsonParser.goodString(json, "dataindex");
    header = BaseJsonParser.goodString(json, "header");
    width = BaseJsonParser.goodDouble(json, "width");
    align = getTextAlign(BaseJsonParser.goodString(json, "align"));
    groupTitle = BaseJsonParser.goodString(json, "grouptitle");
    isTitle = BaseJsonParser.goodBoolean(json, "istitle");
    bold = BaseJsonParser.goodBoolean(json, "isbold");
    leading = BaseJsonParser.goodBoolean(json, "isleading");
    leadingIcon = BaseJsonParser.goodBoolean(json, "isleadingicon");
    trailing = BaseJsonParser.goodBoolean(json, "istrailing");
    trailingIcon = BaseJsonParser.goodBoolean(json, "istrailingicon");
    iconColor = BaseJsonParser.goodHexInt(json, "iconcolor");
    color = BaseJsonParser.goodHexInt(json, "color");
    fontColor = BaseJsonParser.goodHexInt(json, "fontcolor");
    isVisible = BaseJsonParser.goodBoolean(json, "isvisible");
    formatNumberYn = BaseJsonParser.goodString(json, "formatnumberyn")=="Y";
    drillDown = BaseJsonParser.goodString(json, "isdrilldowncolumnyn") == "Y";
    leadingIconIndex = BaseJsonParser.goodString(json, "leadingiconindex");
    trailingIconIndex = BaseJsonParser.goodString(json, "trailingiconindex");
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

  @override
  String toString() {
    return "sortOrder : $sortOrder"
        "dataIndex : $dataIndex"
        "header : $header"
        "width : $width"
        "align : $align"
        "groupTitle : $groupTitle"
        "isTitle : $isTitle"
        "bold : $bold"
        "leading : $leading"
        "leadingIcon : $leadingIcon"
        "trailing : $trailing"
        "trailingIcon : $trailingIcon"
        "iconColor : $iconColor"
        "color : $color"
        "fontColor : $fontColor"
        "isVisible : $isVisible"
        "formatNumberYn:$formatNumberYn"
        "drillDown : $drillDown";

  }
}
