import 'package:base/services.dart';

import '../../../../../utility.dart';

class TransactonUnblockReportDropModel extends BaseResponseModel {
  List<NotificationItem> notificationItem;
  List<ReportFormat> reportFormat;
  TransactonUnblockReportDropModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    notificationItem = BaseJsonParser.goodList(json, "adjMode")
        .map((e) => NotificationItem.fromJson(e))
        .toList();
    reportFormat = BaseJsonParser.goodList(json, "reportWizardFormat")
        .map((e) => ReportFormat.fromJson(e))
        .toList();
  }
}

class NotificationItem {
  String acknowledgementreqyn;
  String code;
  int count;
  int forwardoptionid;
  int id;
  String message;
  String optioncode;
  int reportengineformatid;
  String screepanelname;
  int tableid;
  String title;
  NotificationItem.fromJson(Map parsedJson) {
    acknowledgementreqyn =
        BaseJsonParser.goodString(parsedJson, "acknowledgementreqyn");
    code = BaseJsonParser.goodString(parsedJson, "code");
    count = BaseJsonParser.goodInt(parsedJson, "count");
    forwardoptionid = BaseJsonParser.goodInt(parsedJson, "forwardoptionid");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    message = BaseJsonParser.goodString(parsedJson, "message");
    optioncode = BaseJsonParser.goodString(parsedJson, "optioncode");
    reportengineformatid =
        BaseJsonParser.goodInt(parsedJson, "reportengineformatid");
    screepanelname = BaseJsonParser.goodString(parsedJson, "screepanelname");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    title = BaseJsonParser.goodString(parsedJson, "title");
  }
}

class ReportFormat {
  String actionflg;
  String formatcode;
  String formatname;
  int id;
  String isdrilldownyn;
  int optionid;
  List<Dtl> dtl;
  String procedurename;
  int reportengineid;
  String subflag;
  int tableid;

  ReportFormat.fromJson(Map parsedJson) {
    Map<String, dynamic> json = parsedJson["reportWizardFormat"][0];
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
  }
}

class Dtl {
  String align;
  String dataindex;
  String formatnumberyn;
  String grouptitle;
  String header;
  int id;
  String isdrilldowncolumnyn;
  String isvisibleyn;
  String lastmoddate;
  int lastmoduserid;
  int parenttabledataid;
  int parenttableid;
  int sortorder;
  int tableid;
  int width;
  var data;
  Dtl.fromJson(Map parsedJson) {
    align = BaseJsonParser.goodString(parsedJson, "align");
    dataindex = BaseJsonParser.goodString(parsedJson, "dataindex");
    formatnumberyn = BaseJsonParser.goodString(parsedJson, "formatnumberyn");
    grouptitle = BaseJsonParser.goodString(parsedJson, "grouptitle");
    header = BaseJsonParser.goodString(parsedJson, "header");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    isdrilldowncolumnyn =
        BaseJsonParser.goodString(parsedJson, "isdrilldowncolumnyn");
    isvisibleyn = BaseJsonParser.goodString(parsedJson, "isvisibleyn");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    width = BaseJsonParser.goodInt(parsedJson, "width");
  }
}
