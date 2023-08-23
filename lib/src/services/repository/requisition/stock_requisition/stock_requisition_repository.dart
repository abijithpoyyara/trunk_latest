import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

class StockRequisitionRepository extends BaseRepository {
  static final StockRequisitionRepository _instance =
      StockRequisitionRepository._();

  StockRequisitionRepository._();

  factory StockRequisitionRepository() => _instance;

  Future<void> getApprovalStatus(
      {@required Function(List<TransactionStatusItem>) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "STK_REQ_STATUS")
        .addElement(key: "CompanyId", value: "$companyId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "statusObject",
            xmlStr: xmlStatus,
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    TransactionStatusModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = TransactionStatusModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.status)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getItems(
      {@required int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      @required PVFilterModel filterModel,
      @required Function(List<ItemLookupItem> items) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": 0,
      "limit": "500000",
      "value": 0,
      "SOR_Id": 0,
      "EOR_Id": 0,
      "TotalRecords": totalRecords,
      "Key": 50,
      "params": [],
      "dropDownParams": [
        {
          "list": "ITEM-LOOKUP",
          "procName": "ItemMstProc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "ITEMS"
        }
      ]
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/cmn/getdropdownlist";

    ItemLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemLookupModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.lookupItems)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getItemBudget(
      {@required int optionId,
      @required int itemId,
      @required Function(List<BudgetDtlModel> budgetlist) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlList = XMLBuilder(tag: "List")
        .addElement(key: "Date", value: "${BaseDates(DateTime.now()).dbformat}")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();

    String xmlItem = XMLBuilder(tag: "Item")
        //.addElement(key: "DepartmentId", value: "16")
        .addElement(key: "DepartmentId", value: "$departmentId")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "ItemId", value: "$itemId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlList + xmlItem,
            procName: "getFinancialbudgetproc",
            actionFlag: "LIST",
            subActionFlag: "ITEMWISE")
        .callReq();

    String url = "/gl/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List budgetList = BaseJsonParser.goodList(result, 'resultObject')
                .map((e) => BudgetDtlModel.fromJson(e))
                .toList();
            onRequestSuccess(budgetList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getStockView(
      {@required start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value,
      @required SRFilterModel filterModel,
      @required Function(StockViewListModel ledgerList) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "SOR_Id": sor_Id,
      "EOR_Id": eor_Id,
      "TotalRecords": totalRecords,
      "Key": "33",
      "params": [
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
          ""
              "restriction": "EQU",
          "sortorder": null
        },
        // if (filterModel.reqNo != null)
        //   {
        //     "column": "RequestNo",
        //     "value": "%${filterModel.reqNo}%",
        //     "datatype": "STR",
        //     "restriction": "LIKE",
        //     "sortorder": null
        //   },
        if (filterModel.location != null)
          {
            "column": "TargetBusinessLevelTableId",
            "value": "${filterModel?.location?.tableid}",
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        if (filterModel?.location != null)
          {
            "column": "TargetBusinessLevelTableDataId",
            "value": filterModel?.location?.id,
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        {
          "column": "OwnBranchYN",
          "value": "Y",
          "datatype": "INT",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "OtherBranchYN",
          "value": "Y",
          "datatype": "INT",
          "restriction": "EQU",
          "sortorder": null
        }
      ],
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/trn/getstockrequisition";

    StockViewListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = StockViewListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getSelectedStockView(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      StockViewList stockList,
      @required
          SRFilterModel filterModel,
      @required
          Function(SelectedStockViewModel stockViewListModel) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start,
      "limit": "10",
      "value": stockList?.id,
      "SOR_Id": sor_Id,
      "EOR_Id": eor_Id,
      "TotalRecords": totalRecords,
      "Key": "33",
      "colName": "Id",
      "params": [
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
        {
          "column": "OwnBranchYN",
          "value": "Y",
          "datatype": "INT",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "OtherBranchYN",
          "value": "Y",
          "datatype": "INT",
          "restriction": "EQU",
          "sortorder": null
        }
      ],
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/trn/getstockrequisition";

    SelectedStockViewModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = SelectedStockViewModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getStockViewDetails({@required StockViewList stockList}) async {
    String service = "getdata";
  }

  getLocationObjects(
      {@required
          Function(List<StockLocation>, List<StockLocation>, int)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);

    String xmlStatus = XMLBuilder(tag: "DropDown")
        .addElement(
            key: "OptionBusinessLevelCode", value: "INVENTORY_BILLING_LEVEL")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "locationObject",
            xmlStr: xmlStatus,
            procName: "BusinessSubLevelProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          StockLocationModel responseJson = StockLocationModel.fromJson(result);
          print("branch Id $branchId");
          if (responseJson.statusCode == 1) {
            List<StockLocation> sourceLocations = responseJson.location
                .where((e) => e.branchid == branchId)
                .toList();

            onRequestSuccess(
                responseJson.location, sourceLocations, locationId);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void saveRequisition({
    List<StockRequisitionModel> requisitionItems,
    SelectedStockViewModel stoItem,
    int statusBccid,
    int optionId,
    String remarks,
    StockLocation sourceLocation,
    StockLocation targetLocation,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
    String attachmentXml,
    int stockReqId,
  }) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    String date = BaseDates(DateTime.now()).dbformatWithTime;
    String dateWithOutTime = BaseDates(DateTime.now()).dbformat;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    jsonArr = {
      "Id": stockReqId == 0 ? 0 : stoItem?.stockViewList?.first?.id,
      "optionid": optionId,
      "optioncode": "STOCK REQUISITION",
      "transactionuniqeid":
          stockReqId == 0 ? 0 : stoItem.stockViewList.first.transactionuniqeid,
      "amendmentno":
          stockReqId == 0 ? 0 : stoItem.stockViewList.first.amendmentno,
      "amendmentdate": date,
      "amendedfromoptionid": null,
      "finyearid": finYearId,
      "requestno": stockReqId == 0 ? "" : stoItem.stockViewList.first.requestno,
      "requestdate": date,
      "sourcebusinesslevelcodeid": sourceLocation.businesslevelcodeid,
      "sourcebusinessleveltableid": sourceLocation.tableid,
      "sourcebusinessleveltabledataid": sourceLocation.id,
      "targetbusinesslevelcodeid": targetLocation.businesslevelcodeid,
      "targetbusinessleveltableid": targetLocation.tableid,
      "targetbusinessleveltabledataid": targetLocation.id,
      "createduserid": userId,
      "departmentid": departmentId,
      "createddate": BaseDates(DateTime.now()).dbformatWithTime,
      "approvedby": null,
      "approveddate": null,
      "isblockedyn": "N",
      "docapprvlstatus": null,
      "remarks": remarks,
      "recordstatus": "A",
      "statusdate": date,
      "statusbccid": statusBccid,
    };

    String service = "putdata";
    String url = "/inventory/controller/trn/stockrequisitionsave";

    jsonArr["item_ListData"] = requisitionItems
        .map((item) => {
              "Id": stockReqId == 0 ? 0 : item.detailId,
              "optionid": optionId,
              "budgetDtl": [
                {
                  "actualamount": item.budgetDtl?.actual,
                  "branchid": branchId,
                  "budgetdate": dateWithOutTime,
                  "budgetedamount": item.budgetDtl?.budgeted,
                  "departmentid": departmentId,
                  "Id": item.budgetDtl.id,
                  "inprogressamount": item.budgetDtl?.inprocess,
                  "itemid": item.budgetDtl.itemid,
                  "optionid": optionId,
                  "qty": item.qty,
                  "rate": item.budgetDtl?.itemcost,
                  "remainingamount": item.budgetDtl?.remaining ?? 0,
                  "totalvalue": double.parse(
                      ((item.qty * item.budgetDtl?.itemcost))
                          .toStringAsFixed(2)),
                  /*((item.qty ?? 1 * item.budgetDtl?.itemcost?? 0) ?? 0)
                              ?.toStringAsFixed(2)) ?? 0,*/
                }
              ],
              // "id": item.detailId,
              "itemid": item.budgetDtl.itemid,
              "uomtypebccid": item.uom.uomtypebccid,
              "uomid": item.uom.uomid,
              "qty": item.qty,
              // "remarks": stockReqId == 0 ? "" : null,
              "statusbccid": statusBccid,
              "statusdate": date,
              "approvedqty": 0,
              "dtlapprovedby": null,
              "dtlapproveddate": null,
              "dtlisblockedyn": "N",
              "dtldocapprovalstatus": "",
              "source_Mapping": []
            })
        .toList();
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];
    if (attachmentXml != null) {
      jsonArr["docAttachReqYN"] = false;
      jsonArr["docAttachXml"] = attachmentXml;
    }

    jsonArr["checkListDataObj"] = [];

    var request = json.encode(jsonArr);

    List jssArr = List();
    jssArr.add(request);
    print(jsonArr);
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
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getStockDetails(int itemId,
      {Function(List<StockDetail>) onRequestSuccess,
      Function(AppException) onRequestFailure}) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "AsonDateorForAPeriod", value: "ASONDATE")
        .addElement(key: "AsOnDate", value: BaseDates(DateTime.now()).dbformat)
        .addElement(key: "OpeningClosing", value: "Closing")
        .addElement(key: "Stocktype", value: "ALL")
        .addElement(key: "Flag", value: "STOCK_REQ")
        .addElement(key: "FinyearId", value: "$finYearId")
        .buildElement();
    xmlStatus += XMLBuilder(tag: "Item")
        .addElement(key: "ItemId", value: "$itemId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "stockObject",
            xmlStr: xmlStatus,
            procName: "GetStockProc",
            actionFlag: "LIST",
            subActionFlag: "STOCK_DETAILS")
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          StockDetailModel responseJson = StockDetailModel.fromJson(result);

          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.stocks);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
