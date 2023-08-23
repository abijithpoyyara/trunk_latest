import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/branch_bolocked_notification/branch_blocked_notification_model.dart';

import '../../../../utility.dart';

class BlockingNotifiRepository extends BaseRepository {
  static final BlockingNotifiRepository _instance =
      BlockingNotifiRepository._();

  BlockingNotifiRepository._();

  factory BlockingNotifiRepository() => _instance;

  getBlockedNotification(
      {@required int rptId,
      @required Function(BlockedNotificationModel pendingLis) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String xmlItem = XMLBuilder(tag: "List")
        .addElement(key: "CompanyId", value: "$companyId")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          key: "resultObject",
          procName: " mobilenotificationlistproc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: xmlItem,
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BlockedNotificationModel responseJson =
              BlockedNotificationModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
