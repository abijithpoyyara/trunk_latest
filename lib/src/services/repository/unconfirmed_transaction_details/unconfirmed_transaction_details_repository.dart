import 'dart:convert';

import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_initial_model.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';

import '../../../../utility.dart';

class UnConfirmedTransactionDetailsRepository extends BaseRepository {
  static final UnConfirmedTransactionDetailsRepository _instance =
      UnConfirmedTransactionDetailsRepository._();

  UnConfirmedTransactionDetailsRepository._();

  factory UnConfirmedTransactionDetailsRepository() => _instance;

  Future<void> getInitialConfigs(
      {@required
          Function({
        List<BCCModel> statusTypes,
        List<BCCModel> transactionOptionTypes,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "transOptionObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "UNCONFIRMED_TRANSACTION")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "statusObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "DOC_APPRVL_STATUS")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    UnConfirmedTransactionDetailInitialConfigModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson =
                  UnConfirmedTransactionDetailInitialConfigModel.fromJson(
                      result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(
                  statusTypes: responseJson.statusTypes,
                  transactionOptionTypes: responseJson.transactionOptionTypes,
                )
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getUnconfirmedNotification(
      {int optionId,
      int transId,
      int transTableId,
      int userId,
      @required
          Function(TransactionUnblockNotificationModel transNotificationData)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(USERID_KEY);
    String xmlItem = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId ", value: "$optionId")
        .addElement(key: "TransTableId", value: "$transTableId")
        .addElement(key: "TransId", value: "$transId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          xmlStr: xmlItem,
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "MobileNotificationProc",
          actionFlag: "LIST",
          subActionFlag: "",
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
          TransactionUnblockNotificationModel responseJson =
              TransactionUnblockNotificationModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getNotificationCount(
      {int optionID,
      @required
          Function(List<NotificationCountDetails> notificationDtls)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String clientId1 = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId1 = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String service = "getdata";
    String xmlList = "";
    String xmlremovedLasttag1 = "";
    String xml1 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "TRANS_OPTION_WISE")
        .addElement(key: "NotificationOptionId ", value: "${optionID ?? 1}")
        .buildElement(appendFlag: false);
    String xml2 = XMLBuilder(tag: "User")
        .addElement(key: "Clientid ", value: "$clientId1")
        .addElement(key: "UserId ", value: "${userId1 ?? 1}")
        .addElement(key: "BranchId ", value: "${branchId ?? 1}")
        .buildElement(appendFlag: false);
    xmlList = xml2.replaceAll("> </User>", "/>");
    xmlremovedLasttag1 = xml1.replaceAll("> </List>", "/>");
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlremovedLasttag1 + xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "NOTIFICATION_COUNT",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          NotificationCountDetailsModel responseJson =
              NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.notificationCount);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getUnreadListOfUnconfirmed(
      {int optionId,
      int notificationId,
      @required Function(List<UnreadNotificationListModel>) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    String xmlList = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "NotificationOptionId", value: "$notificationId")
        .buildElement(appendFlag: false);

    xmlList = xml.replaceAll("> </List>", "/>");

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "TRANS_READSTATUS",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          UnreadNotificationList responseJson =
              UnreadNotificationList.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.notificationUnread);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getUnConfirmedTransactionDetails(
      {UnConfirmedFilterModel unConfirmedFilterModel,
      @required
          Function(
                  List<UnConfirmedTransactionDetailList>
                      unConfirmedTransactionDetailListData,
                  int statusCode)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int user_id = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String xmlItem = XMLBuilder(tag: "List")
        // .addElement(
        //     key: "DateFrom",
        //     value: "${BaseDates(unConfirmedFilterModel?.fromDate).dbformat}")
        // .addElement(
        //     key: "DateTo",
        //     value: "${BaseDates(unConfirmedFilterModel?.toDate).dbformat}")
        .addElement(key: "UserId ", value: "$user_id")
        .addElement(
            key: "OptionCode ",
            value:
                "${unConfirmedFilterModel.optionCode?.code ?? "SALES_INVOICE"}")
        .addElement(key: "Start", value: "0")
        .addElement(key: "Limit", value: "99999")
        .addElement(key: "Flag ", value: "ALL")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlItem,
            procName: "UnConfirmedTransactionDetailsListProc",
            actionFlag: "LIST",
            subActionFlag: "VIEW")
        .callReq();

    String url = "/sales/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          UnConfirmedTransactionDetailListModel responseJson =
              UnConfirmedTransactionDetailListModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson.unConfirmedTransactionDetailListData,
                responseJson.statusCode);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void saveUnConfirmedTransaction({
    List<UnConfirmedTransactionDetailList> unconfirmedDetails,
    String optionCode,
    String apprvlStatus,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int userId = await BasePrefs.getInt(USERID_KEY);
    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    DateTime convertDateTimePtBR(String validade) {
      DateTime parsedDate;

      List<String> validadeSplit = validade.split('-');

      if (validadeSplit.length > 1) {
        String day = validadeSplit[0].toString();
        String month = validadeSplit[1].toString();
        String year = validadeSplit[2].toString();

        parsedDate = DateTime.parse('$year-$month-$day 00:00:00');
      }

      return parsedDate;
    }

    var unconfirmedDetailList = unconfirmedDetails.map((e) {
      return {
        "Id": e.unconfirmedid,
        "reftabledataid": e.id,
        "reftableid": e.tableid,
        "refoptionid": e.refoptionid,
        "docapprvlstatus": apprvlStatus,
        "transno": e.transno,
        "transdate":
            BaseDates(convertDateTimePtBR(e.transdate)).dbformatWithTime,
        "reflastmoddate": e.lastmoddate,
        //"2022-02-26",
        //BaseDates(DateTime.parse(e.transdate)).format,
        "apprlforthistransonly": "Y",
        "optioncode": optionCode
      };
    }).toList();

    jsonArr = {
      "dataList": unconfirmedDetailList,
      "extensionDataObj": [],
      "screenNoteDataObj": [],
      "screenFieldDataApprovalInfoObj": [],
      "docAttachReqYN": false,
      "docAttachXml": "",
      "checkListDataObj": []
    };
    String service = "putdata";
    String url = "/security/controller/trn/saveunconfirmedtransaction";
    var request = json.encode(jsonArr);

    List jssArr = List();
    jssArr.add(request);
    print(jssArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        uuid: 0,
        userid: 0,
        chkflag: "N",
        compressdyn: false,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              if (responseJson.statusMessage.contains("Success") &&
                  responseJson.result)
                onRequestSuccess()
              else
                onRequestFailure(
                    UnnamedException(responseJson.statusMessage))
            });
  }

  setNotificationAsRead(
      {var optionId,
      var transTableId,
      var transId,
      var notificationOptionId,
      @required Function(bool) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlList = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "TransTableId", value: "$transTableId")
        .addElement(key: "TransId", value: "$transId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(
          key: "NotificationOptionId",
          value: "$notificationOptionId",
        )
        .buildElement(appendFlag: false);

    xmlList = xml.replaceAll("> </List>", "/>");

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "COUNT_UPDATE",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          var responseJson = NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode != 0 &&
              result.containsKey("resultObject")) {
            var response = BaseJsonParser.goodList(result, "resultObject");
            if (response?.isNotEmpty ?? false) {
              var output = response.first;
              onRequestSuccess(
                output["output"] == "SUCCESS",
              );
            } else {
              onRequestSuccess(
                false,
              );
            }
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getApprovalTypes(
      {int selectedBranchId,
      @required Function(List<ActionTaken> approvalTypes) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
//  String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(USERID_KEY);
    String service = "getdata";

    String xmlDocApproval = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "DOC_APPRVL_STATUS")
        .addElement(key: "CompanyId", value: "$companyId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "appTypeDetails",
            xmlStr: xmlDocApproval,
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          ActionModel responseJson = ActionModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('appTypeDetails')) {
            onRequestSuccess(responseJson.actonTaken);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
