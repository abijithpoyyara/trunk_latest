import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/notifications/notifications_model.dart';
import 'package:redstars/utility.dart';


class NotificationGeneratedRepository with BaseRepository {
  static final NotificationGeneratedRepository _instance =
  NotificationGeneratedRepository._();

  NotificationGeneratedRepository._();

  factory NotificationGeneratedRepository() => _instance;

  generatedNotificationData(
      {
        @required
        Function(
            List<NotificationDisplayListData> notificationGeneratedData)
        onRequestSuccess,
        @required
        Function(AppException) onRequestFailure, }) async {
    int userId=await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String xmlnotificationItem = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "ALL")
        .addElement(key: "UserId ", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
        list: "EXEC-PROC",
        key: "resultObject",
        xmlStr: xmlnotificationItem,
        procName: "userwiseannouncementdetailslistproc",
        actionFlag: "LIST",
        subActionFlag: "")
        .callReq();

    String url = "/sales/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          NotificationDisplayModel responseJson =
          NotificationDisplayModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson.notificationDisplayList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }


  getDataFromNotification(
      {
        @required
        Function(
            List<NotificationDisplayListData> notificationGeneratedData)
        onRequestSuccess,
        @required
        Function(AppException) onRequestFailure}) async {
    int userId=await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String xmlnotificationItem = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "ALL")
        .addElement(key: "UserId ", value: "$userId")
        .buildElement();


    List jssArr = DropDownParams()
        .addParams(
        list: "EXEC-PROC",
        key: "resultObject",
        xmlStr: xmlnotificationItem,
        procName: "userwiseannouncementdetailslistproc",
        actionFlag: "LIST",
        subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          NotificationDisplayModel responseJson =
          NotificationDisplayModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson.notificationDisplayList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
