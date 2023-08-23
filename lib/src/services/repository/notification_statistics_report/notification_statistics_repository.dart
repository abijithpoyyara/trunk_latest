import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/states/notification_statistics_report/notification_statistics_state.dart';
import 'package:redstars/src/services/model/response/lookups/analysis_code_user_lookup_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_detail_data_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_object_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/initial_data_list_model.dart';

import '../../../../utility.dart';

class NotificationStatisticsRepository with BaseRepository {
  static final NotificationStatisticsRepository _instance =
      NotificationStatisticsRepository._();

  NotificationStatisticsRepository._();

  factory NotificationStatisticsRepository() => _instance;

  getInitialConfigs(
      {@required
          Function({
        List<BCCModel> voucherTypes,
        List<BCCModel> numberTypes,
        // List<BCCModel> sortingTypes,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "voucherTypes",
            xmlStr: XMLBuilder(tag: "DropDown ")
                .addElement(key: "DrorCr ", value: "C")
                .addElement(key: "CompanyId ", value: "$companyId")
                .addElement(key: "BranchId", value: "$branchId")
                .buildElement(),
            procName: "VoucherCodeListProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "VCH_CODE_RIGHTS")
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "resultObject",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode ", value: "NUMBER_FILTER")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();
    String url = "/ap/controller/cmn/getdropdownlist";
    String service = "getdata";
    PaymentVoucherConfigModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PaymentVoucherConfigModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(
                  voucherTypes: responseJson.voucherTypes,
                  numberTypes: responseJson.numberTypes,
                  // sortingTypes: responseJson.sortingTypes
                )
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getSortList(
      {@required
          Function({
        List<BCCModel> sortingTypes,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "resultObject",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode ", value: "SORT_BY")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();
    String url = "/ap/controller/cmn/getdropdownlist";
    String service = "getdata";
    PaymentVoucherConfigModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PaymentVoucherConfigModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(sortingTypes: responseJson.sortingTypes)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  fetchAnalysisUserList(
      {@required String procedure,
      @required String actionFlag,
      @required Function(LookupModel lookupModel) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String actionSubFlag,
      int start = 0,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0, 
      String searchQuery}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    String service = "getdata";

    List params = [
      {
        "column": "Name",
        "value": "",
        "datatype": "STR",
        "restriction": "ILIKE",
        "sortorder": null
      },
    ];
    List searchParams = [
      {
        "column": "Name",
        "value": "%${searchQuery}%",
        "datatype": "STR",
        "restriction": "ILIKE",
        "sortorder": null
      }
    ];

    var searchReq = {
      "flag": "ALL",
      "start": 0,
      "limit": "100000",
      "value": 0,
      "colName": "name",
      "params": params,
    };

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "100000",
      "value": value,
      "colName": "Id",
      "params": searchQuery.isNotEmpty ? searchParams : params,
      "dropDownParams": [
        {
          "list": "SERVICE-LOOKUP",
          "key": "resultObject",
          "procName": "analysiscodelistproc",
          "actionFlag": "LIST",
          "subActionFlag": "ANALYSISCODE"
        }
      ]
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/ap/controller/cmn/getdropdownlist";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = AnalysisCodeUserModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getInitialData({
    @required
        Function(
      List<NotificationStatisticsObject> notificationObj,
      List<NotificationStatisticeReportObject> reportObjList,
      List<NotificationStatisticeUserList> userList,
    )
            onRequestSuccess,
    @required
        Function(AppException) onRequestFailure,
  }) async {
    String xmlStr1 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "ALL")
        .addElement(key: "WithoutCount", value: "Y")
        .buildElement();

    String xmlStr2 = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "NOTIFY_STATISTICS_RPTTYPE")
        .addElement(key: "CodeName", value: "Code")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          actionFlag: "LIST",
          key: "userObj",
          list: "EXEC-PROC",
          procName: "userlistproc",
          // removeAll: false,
          // store: "userStore",
          subActionFlag: "",
          xmlStr: "",
        )
        .addParams(
          actionFlag: "LIST",
          key: "notificationObj",
          list: "EXEC-PROC",
          procName: "NotificationListProc",
          // store: "notificationListStore",
          subActionFlag: "SUMMARY",
          xmlStr: xmlStr1,
        )
        .addParams(
          actionFlag: "LIST",
          key: "reportObj",
          list: "BAYACONTROLCODES-DROPDOWN",
          procName: "bayacontrolcodelistproc",
          // removeAll: false,
          // store: "reportTypeStore",
          subActionFlag: "",
          xmlStr: xmlStr2,
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
          NotificationStatisticsObjectModel responseJson =
              NotificationStatisticsObjectModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            List userList = BaseJsonParser.goodList(result, 'userObj')
                .map((e) => NotificationStatisticeUserList.fromJson(e))
                .toList();
            List reportObjList = BaseJsonParser.goodList(result, 'reportObj')
                .map((e) => NotificationStatisticeReportObject.fromJson(e))
                .toList();
            List notificationObjList =
                BaseJsonParser.goodList(result, 'notificationObj')
                    .map((e) => NotificationStatisticsObject.fromJson(e))
                    .toList();
            onRequestSuccess(notificationObjList, reportObjList, userList);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  getReportData({
    String count,
    String voucher,
    NotificationStatisticsState notificationStatisticsState,
    String fromDate,
    String toDate,
    String selectedReport,
    int start = 0,
    int limit,
    int reportId,
    int notifId,
    int userId,
    int accountId,
    int numberFieldId,
    int sortByBccId,
    @required
        Function(NotificationStatisticsDetailDataModel notificationDetail)
            onRequestSuccess,
    @required Function(AppException) onRequestFailure,
  }) async {
    DateTime currentDate = DateTime.now();
    String stringCurrDate = currentDate.toString().substring(0, 10);
    String startDate = DateTime(currentDate.year, currentDate.month, 1)
        .toString()
        .substring(0, 10);
    print(userId);
    print(accountId);
    String xmltrans = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        // .addElement(key: "SortByBccId", value: "${sortByBccId ?? 1561}")
        .buildElement();
    String xmlSort = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "SortByBccId", value: "${sortByBccId}")
        .buildElement();
    String xmlCount = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "Count", value: "$count")
        // .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();
    String xmlSC = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();
    String xmlCNS = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();
    String xmltransCount1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();

    String xmltransSort1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();
    String xmltransSort2 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();
    String xmltransVou = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .buildElement();

    String xmltransVouSort = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmltransVouCount = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "Count", value: "$count")
        // .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();
    String xmltransVouCount1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();
    String xmltransVouSort3 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmluser = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();
    String xmluserCount = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "Count", value: "$count")
        // .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();
    String xmluserCount1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmlUserSort = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmluserSort1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmluserSort2 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .addElement(key: "Count", value: "$count")
        .buildElement();

    String xmlAccount = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "AccountId", value: "$accountId")
        .buildElement();
    String xmlAccountCount = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "Count", value: "$count")
        // .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();
    String xmlAccountCount1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmlAccountSort1 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .buildElement();

    String xmlAccountSort3 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmlAccountSort2 = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();

    String xmlAccountTransSort = XMLBuilder(tag: "Report")
        .addElement(key: "ReportTypeBccId", value: "$reportId")
        .addElement(key: "Start", value: "$start")
        .addElement(key: "Limit", value: "$limit")
        .addElement(key: "DateFrom", value: "${fromDate ?? stringCurrDate}")
        .addElement(key: "DateTo", value: "${toDate ?? startDate}")
        .addElement(key: "FilterFlag", value: "SUMMARY")
        .addElement(key: "NotificationId", value: "$notifId")
        .addElement(key: "TransNo", value: "$voucher")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "Count", value: "$count")
        .addElement(key: "NumberFilterBccId", value: "$numberFieldId")
        .addElement(key: "SortByBccId", value: "$sortByBccId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: 'resultObject',
            procName: "RptNotificationStatisticsProc",
            actionFlag: "REPORT",
            subActionFlag: "DATA",
            xmlStr: (userId == null &&
                    accountId == null &&
                    voucher == null &&
                    count == null &&
                    numberFieldId == null &&
                    sortByBccId == null)
                ? xmltrans
                : accountId != null &&
                        count != null &&
                        numberFieldId != null &&
                        sortByBccId != null
                    ? xmlAccountCount1
                    : userId != null &&
                            count != null &&
                            numberFieldId != null &&
                            sortByBccId != null
                        ? xmluserCount1
                        : voucher != null &&
                                count != null &&
                                numberFieldId != null &&
                                sortByBccId != null
                            ? xmltransVouSort3
                            : accountId != null &&
                                    count != null &&
                                    numberFieldId != null
                                ? xmlAccountSort1
                                : accountId != null &&
                                        count != null &&
                                        sortByBccId != null
                                    ? xmlAccountSort3
                                    : userId != null &&
                                            count != null &&
                                            numberFieldId != null
                                        ? xmluserSort2
                                        : voucher != null &&
                                                count != null &&
                                                numberFieldId != null
                                            ? xmltransVouCount1
                                            : numberFieldId != null &&
                                                    count != null &&
                                                    sortByBccId != null
                                                ? xmlCNS
                                                : voucher != null &&
                                                        sortByBccId != null
                                                    ? xmltransVouSort
                                                    : userId != null &&
                                                            count != null
                                                        ? xmluserCount
                                                        : accountId != null &&
                                                                count != null
                                                            ? xmlAccountCount
                                                            : voucher != null &&
                                                                    count !=
                                                                        null
                                                                ? xmltransVouCount
                                                                : numberFieldId !=
                                                                            null &&
                                                                        count !=
                                                                            null
                                                                    ? xmltransCount1
                                                                    : sortByBccId !=
                                                                                null &&
                                                                            count !=
                                                                                null
                                                                        ? xmlSC
                                                                        : userId != null &&
                                                                                sortByBccId != null
                                                                            ? xmlUserSort
                                                                            : accountId != null && sortByBccId != null
                                                                                ? xmlAccountSort2
                                                                                : userId != null
                                                                                    ? xmluser
                                                                                    : voucher != null
                                                                                        ? xmltransVou
                                                                                        : accountId != null
                                                                                            ? xmlAccount
                                                                                            : count != null
                                                                                                ? xmlCount
                                                                                                : sortByBccId != null
                                                                                                    ? xmlSort
                                                                                                    : xmlCNS)
        .callReq();

    // (userId == null && accountId == null)
    //   ? (voucher == null
    //       ? (count == null &&
    //               numberFieldId == null &&
    //               sortByBccId == null
    //           ? xmltrans
    //           : sortByBccId != null &&
    //                   count == null &&
    //                   userId == null &&
    //                   accountId == null &&
    //                   numberFieldId == null
    //               ? xmltransSort
    //               : count != null &&
    //                       numberFieldId == null &&
    //                       sortByBccId == null
    //                   ? xmltransCount
    //                   : xmltransCount1)
    //       : (count == null &&
    //               numberFieldId == null &&
    //               sortByBccId == null &&
    //               voucher != null
    //           ? xmltransVou
    //           : count != null && numberFieldId == null
    //               ? xmltransVouCount
    //               : count != null && sortByBccId != null
    //                   ? xmltransSort1
    //                   : numberFieldId != null && sortByBccId != null
    //                       ? xmltransSort2
    //                       : count != null &&
    //                               sortByBccId != null &&
    //                               numberFieldId != null &&
    //                               voucher != null
    //                           ? xmltransVouSort3
    //                           : count != null &&
    //                                   sortByBccId != null &&
    //                                   numberFieldId != null
    //                               ? xmlCNS
    //                               : xmltransVouCount1))
    //   : accountId != null
    //       ? (count == null &&
    //               numberFieldId == null &&
    //               sortByBccId == null
    //           ? xmlAccount
    //           : count != null &&
    //                   numberFieldId == null &&
    //                   sortByBccId == null
    //               ? xmlAccountCount
    //               : count != null && sortByBccId != null
    //                   ? xmlAccountSort1
    //                   : numberFieldId != null && sortByBccId != null
    //                       ? xmlAccountSort2
    //                       : count != null &&
    //                               numberFieldId != null &&
    //                               sortByBccId != null &&
    //                               voucher != null &&
    //                               accountId != null
    //                           ? xmlAccountTransSort
    //                           : xmlAccountCount1)
    //       : userId != null
    //           ? (count == null &&
    //                   numberFieldId == null &&
    //                   sortByBccId == null
    //               ? xmluser
    //               : count != null &&
    //                       numberFieldId == null &&
    //                       sortByBccId == null
    //                   ? xmluserCount
    //                   : count != null && sortByBccId != null
    //                       ? xmluserSort1
    //                       : numberFieldId != null &&
    //                               sortByBccId != null
    //                           ? xmluserSort2
    //                           : xmluserCount1)
    //           : (count == null && numberFieldId == null
    //               ? xmltrans
    //               : count != null && numberFieldId == null
    //                   ? xmltransCount
    //                   : xmltransCount1))

    String service = "getdata";
    print(jssArr);
    performRequest(
        service: service,
        jsonArr: jssArr,
        chkflag: "N",
        compressdyn: false,
        userid: 0,
        uuid: 0,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          NotificationStatisticsDetailDataModel responseJson =
              NotificationStatisticsDetailDataModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }
}
