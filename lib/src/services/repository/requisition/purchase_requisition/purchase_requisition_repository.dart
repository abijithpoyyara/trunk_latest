import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_list_view_details_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/model/purchase_requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/model/uom_object_data_model.dart';

class PurchaseRequisitionRepository extends BaseRepository {
  static final PurchaseRequisitionRepository _instance =
      PurchaseRequisitionRepository._();

  PurchaseRequisitionRepository._();

  factory PurchaseRequisitionRepository() => _instance;

  Future<void> getApprovalStatus(
      {@required Function(List<TransactionStatusItem>) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "PUR_REQ_STATUS")
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

  // url: /inventory/controller/cmn/getdropdownlist
  // jsonArr: [{"flag":"ALL","start":0,""
  // "limit":"10","value":0,"colName":"id",
  // "params":[],"dropDownParams":[{"list":"ITEM-LOOKUP",
  // "procName":"ItemMstProc","key":"resultObject",
  // "actionFlag":"LIST","subActionFlag":"ITEMS"}]}]

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

  Future<void> getInitialConfig(
      {@required Function(List<UomTypes>) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    List jssArr = DropDownParams()
        .addParams(
          list: "UOM",
          key: "uomObject",
        )
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";
    String service = "getdata";
    UomModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          UomModel responseJson = UomModel.fromJson(result);
          if (responseJson.statusCode == 1 && result.containsKey('uomObject')) {
            onRequestSuccess(responseJson.uomList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getDepartment(
      {@required Function(List<DepartmentItem> departmentList) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: "",
            procName: "departmentlistproc",
            actionFlag: "DROPDOWN",
            subActionFlag: "MAPPED_DEPARTMENTS")
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          DepartmentModel responseJson = DepartmentModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            onRequestSuccess(responseJson.departmentList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  //
  //
  //
  // actionFlag: ""
  // key: "branchDetails"
  // list: "BRANCH"
  // procName: ""
  // removeAll: false
  // store: "branchStore"
  // subActionFlag: ""
  // xmlStr: ""

  getBranchStore(
      {@required Function(List<BranchStore> branches) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    List jssArr = DropDownParams()
        .addParams(
            list: "BRANCH",
            key: "branchDetails",
            xmlStr: "",
            procName: "",
            actionFlag: "",
            subActionFlag: "")
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BranchStoreModel responseJson = BranchStoreModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.branchstorelist);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getBranchList(
      {@required Function(List<BranchStockLocation> branches) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    String xmlStatus = XMLBuilder(tag: "DropDown")
        .addElement(key: "OptionBusinessLevelCode", value: "PURCHASE_BL_LEVEL")
        .addElement(key: "SuperUserYN", value: "Y")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "locationObj",
            xmlStr: xmlStatus,
            procName: "BusinessSubLevelProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BranchsModel responseJson = BranchsModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.branches);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getPurchaseItemBudget(
      {@required int optionId,
      @required int itemId,
      @required int departmentId,
      @required int branchId,
      @required Function(List<BudgetDtlModel> budgetlist) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    // int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    // int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlList = XMLBuilder(tag: "List")
        .addElement(key: "Date", value: "${BaseDates(DateTime.now()).dbformat}")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();

    String xmlItem = XMLBuilder(tag: "Item")
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

    String url = "/purchase/controller/cmn/getdropdownlist";
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

  getEnteredPurchaseList(
      {@required
          int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      PurchaseViewList pqModelView,
      @required
          PVFilterModel filterModel,
      @required
          Function(PurchaseDetailsViewModel purchaseDetailsViewModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start,
      "limit": "10",
      "value": pqModelView.Id,
      "SOR_Id": sor_Id,
      "EOR_Id": eor_Id,
      "TotalRecords": totalRecords,
      "Key": 50,
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
      ],
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/trn/getpurreqdetails";

    PurchaseDetailsViewModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PurchaseDetailsViewModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getPurchaseView(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      @required PVFilterModel filterModel,
      //@required Function(List<PurchaseViewList> ledgerList) onRequestSuccess,
      @required Function(PurchaseViewListModel ledgerList) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
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
      "Key": 50,
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
        if (filterModel.reqNo != null && filterModel.reqNo.isNotEmpty)
          {
            "column": "RequestNo",
            "value": "%${filterModel.reqNo}%",
            "datatype": "STR",
            "restriction": "LIKE",
            "sortorder": null
          }
      ],
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/trn/getpurreqdetails";

    PurchaseViewListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PurchaseViewListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  void saveRequisition({
    List<PurchaseRequisitionModel> requisitionItems,
    int optionId,
    String remarks,
    int statusBccid,
    int viewDtlId,
    PurchaseDetailsViewModel detailData,
    BudgetDtlModel budgetDtl,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
    String attachmentXml,
  }) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String date = BaseDates(DateTime.now()).dbformatWithTime;
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    String dateWithOutTime = BaseDates(DateTime.now()).dbformat;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();
//    optionId = 50;
    int editId = 0;
    jsonArr = {
      "Id": viewDtlId == 0 ? 0 : detailData.purchaseDetailViewList.first.Id,
      "optionid": optionId,
      "transactionuniqeid": 0,
      "amendmentno": viewDtlId == 0
          ? 0
          : detailData.purchaseDetailViewList.first.amendmentno,
      "amendmentdate": date,
      "amendedfromoptionid": optionId,
      "finyearid": finYearId,
      "requestno":
          viewDtlId == 0 ? "" : detailData.purchaseDetailViewList.first.reqno,
      "requestdate": date,
      "remarks": remarks,
      "recordstatus": "A",
      "statusdate": date,
      "statusbccid": statusBccid,
    };
    print(requisitionItems);
    String service = "putdata";
    String url = "/purchase/controller/trn/purreqsave";

    requisitionItems.forEach((element) {});
    jsonArr["item_ListData"] = requisitionItems
        .map((item) => {
              "Id": viewDtlId == 0 ? 0 : item.detailListId,
              "optionid": optionId,
              "itemid": item.item?.id ?? item.budgetDtl.itemid,
              "uomtypebccid": item.uom.uomtypebccid,
              "uomid": item.uom.uomid,
              "qty": item.qty,
              "statusbccid": statusBccid,
              "statusdate": date,
              "source_Mapping": [],
              if (item.budgetDtl != null)
                "budgetDtl": [
                  {
                    "Id": viewDtlId == 0 ? 0 : item.id,
                    "optionid": optionId,
                    "itemid": item.budgetDtl?.itemid,
                    "departmentid": item.budgetDtl?.departmentid,
                    "branchid": branchId,
                    "qty": item.qty,
                    "rate": item.budgetDtl?.itemcost ?? 0,
                    "totalvalue": double.parse(
                            ((item.qty * item.budgetDtl?.itemcost))
                                .toStringAsFixed(2)) ??
                        0,
                    "budgetedamount": item.budgetDtl?.budgeted,
                    "inprogressamount": item.budgetDtl?.inprocess ?? 0,
                    "actualamount": item.budgetDtl?.actual,
                    "remainingamount": item.budgetDtl?.remaining,
                    "budgetdate": dateWithOutTime
                  }
                ]
            })
        .toList();
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];
    if (attachmentXml != null) {
      jsonArr["docAttachReqYN"] = true;
      jsonArr["docAttachXml"] = attachmentXml;
    }
    jsonArr["SerialNoCol"] = "reqno";
    jsonArr["TransDateCol"] = "reqdate";
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
}
