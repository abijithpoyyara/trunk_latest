import 'dart:convert';

import 'package:base/services.dart';
import '../../../../../utility.dart';

class NotificationStatisticsObjectModel extends BaseResponseModel{
  List<NotificationStatisticsObject> notificationModel;
  List<NotificationStatisticeReportObject> reportObject;
  List<NotificationStatisticeUserList> userList;

  NotificationStatisticsObjectModel.fromJson(Map<String, dynamic> json)
  : super.fromJson(json) {
    notificationModel = BaseJsonParser.goodList(json, "notificationObj")
        .map((e) => NotificationStatisticsObject.fromJson(e))
        .toList();

    reportObject = BaseJsonParser.goodList(json, "reportObj")
        .map((e) => NotificationStatisticeReportObject.fromJson(e))
        .toList();

    userList = BaseJsonParser.goodList(json, "userObj")
        .map((e) => NotificationStatisticeUserList.fromJson(e))
        .toList();
  }
}

class NotificationStatisticsObject {
  String acknowledgementreqyn;
  String code;
  String extendeddate;
  String imagephysicalname;
  String optioncode;
  String message;
  String title;
  String screepanelname;
  int count;
  int forwardoptionid;
  int id;
  int notifybefore;
  int reportengineformatid;
  int tableid;

  NotificationStatisticsObject.fromJson(Map parsedJson){
  acknowledgementreqyn = BaseJsonParser.goodString(parsedJson, "branchname");
  code = BaseJsonParser.goodString(parsedJson, "code");
  extendeddate = BaseJsonParser.goodString(parsedJson, "extendeddate");
  imagephysicalname = BaseJsonParser.goodString(parsedJson, "imagephysicalname");
  optioncode = BaseJsonParser.goodString(parsedJson, "optioncode");
  message = BaseJsonParser.goodString(parsedJson, "message");
  title = BaseJsonParser.goodString(parsedJson, "title");
  screepanelname = BaseJsonParser.goodString(parsedJson, "screepanelname");
  count = BaseJsonParser.goodInt(parsedJson, "count");
  forwardoptionid = BaseJsonParser.goodInt(parsedJson, "forwardoptionid");
  id = BaseJsonParser.goodInt(parsedJson, "id");
  notifybefore = BaseJsonParser.goodInt(parsedJson, "notifybefore");
  reportengineformatid = BaseJsonParser.goodInt(parsedJson, "reportengineformatid");
  tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
}
}

class NotificationStatisticeReportObject {
  String code;
  String description;
  String extra;
  String fieldcodename;
  String userListNeeded;
  String tablecode;
  int id;
  int slno;
  int sortorder;

  NotificationStatisticeReportObject.fromJson(Map parsedJson){
    code = BaseJsonParser.goodString(parsedJson, "code");
    description = BaseJsonParser.goodString(parsedJson, "description");
    extra = BaseJsonParser.goodString(parsedJson, "extra");
    fieldcodename = BaseJsonParser.goodString(parsedJson, "fieldcodename");
    tablecode = BaseJsonParser.goodString(parsedJson, "tablecode");
    userListNeeded = BaseJsonParser.goodString(parsedJson, "userListNeeded");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
  }
}

class NotificationStatisticeUserList {
  String code;
  String name;
  int id;

  NotificationStatisticeUserList.fromJson(Map parsedJson){
    code = BaseJsonParser.goodString(parsedJson, "code");
    name = BaseJsonParser.goodString(parsedJson, "name");
    id = BaseJsonParser.goodInt(parsedJson, "id");
  }
}