import 'dart:convert';
import 'dart:developer';

import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_history_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_mainscreen_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_head_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/branch_model.dart';

import '../../../../utility.dart';

var transK;

class TransactionUnblockReqRepository extends BaseRepository {
  static final TransactionUnblockReqRepository _instance =
      TransactionUnblockReqRepository._();

  TransactionUnblockReqRepository._();

  factory TransactionUnblockReqRepository() => _instance;

  getTransactionMainScreenData({
    DateTime startDate,
    @required int optionId,
      int branchId,
      int flg,
    bool allBranch,
      @required
          Function(List<TransactionUnblockReqApprlCountList> budgetList,
                  int statusCode)
              onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    String xmlItem = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "ALL")
//        .addElement(key: "ReqFromDate", value: "$branchId")
//        .addElement(key: "ReqToDate ", value: "$acctId")
//        .addElement(key: "RequestNo", value: "$departmentId")
//        .addElement(key: "TransNo", value: "$branchId")
        .addElement(key: "OptionId ", value: "$optionId")
        .buildElement();

    log("branch id at repository level is " + branchId.toString());
    log("branch id at repository level is " + allBranch.toString());

    String xmlItem2 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "ALL")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "OptionId ", value: "$optionId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: branchId != null
                ? allBranch == true
                    ? xmlItem
                    : xmlItem2
                : xmlItem,
            procName: "TransUnblockRequestApprovalListProc",
            actionFlag: "LIST",
            subActionFlag: "SUMMARY")
        .callReq();

    String url = "/ap/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          TransactionUnblockReqApprlModel responseJson =
              TransactionUnblockReqApprlModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List budgetList = BaseJsonParser.goodList(result, 'resultObject')
                .map((e) => TransactionUnblockReqApprlCountList.fromJson(e))
                .toList();
            onRequestSuccess(budgetList, responseJson.statusCode);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getUnreadList(
      {int optionId,
      int unblockBranchId,
    int notificationOptionId,
    int notificationId,
    bool allBranchYN,
    int branchIdFromCall,
    @required Function(List<UnreadNotificationListModel>) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    log("1 $unblockBranchId");

    log("2 $branchIdFromCall");

    log("3 $branchId");
    int branch = unblockBranchId ?? branchIdFromCall;

    branch = branch ?? branchId;

    String xmlList2 = "";
    String xmlList = "";
    String xmlList1 = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "${branch}")
        .addElement(key: "NotificationOptionId", value: "$notificationOptionId")
        .addElement(key: "NotificationId", value: "$notificationId")
        .addElement(key: "AllBranchYN", value: "Y")
        .buildElement(appendFlag: false);

    String xml2 = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "${branch}")
        .addElement(key: "NotificationOptionId", value: "$notificationOptionId")
        .addElement(key: "NotificationId", value: "$notificationId")
        .buildElement(appendFlag: false);

    xmlList1 = xml.replaceAll("> </List>", "/>");
    xmlList2 = xml2.replaceAll("> </List>", "/>");

    allBranchYN == true ? xmlList = xmlList1 : xmlList = xmlList2;

    List jssArr = DropDownParams( )
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

  setNotificationAsRead(
      {int optionId,
    int transTableId,
    int transId,
      int unblockBranchId,
    int notificationId,
    @required Function( ) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    log("count is $unblockBranchId");
    String xmlList = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$notificationId")
        .addElement(key: "TransTableId", value: "$transId")
        .addElement(key: "TransId", value: "$transTableId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "${unblockBranchId ?? branchId}")
        .addElement(key: "NotificationOptionId", value: "$optionId")
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
    String  service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          var responseJson = NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess();
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getBranchTransactionsReq({
    @required Function(List<BranchesList> branchObjlist) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int userId = await BasePrefs.getInt(USERID_KEY);
    String service = "getdata";

    String xmlDocApproval = XMLBuilder(tag: "List")
        .addElement(key: "OptionBusinessLevelCode", value: "FA")
        .addElement(key: "ParentBusinessLevelCode", value: "L2")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          key: "branchObj",
          xmlStr: xmlDocApproval,
          procName: "BusinessSubLevelProc",
          actionFlag: "LIST",
          subActionFlag: "OPT_USER_BUSINESS_LEVEL_FITER",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    BranchUserListModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BranchUserListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.branchesList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getTransactionHistory({
    int tableId,
    int tableDataId,
    @required Function(List<HistoryModel> historyModel) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "RefTableId", value: "$tableId")
        .addElement(key: "RefTableDataId", value: "$tableDataId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            xmlStr: xml,
            list: "EXEC-PROC",
            key: "resultObject",
            procName: "TransUnblockRequestApprovalListProc",
            actionFlag: "LIST",
            subActionFlag: "HISTORY")
        .callReq();

    String url = "/ap/controller/cmn/getdropdownlist";
    String service = "getdata";

    ApprovalHistoryModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          responseJson = ApprovalHistoryModel.fromJson(result);
          // List historyList = BaseJsonParser.goodList(result, 'resultObject')
          //     .map((e) => ApprovalHistoryModel.fromJson(e))
          //     .toList();
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.historyModel);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getReportformatDtls(
      {@required
          int rptFormatId,
      @required
          Function(TransactionUnblockListHead budgetList) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    String xmlItem = XMLBuilder(tag: "List")
        .addElement(key: "RptFormatId ", value: "$rptFormatId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "getreportengineformatsproc",
          actionFlag: "LIST",
          subActionFlag: "DYNAMICGRID",
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
          TransactionUnblockListHead responseJson =
              TransactionUnblockListHead.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getTransactionApprovalList(
      {DateTime startDate,
      int id,
      int flg,
      int branchId,
      @required
          int optionId,
      @required
          int acctId,
      @required
          Function(TransactionUnblockListHead1 budgetList) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int user_id = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String xmlItem = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: "$id")
//        .addElement(key: "ReqFromDate", value: "2022-02-01")
//        .addElement(key: "ReqToDate ", value: "2022-02-16")
//        .addElement(key: "RequestNo", value: "%%")
//        .addElement(key: "TransNo", value: "%%")
        .addElement(key: "OptionId ", value: "$optionId")
        .addElement(key: "UserId ", value: "$user_id")
        .buildElement();

    String xmlItem2 = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: "$id")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "OptionId ", value: "$optionId")
        .addElement(key: "UserId ", value: "$user_id")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          xmlStr: branchId == null ? xmlItem : xmlItem2,
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "TransUnblockRequestApprovalListProc",
          actionFlag: "LIST",
          subActionFlag: "DETAIL",
        )
        .callReq();

    String url = "/ap/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          TransactionUnblockListHead1 responseJson =
              TransactionUnblockListHead1.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            transK = responseJson.data123;
            List budgetList = BaseJsonParser.goodList(result, 'resultObject')
                .map((e) => TransactionUnblockListView.fromJson(e))
                .toList();
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> getMobileNotification(
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

  getTransactionApprovalfilterList(
      {int id,
      bool isBranchBlocked,
      int branchId,
      @required
          int optionId,
      @required
          PVFilterModel filterModel,
      @required
          int acctId,
      String dynamicTitle,
      @required
          Function(TransactionUnblockListHead1 budgetList) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int user_id = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String xmlItem = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: "$id")
        .addElement(
            key: "ReqFromDate",
            value: "${BaseDates(filterModel.fromDate).dbformat}")
        .addElement(
            key: "ReqToDate ",
            value: "${BaseDates(filterModel.toDate).dbformat}")
        .addElement(
            key: "RequestNo",
            value:
                (filterModel.reqNo != null && filterModel.reqNo?.isNotEmpty ??
                        false)
                    ? "%${filterModel.reqNo}%"
                    : "%%")
        .addElement(
            key: "TransNo",
            value: (filterModel.transNo?.isNotEmpty ?? false)
                ? "%${filterModel.transNo}%"
                : "%%")
        .addElement(key: "OptionId ", value: "$optionId")
        .addElement(key: "BranchId ", value: "$branchId")
        .addElement(key: "UserId ", value: "$user_id")
//        .addElement(key: "OptionId ", value: "$optionId")
        .buildElement();

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: "$id")
        .addElement(
        key: "ReqFromDate",
        value: "${BaseDates(filterModel.fromDate).dbformat}")
        .addElement(
        key: "ReqToDate ",
        value: "${BaseDates(filterModel.toDate).dbformat}")
        .addElement(
        key: "RequestNo",
        value:
        (filterModel.reqNo != null && filterModel.reqNo?.isNotEmpty ??
            false)
            ? "%${filterModel.reqNo}%"
            : "%%")
        .addElement(
        key: "TransNo",
        value: (filterModel.transNo?.isNotEmpty ?? false)
            ? "%${filterModel.transNo}%"
            : "%%")
        .addElement(key: "OptionId ", value: "$optionId")
        .addElement(key: "UserId ", value: "$user_id")
        //  .addElement(key: "BranchId", value: "$branchId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          xmlStr: isBranchBlocked == true && branchId != null
              ? xmlItem
              : branchId != null
                  ? xmlItem
                  : xml,
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "TransUnblockRequestApprovalListProc",
          actionFlag: "LIST",
          subActionFlag: "DETAIL",
        )
        .callReq();

    String url = "/ap/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          TransactionUnblockListHead1 responseJson =
              TransactionUnblockListHead1.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List budgetList = BaseJsonParser.goodList(result, 'resultObject')
                .map((e) => TransactionUnblockListView.fromJson(e))
                .toList();
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void saveTransactionUnblockRequestApproval({
    int id,
    String status,
    String remark,
    DateTime Apprvdate,
    DateTime extendedDt,
    int reftabledataid,
    int reftableid,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int userId = await BasePrefs.getInt(USERID_KEY);
    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    jsonArr = {
      "Id": id,
      "reftableid": reftableid,
      "reftabledataid": reftabledataid,
      "approvedby": userId,
      "approveddate": BaseDates(Apprvdate).dbformatWithTime,
      "docapprvlstatus": status,
      "docapprvlremarks": remark,
      "dtlDtoList": [],
      "checkListDataObj": [],
      "extendeddate": status == "R" ? null : BaseDates(extendedDt).dbformat,
      "isblockedyn": "Y",
      "extensionDataObj": [],
      "screenNoteDataObj": [],
      "screenFieldDataApprovalInfoObj": [],
      "docAttachReqYN": false,
      "docAttachXml": "",
    };
    String service = "putdata";
    String url = "/security/controller/trn/updateApproval";
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
                onRequestFailure(UnnamedException(responseJson.statusMessage))
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

  getUnreadCount(
      {int branchId2,
    bool allBranchYN,
    int optionID,
      @required
          Function(List<NotificationCountDetails> unreadCount) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String clientId1 = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId1 = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int branchId3;
    branchId2 == null ? branchId3 = branchId : branchId3 = branchId2;
    String service = "getdata";
    String xmlList1 = "";
    String xmlremovedLasttag0 = "";
    String xmlremovedLasttag1 = "";
    String xmlremovedLasttag2 = "";
    log("AllBranchYN $allBranchYN");

    String xml1 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "TRANS_OPTION_WISE")
        .addElement(key: "NotificationOptionId", value: "${optionID ?? 1}")
        .addElement(key: "AllBranchYN", value: "Y")
        .buildElement(appendFlag: false);
    String xml0 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "TRANS_OPTION_WISE")
        .addElement(key: "NotificationOptionId", value: "${optionID ?? 1}")
        .addElement(key: "AllBranchYN", value: "N")
        .buildElement(appendFlag: false);
    String xml2 = XMLBuilder(tag: "User")
        .addElement(key: "Clientid", value: "$clientId1")
        .addElement(key: "UserId", value: "${userId1 ?? 1}")
        .addElement(key: "BranchId", value: "${branchId3 ?? 1}")
        .buildElement(appendFlag: false);
    xmlList1 = xml2.replaceAll("> </User>", "/>");
    xmlremovedLasttag1 = xml1.replaceAll("> </List>", "/>");
    xmlremovedLasttag2 = xml0.replaceAll("> </List>", "/>");
    allBranchYN == true
        ? xmlremovedLasttag0 = xmlremovedLasttag1
        : xmlremovedLasttag0 = xmlremovedLasttag2;
    List jssArr = DropDownParams()
        .addParams(
        list: "EXEC-PROC",
        key: "resultObject",
        xmlStr: xmlremovedLasttag0 + xmlList1  ,
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
  }
