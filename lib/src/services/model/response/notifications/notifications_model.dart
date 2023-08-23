import 'package:base/services.dart';

import '../../../../../utility.dart';





class NotificationDisplayModel extends BaseResponseModel {
  List<NotificationDisplayListData> notificationDisplayList;

  NotificationDisplayModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    notificationDisplayList =
        BaseJsonParser.goodList(json, "resultObject")
            .map((e) => NotificationDisplayListData.fromJson(e))
            .toList();
  }
}

class NotificationDisplayListData {

  int rowno;
  String createddate;
  String message;
  String title;
  String titlename;
  int start;
  int limit;
  int total_records;
  NotificationDisplayListData.fromJson(Map parsedJson) {


    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    message = BaseJsonParser.goodString(parsedJson, "message");
    title = BaseJsonParser.goodString(parsedJson, "title");
    titlename = BaseJsonParser.goodString(parsedJson, "titlename");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    total_records = BaseJsonParser.goodInt(parsedJson, "totalrecords");
  }
}


//class NotificationsModel extends BaseResponseModel {
//  List<NotificationListData> notificationGeneratedList;
//
//  NotificationsModel.fromJson(Map<String, dynamic> json)
//      : super.fromJson(json) {
//    notificationGeneratedList = BaseJsonParser.goodList(json, "resultObject")
//        .map((e) => NotificationListData.fromJson(e))
//        .toList();
//  }
//}
//
//class NotificationListData {
//  int rowno;
//  String createddate;
//  String message;
//  String title;
//
//  NotificationListData.fromJson(Map parsedJson) {
//    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
//    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
//    message = BaseJsonParser.goodString(parsedJson, "message");
//    title = BaseJsonParser.goodString(parsedJson, "title");
//  }
//}
