import 'dart:convert';

import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grade_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_detail_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/process_from_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

class GradingCostingRepository extends BaseRepository {
  static final GradingCostingRepository _instance =
      GradingCostingRepository._();

  GradingCostingRepository._();

  factory GradingCostingRepository() => _instance;

  getProcessFromList(
      {@required
          GINFilterModel filterData,
      @required
          Function(List<ProcessFromGinList> processGinList) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int supplierId = filterData?.supplier.id;
    String transNo = filterData?.transNo;
    DateTimeRange rangeData = filterData?.dateRange;
    String service = "getdata";
    String finalXml;
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: finalXml,
            procName: "GradingListProc",
            actionFlag: "LIST",
            subActionFlag: "PROCESS_FROM_LIST")
        .callReq();

    String url = "/inventory/controller/trn/getgradingdetailsusingproc";

    ProcessFromGINListModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ProcessFromGINListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.processFromGinList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  // [{"flag":"ALL","SOR_Id":1,"EOR_Id":5,"TotalRecords":5,
  // "start":0,"limit":"10","value":0,"colName":"id","params":[],
  // "dropDownParams":[{"list":"ITEM-LOOKUP",
  // "procName":"grademstlistproc","key":"resultObject","actionFlag":"GRADE","subActionFlag":""}]}]
  getGrades(
      {int sor_Id,
      int eor_Id,
      int totalRecords,
      @required
          Function(List<GradeLookupItem> gradeLookupList) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": 0,
      "limit": "10",
      "value": 0,
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "colName": "id",
      "params": [],
      "dropDownParams": [
        {
          "list": "ITEM-LOOKUP",
          "procName": "grademstlistproc",
          "key": "resultObject",
          "actionFlag": "GRADE",
          "subActionFlag": ""
        }
      ]
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/cmn/getdropdownlist";

    GradeLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = GradeLookupModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.lookupItems)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getGradeRate(
      {int itemId,
      int gradeId,
      @required Function(List<GradeRateList> gradeRateList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "ItemId", value: "${itemId}")
        .addElement(key: "GradeId", value: "${gradeId}")
        .addElement(key: "Wefdate", value: BaseDates(DateTime.now()).formatDate)
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xml,
            procName: "GetItemGradeRateProc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";

    GradeRateModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = GradeRateModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.gradeRateList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getRefreshList(
      {@required GINFilterModel filterData,
      @required Function(List<ProcessFromGinList> processList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int supplierId = filterData.supplier?.id;
    String transNo = filterData?.transNo ?? "";
    // DateTimeRange rangeData = filterData?.dateRange;
    String service = "getdata";

    List jssArr = [
      {
        "flag": "ALL",
        // "SOR_Id": 973,
        // "EOR_Id": 973,
        // "TotalRecords": 1,
        "start": 0,
        "limit": "10",
        "value": 0,
        "params": [
          {
            "column": "DateFrom",
            "value": "${BaseDates(filterData?.fromDate).dbformat}"
          },
          {
            "column": "DateTo",
            "value": "${BaseDates(filterData?.toDate).dbformat}"
          },
          {"column": "OptionFlag", "value": "GRN_KHAT"},
          if (supplierId != null)
            {"column": "SupplierId", "value": "${supplierId}"},
          if (transNo != null && transNo.isNotEmpty)
            {"column": "TransNo", "value": "%$transNo%}"},
        ]
      }
    ];

    // DropDownParams()
    //     .addParams(
    //         list: "EXEC-PROC",
    //         key: "resultObject",
    //         xmlStr: "<DATA>" + xmlProcessFrom + "</DATA>",
    //         procName: "GradingListProc",
    //         actionFlag: "LIST",
    //         subActionFlag: "PROCESS_FROM_LIST")
    //     .callReq();
    // String url = "/security/controller/cmn/getdropdownlist";
    String url = "/inventory/controller/trn/getgradingdetailsusingproc";

    ProcessFromGINListModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ProcessFromGINListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.processFromGinList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  // getFilterList(
  //     {@required GINFilterModel filterData,
  //       @required Function(List<GardingViewList> gradingViewListResult) onRequestSuccess,
  //       @required Function(AppException exception) onRequestFailure}) async {
  //   String ssnId = await BasePrefs.getString(SSNIDN_KEY);
  //   // int supplierId = filterData.supplier.id;
  //   // String transNo = filterData?.transNo ?? "";
  //   // DateTimeRange rangeData = filterData?.dateRange;
  //   String service = "getdata";
  //
  //   List jssArr = [
  //     {
  //       "flag": "ALL",
  //       "start": 0,
  //       "limit": "10",
  //       "value": 0,
  //       "params": [
  //         {
  //           "column": "DateFrom",
  //           "value": "${BaseDates(filterData?.fromDate).dbformat}"
  //         },
  //         {
  //           "column": "DateTo",
  //           "value": "${BaseDates(filterData?.toDate).dbformat}"
  //         },
  //         {"column": "OptionFlag", "value": "GRN_KHAT"}
  //       ]
  //     }
  //   ];
  //   String url = "/inventory/controller/trn/getgradingdetailsusingproc";
  //
  //   GradingViewListModel responseJson;
  //
  //   performRequest(
  //       service: service,
  //       jsonArr: jssArr,
  //       url: url,
  //       onRequestFailure: onRequestFailure,
  //       onRequestSuccess: (result) => {
  //         responseJson = GradingViewListModel.fromJson(result),
  //         if (responseJson.statusCode == 1)
  //           onRequestSuccess(responseJson.gradingViewList)
  //         else
  //           onRequestFailure(
  //               InvalidInputException(responseJson.statusMessage))
  //       });
  // }

  getRefreshList1({
    @required GINFilterModel filterData,
    @required Function(List<ProcessFromGinList> processList) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
    int start = 0,
    int sorId,
    int eorId,
    int totalRecords,
  }) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int supplierId = filterData?.supplier?.id;
    String transNo = filterData?.transNo;

    String service = "getdata";

    final jssArr = {
      "flag": "ALL",
      if (sorId != null) "SOR_Id": 0,
      if (eorId != null) "EOR_Id": 0,
      if (totalRecords != null) "TotalRecords": 0,
      "start": 0,
      "limit": "10",
      "value": 0,
      "params": [
        {
          "column": "DateFrom",
          "value": "${BaseDates(filterData?.fromDate).dbformat}"
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(filterData?.toDate).dbformat}"
        },
        {"column": "OptionFlag", "value": "GRN_KHAT"},
        if (supplierId != null)
          {"column": "SupplierId", "value": "${supplierId}"},
        if (transNo != null && transNo.isNotEmpty)
          {"column": "TransNo", "value": "%$transNo%}"},
      ]
    };

    String url = "/inventory/controller/trn/getgradingdetailsusingproc";

    ProcessFromGINListModel responseJson;

    performRequest(
        service: service,
        jsonArr: [json.encode(jssArr)],
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ProcessFromGINListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.processFromGinList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getProcessGINFillList(
      {int id,
      @required
          Function(List<ProcessFillGradingList> gradingList) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: "$id")
        .addElement(key: "InterStateYN", value: "PURCHASE_ORDER_KHAT")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xml,
            procName: "GradingListProc",
            actionFlag: "LIST",
            subActionFlag: "PROCESS_FROM_FILL")
        .callReq();
    String url = "/inventory/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          ProcessFillGINListModel responseJson =
              ProcessFillGINListModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.processFillGradingList);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getGradingViewListDetail(
      {@required
          int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int option_Id,
      GardingViewList gdModelView,
      @required
          GINFilterModel filterModel,
      @required
          Function(GradingCostingViewDetailModel gradingCostingViewDetailModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start,
      "limit": "10",
      "value": gdModelView?.Id,
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "xmlStr": "",
      "procName": "GradingListProc",
      "actionFlag": "LIST",
      "actionSubFlag": "VIEW",
      "params": [
        {"column": "OptionId", "value": option_Id},
        {
          "column": "DateFrom",
          "value": "${BaseDates(filterModel.fromDate).dbformatWithTime}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(filterModel.toDate).dbformatWithTime}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
      ],
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/trn/getgradingviewusingproc";

    GradingCostingViewDetailModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = GradingCostingViewDetailModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getGradingViewList(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      int option_Id,
      @required
          GINFilterModel filterModel,
      //@required Function(List<PurchaseViewList> ledgerList) onRequestSuccess,
      @required
          Function(GradingViewListModel gradingViewListModel) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "Id",
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "xmlStr": "",
      "procName": "GradingListProc",
      "actionFlag": "LIST",
      "actionSubFlag": "VIEW",
      "params": [
        {"column": "OptionId", "value": option_Id},
        {
          "column": "DateFrom",
          "value": "${BaseDates(filterModel?.fromDate).dbformatWithTime}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(filterModel?.toDate).dbformatWithTime}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        if ((filterModel?.transNo?.isNotEmpty ?? false) &&
            (filterModel?.transNo != null))
          {
            "column": "TransNo",
            "value": "%${filterModel?.transNo}%",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": null
          },
        if (filterModel.supplier != null)
          {
            "column": "SupplierId",
            "value": "${filterModel?.supplier?.id}",
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        if (filterModel?.supplier != null)
          {"value": "${filterModel.supplier?.name}", "sortorder": null}
      ],
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/trn/getgradingviewusingproc";

    GradingViewListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = GradingViewListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getCurrencyExchange(
      {@required Function(List<CurrencyExchange> currencyEX) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "CompanyId", value: "$companyId")
        .addElement(key: "CurrencyId", value: "1")
        .addElement(
          key: "Date",
          value: BaseDates(DateTime.now()).dbformat,
        )
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "CURRENCY_DROPDOWN",
            key: "currencyExchRateList",
            xmlStr: "<DATA>" + xmlStatus + "</DATA>",
            procName: "CurrencyListProc",
            actionFlag: "LIST",
            subActionFlag: "EXCHRATE")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          CurrencyExchangeModel responseJson =
              CurrencyExchangeModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.currencyEx);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void saveGradingCosting(
      {List<CurrencyExchange> currencyEx,
      List<ProcessFillGradingList> gradingList,
      List<GradeModel> gradeModel,
      List<ItemDetailModel> itemDtl,
      int optionId,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String attachmentXml}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int fcCurrencyId = await BasePrefs.getInt(BaseConstants.BRANCH_CURRENCY_ID);
    int lcCurrencyId =
        await BasePrefs.getInt(BaseConstants.COMPANY_BASE_CURRENCY_ID);

    String date = BaseDates(DateTime.now()).dbformatWithTime;

    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    double findExchangeRate() {
      var exrate;
      currencyEx.forEach((element) {
        if (element.fromcurrencyid == fcCurrencyId &&
            element.tocurrencyid == lcCurrencyId) {
          print("exe${element.conversionrate}");
          exrate = element.conversionrate;
        }
      });
      return exrate;
    }

    var exRate = findExchangeRate();
    // var exchangeRate = double.parse(exRate?.toStringAsFixed(2));
    // print(exchangeRate);
    var supplierId;
    gradingList.forEach((e) {
      supplierId = e?.supplierid ?? 1;
      print("SupplierId ${supplierId}");
      return supplierId;
    });

    var dtlDataList = [];
    if (itemDtl != null)
      itemDtl?.forEach((element) {
        element.gradeModelData?.forEach((gradeData) {
          dtlDataList.add({
            "Id": 0,
            "optionid": optionId,
            "itemid": element.itemId,
            "dtlisblockedyn": "N",
            "exchrate": exRate ?? 1.0,
            "fccurrencyid": fcCurrencyId,
            "gradeid": gradeData.gradeLookupData.id,
            "lcrate": gradeData.rate,
            "lctotalvalue": (gradeData.rate * gradeData.qty).roundToDouble(),
            "qty": gradeData.qty,
            "rate": gradeData.rate,
            "totalvalue": (gradeData.rate * gradeData.qty).roundToDouble(),
            "uomid": element.uomId,
            "uomtypebccid": element.uomTypeBccId,
            "dtlDtoList": [
              {
                "Id": 0,
                "generatedqty": gradeData.qty,
                "generateduomid": element.uomId,
                "generateduomtypebccid": element.uomTypeBccId,
                "optionid": optionId,
                "refhdrtabledataid": element.parentTableDataId,
                "refhdrtableid": element.parentTableId,
                "reftabledataid": element.id,
                "reftableid": element.itemTableId
              }
            ]
          });
        });
      });

    jsonArr = {
      "Id": 0,
      "optionid": optionId,
      "branchid": branchId,
      "amendmentno": 0,
      "amendedfromoptionid": optionId,
      "companyid": companyId,
      "dtlDtoList": dtlDataList,
      "recordstatus": "A",
      "exchrate": exRate ?? 1.0,
      "fccurrencyid": fcCurrencyId,
      "finyearid": finyearId,
      "isblockedyn": "N",
      "lccurrencyid": lcCurrencyId,
      "remarks": "",
      "supplierid": supplierId ?? 1,
      "transdate": date,
    };

    String service = "putdata";
    String url = "/inventory/controller/trn/gradingsave";
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];

    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";

    jsonArr["checkListDataObj"] = [];
    jsonArr.removeWhere((key, value) => key == null || value == null);

    var request = json.encode(jsonArr);

    List jssArr = List();

    jssArr.add(request);
    print(jsonArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        userid: 0,
        uuid: 0,
        chkflag: "N",
        compressdyn: false,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  responseJson.statusMessage == "Success")
                {onRequestSuccess()}
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  void editSaveGradingCosting(
      {List<CurrencyExchange> currencyEx,
      GradingCostingViewDetailModel gclist,
      List<ProcessFillGradingList> gradingList,
      List<GradeModel> gradeModel,
      List<ItemDetailModel> itemDtl,
      int optionId,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String attachmentXml}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int fcCurrencyId = await BasePrefs.getInt(BaseConstants.BRANCH_CURRENCY_ID);
    int lcCurrencyId =
        await BasePrefs.getInt(BaseConstants.COMPANY_BASE_CURRENCY_ID);

    String date = BaseDates(DateTime.now()).dbformatWithTime;

    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    double findExchangeRate() {
      var exrate;
      currencyEx.forEach((element) {
        if (element.fromcurrencyid == fcCurrencyId &&
            element.tocurrencyid == lcCurrencyId) {
          print("exe${element.conversionrate}");
          exrate = element.conversionrate;
        }
      });
      return exrate;
    }

    var exRate = findExchangeRate();
    var exchangeRate = double.parse(exRate?.toStringAsFixed(2) ?? "1.00");
    print(exchangeRate);
    var supplierId;
    gclist.gradingDetailViewList.forEach((e) {
      supplierId = e?.supplierid ?? 1;
      print("SupplierId $supplierId");
      return supplierId;
    });

    var dtlDataList = [];
    if (gclist != null)
      gclist.gradingDetailViewList.forEach((e) {
        gclist.gradingDetailViewList.first.gradingDtlJson.forEach((element) {
          // element.gradeModelData?.forEach((gradeData) {
          dtlDataList.add({
            "Id": element.id,
            "optionid": optionId,
            "itemid": element.itemid,
            "dtlisblockedyn": "N",
            "exchrate": exRate ?? 1.0,
            "fccurrencyid": fcCurrencyId,
            "gradeid": element.gradeid,
            "lcrate": element.rate,
            "lctotalvalue": (element.rate * element.qty),
            "qty": element.qty,
            "rate": element.rate,
            "totalvalue": (element.rate * element.qty),
            "uomid": element.uomId,
            "uomtypebccid": element.uomTypeBccId,
            "dtlDtoList": [
              {
                "Id": element.sourcemappingdtljson.first.id,
                "generatedqty": element.sourcemappingdtljson.first.generatedqty,
                "generateduomid":
                    element.sourcemappingdtljson.first.generateduomid,
                "generateduomtypebccid":
                    element.sourcemappingdtljson.first.generateduomtypebccid,
                "optionid": optionId,
                "refhdrtabledataid":
                    element.sourcemappingdtljson.first.refhdrtabledataid,
                "refhdrtableid":
                    element.sourcemappingdtljson.first.refhdrtableid,
                "reftabledataid":
                    element.sourcemappingdtljson.first.reftabledataid,
                "reftableid": element.sourcemappingdtljson.first.reftableid,
              }
            ]
          });
        });

        jsonArr = {
          "Id": e.Id,
          "optionid": optionId,
          "branchid": branchId,
          "amendmentno": e.amendmentno,
          "amendedfromoptionid": optionId,
          "companyid": companyId,
          "dtlDtoList": dtlDataList,
          "recordstatus": "A",
          "exchrate": exRate ?? 1.0,
          "fccurrencyid": fcCurrencyId,
          "finyearid": finyearId,
          "isblockedyn": "N",
          "lccurrencyid": lcCurrencyId,
          "remarks": "",
          "supplierid": supplierId,
          "transdate": date,
        };
      });

    String service = "putdata";
    String url = "/inventory/controller/trn/gradingsave";
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];

    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";

    jsonArr["checkListDataObj"] = [];
    jsonArr.removeWhere((key, value) => key == null || value == null);

    var request = json.encode(jsonArr);

    List jssArr = List();

    jssArr.add(request);
    print(jsonArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        userid: 0,
        uuid: 0,
        chkflag: "N",
        compressdyn: false,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  responseJson.statusMessage == "Success")
                {onRequestSuccess()}
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
    // });
  }
}
