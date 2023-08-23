import 'dart:convert';

import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_dtl_list_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_list_data.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';
import 'package:redstars/utility.dart';

class GINRepository extends BaseRepository {
  static final GINRepository _instance = GINRepository._();

  GINRepository._();

  factory GINRepository() {
    return _instance;
  }

  getPurchaseOrders({
    @required GINFilterModel filter,
    @required ValueSetter<List<PoModel>> onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
    String transNo,
    int start = 0,
    int sorId,
    int eorId,
    int totalRecords,
  }) async {
    String service = "getdata";

    DateTimeRange range = filter.dateRange;
    SupplierLookupItem supplier = filter.supplier;
    String transNo = filter.transNo;
    int userId = await getUserId();
    int finYearId = await getFinYearID();

    //  if (supplier != null)
    String xml = XMLBuilder(tag: "Supplier", elements: [
      XMLElement(key: 'SupplierId', value: '${supplier?.id ?? 965}'),
    ]).buildElement();
    final jssArr = {
      "flag": "ALL",
      "start": start,
      // if (sorId != null) "SOR_Id": sorId,
      // if (eorId != null) "EOR_Id": eorId,
      // if (totalRecords != null) "TotalRecords": totalRecords,

      ///
      "limit": "10",
      "value": 0,
      "procName": "GrnInputListProc",
      "actionFlag": "LIST",
      "actionSubFlag": "PENDING_FOR_GRN",
      "xmlStr": supplier != null ? xml : "",
      "params": [
        {
          "column": "DateFrom",
          "value": "${BaseDates(filter.fromDate).dbformatWithTime}"
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(filter.toDate).dbformatWithTime}"
        },
        {"column": "FinyearId", "value": finYearId},
        if (transNo != null && transNo?.isNotEmpty ?? false)
          {"column": "TransactionNo", "value": "%$transNo%"},
        {"column": "ProcessInput", "value": "PURCHASE_ORDER_KHAT"},
        {"column": "OptionCode", "value": "PURCHASE_ORDER_KHAT"}
      ]
    };

    if (sorId != null) jssArr["SOR_Id"] = sorId;
    if (eorId != null) jssArr["EOR_Id"] = eorId;
    if (totalRecords != null) jssArr["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/trn/getpodetails";

    performRequest(
        service: service,
        jsonArr: [json.encode(jssArr)],
        url: url,
        // onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List purchaseOrders =
                BaseJsonParser.goodList(result, 'resultObject')
                    .map((e) => PoModel.fromJson(e))
                    .toList();
            onRequestSuccess(purchaseOrders);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  getLocationList(
      {@required Function(List<BranchStockLocation> branches) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlStatus = XMLBuilder(tag: "DropDown")
        .addElement(
            key: "OptionBusinessLevelCode", value: "INVENTORY_BILLING_LEVEL")
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
          List<BranchStockLocation> locations = responseJson.branches
              .where((e) => e.branchid == branchId)
              .toList();
          if (responseJson.statusCode == 1) {
            onRequestSuccess(locations);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getPODetails({
    @required ValueSetter<GINModel> onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
    PoModel po,
  }) async {
    String service = "getdata";

    int userId = await getUserId();
    int finyearId = await getUserId();

    String xml = XMLBuilder(tag: "FILLFLAG", elements: [
      XMLElement(key: "Flag", value: "CONSOLIDATED"),
      XMLElement(key: "TransDate", value: "${po.transactionDate}"),
      XMLElement(key: "Finyear", value: "${po.finYearId}"),
    ]).buildElement();
    xml += XMLBuilder(tag: "FILLPODTLS", elements: [
      XMLElement(key: "RefoptionId", value: "${po.refOptionId}"),
      XMLElement(key: "RefTableDataId", value: "${po.refTableData}"),
      XMLElement(key: "RefTableId", value: "${po.refTableId}"),
    ]).buildElement();
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "GrnInputFillProc",
          actionFlag: "FILL",
          subActionFlag: "PROCESS_GRN",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            if ((result['resultObject'] as List).isNotEmpty) {
              GINModel gin = GINModel.fromJson(result);
              onRequestSuccess(gin);
            } else {
              onRequestFailure(
                  InvalidInputException("Error in fetching GIN Details"));
            }
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  getGINViewDtlList(
      {@required
          int start,
      int optionId,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      GINViewListDataList valueId,
      @required
          GINDateFilterModel filterModel,
      @required
          Function(GINViewDetailModel purchaseDetailsViewModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start,
      "limit": "10",
      "value": valueId.Id,
      "SOR_Id": sor_Id,
      "EOR_Id": eor_Id,
      "TotalRecords": totalRecords,
      "params": [
        {"column": "FinyearId", "value": finyearId},
        {"column": "OptionId", "value": optionId},
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

    String url = "/inventory/controller/trn/getgrndetails";

    GINViewDetailModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = GINViewDetailModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getGINSuplliers(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      @required Function(List<SupplierLookupItem> suppliers) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start ?? 0,
      "limit": "1000",
      "value": value,
      "colName": "name",
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "params": [
        {
          "column": "name",
          "value": "",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": "ASC"
        }
      ],
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/ap/controller/def/getsuppliers";

    SupplierLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = SupplierLookupModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.lookupItems)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getGINSavedListView(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int optionId,
      int value = 0,
      @required
          GINDateFilterModel ginFilter,
      @required
          Function(GINViewListDataListModel ginViewListDataListModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    var supplierAry = [];
    String service = "getdata";
    if (ginFilter?.datas != null) {
      for (int i = 0; i < ginFilter.datas.length; i++) {
        String xmlItems = XMLBuilder(tag: "Supplier")
            .addElement(key: "SupplierId", value: "${ginFilter.datas[i].id}")
            .buildElement();
        supplierAry.add(xmlItems);
      }
    }

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "Id",
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "xmlStr": ginFilter?.datas != null ? supplierAry.join('') : "",
      "params": [
        {"column": "FinyearId", "value": finyearId},
        {"column": "OptionId", "value": optionId},
        {
          "column": "DateFrom",
          "value":
              "${BaseDates(ginFilter?.fromDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1)).dbformatWithTime}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(ginFilter?.toDate).dbformatWithTime}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        if (ginFilter?.poDateFrom != null)
          {
            "column": "SalveInvDateFrom",
            "value":
                "${BaseDates(ginFilter?.poDateFrom ?? DateTime(DateTime.now().year, DateTime.now().month, 1)).dbformatWithTime}",
            "datatype": "DTE",
            "restriction": "EQU",
            "sortorder": null
          },
        if (ginFilter?.poDateTo != null)
          {
            "column": "SaleInvDateTo",
            "value":
                "${BaseDates(ginFilter.poDateTo).dbformatWithTime ?? DateTime.now()}",
            "datatype": "DTE",
            "restriction": "EQU",
            "sortorder": null
          },
        if (ginFilter?.gINno != null)
          {
            "column": "GrnNo",
            "value": "%${ginFilter?.gINno}%",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": null
          },
        if (ginFilter?.poNo != null)
          {
            "column": "SupplierInvNo",
            "value": "%${ginFilter?.poNo}%",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": null
          },
      ],
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/trn/getgrndetails";

    GINViewListDataListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = GINViewListDataListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getPOSourceMappingDetails({
    @required Function(List<GINSourceMappingDtlList>) onRequestSuccess,
    @required ValueSetter<AppException> onRequestFailure,
    PoModel po,
  }) async {
    String service = "getdata";

    int userId = await getUserId();
    int finyearId = await getUserId();

    String xml = XMLBuilder(tag: "FILLFLAG", elements: [
      XMLElement(key: "Flag", value: "SOURCEMAPPING"),
    ]).buildElement();
    xml += XMLBuilder(tag: "FILLPODTLS", elements: [
      XMLElement(key: "RefoptionId", value: "${po.refOptionId}"),
      XMLElement(key: "RefTableDataId", value: "${po.refTableData}"),
      XMLElement(key: "RefTableId", value: "${po.refTableId}"),
    ]).buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "GrnInputFillProc",
          actionFlag: "FILL",
          subActionFlag: "PROCESS_GRN",
          xmlStr: xml,
          key: "resultObj",
        )
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          GINSourceMappingDtlModel responseJson =
              GINSourceMappingDtlModel.fromJson(result);
          if (responseJson.statusCode == 1 && result.containsKey('resultObj')) {
            onRequestSuccess(responseJson.gradeRateList);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  void saveGIN(
      {PoModel poModel,
      GINModel ginModel,
      List<GINItemModel> items,
      List<GINSourceMappingDtlList> ginSourceMappingList,
      BranchStockLocation location,
      String remarks,
      int optionId,
      int editId,
      GINViewDetailList dtlViewList,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String attachmentXml}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int fcCurrencyId = await BasePrefs.getInt(BaseConstants.BRANCH_CURRENCY_ID);
    int lcCurrencyId =
        await BasePrefs.getInt(BaseConstants.COMPANY_BASE_CURRENCY_ID);
    int amendmendno;
    if (dtlViewList != null) {
      amendmendno = int.parse(dtlViewList.amendmentno);
    }

    String date = BaseDates(DateTime.now()).dbformatWithTime;
    String dateWithoutTime = BaseDates(DateTime.now()).dbformat;
    DateFormat format = new DateFormat("yyyy-MM-dd");
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

    // var supplierDate = BaseDates(convertDateTimePtBR(
    //         poModel?.transactionDate ?? DateTime.now().toString()))
    //     .dbformatWithTime;
    // print(supplierDate);

    var sourceMappingList = [];

    var uomDtl = [];
    ginSourceMappingList.forEach((element) {
      uomDtl.add({
        "Id": 0,
        "optionid": optionId,
        "uomid": element.uomid,
        "uomtypebccid": element.uomtypebccid,
        "qty": element.qty
      });
    });

    var dtlDataList = [];
    // dtlViewList.ginDetailDtlList.forEach((ele) {
    //   ele.srcMappingDtl.first
    // });
    if (items != null)
      items?.forEach((element) {
        if (ginSourceMappingList != null) {
          ginSourceMappingList.forEach((src) {
            if (element.itemId == src.itemid)
              sourceMappingList.add({
                "Id": dtlViewList != null
                    ? dtlViewList?.ginDetailDtlList.first.srcMappingDtl.first.Id
                    : 0,
                "optionid": optionId,
                "generateduomid": src.uomid,
                "generateduomtypebccid": src.uomtypebccid,
                "generatedqty": src.qty,
                "reftableid": src.reftableid,
                "reftabledataid": src.reftabledataid,
                "refhdrtableid": src.refhdrtableid,
                "refhdrtabledataid": src.refhdrtabledataid
              });
          });
        }
        dtlDataList.add({
          "Id": editId == 0 ? 0 : element.id,
          "optionid": optionId,
          "itemid": element.itemId,
          "barcodeno": null,
          "barcodeid": null,
          "fccurrencyid": fcCurrencyId,
          "exchrate": element.exchrate,
          "barcodetype": "",
          "itembatchid": null,
          "itemaccessedcode": element.itemaccessedcode,
          "itemaccessedcodetypebccid": element.itemaccessedcodetypebccid,
          "uomid": element.uomId,
          "uomtypebccid": element.uomtypebccid,
          "qty": element.receivedQty,
          "deliverynoteqty": element.receivedQty,
          "rate": 0,
          "totalvalue": 0,
          "totaldiscamout": 0,
          "totaldutiesamount": null,
          "subtotal": 0,
          "taxamount": 0,
          "nettotal": 0,
          "discamountaftertax": 0,
          "othercharges": 0,
          "freightcharges": 0,
          "grosstotal": 0,
          "roundoff": 0,
          "totalafterroundoff": 0,
          "lctotalafterroundoff": 0,
          "manufacturedate": null,
          "mrp": 0,
          "statusbccid":
              editId == 0 ? poModel.statusBccId : dtlViewList.statusbccid,
          "statuswefdate": date,
          "isbarcodedyn": "N",
          "updateqty": element.receivedQty,
          "sourceMappingDtlModelList": [
            {
              "Id": editId == 0 ? 0 : element.itemSourceMapList.id,
              "optionid": optionId,
              "generateduomid": element.uomId,
              "generateduomtypebccid": element.uomtypebccid,
              "generatedqty": element.receivedQty,
              "reftableid": element?.itemSourceMapList?.reftableid,
              "reftabledataid": element?.itemSourceMapList?.reftabledataid,
              "refhdrtableid": element?.itemSourceMapList?.refhdrtableid,
              "refhdrtabledataid": element?.itemSourceMapList?.refhdrtabledataid
            }
          ],
          "itemUomWiseQtylModelList": [
            {
              "Id": editId == 0 ? 0 : element?.itemWiseQtyDtl?.id,
              "optionid": optionId,
              "uomid": element.uomId,
              "uomtypebccid": element.uomtypebccid,
              "qty": element.receivedQty
            }
          ],
          "taxDtlModelList": [],
          "discDtlList": [],
          "extraFldDataObj": [],
          "poqty": element.receivedQty,
          "prevginqty": 0,
          "differenceqty": 0,
          "budgetDtl": []
        });
      });

    jsonArr = {
      "Id": editId == 0 ? 0 : dtlViewList.Id,
      "optionid": optionId,
      "amendmentno": editId == 0 ? 0 : amendmendno,
      "amendmentdate": date,
      "amendedfromoptionid": optionId,
      "companyid": ginModel.companyid,
      "branchid": ginModel.branchid,
      "finyearid": ginModel.finyearid,
      "grnno": editId == 0 ? null : ginModel.grnno,
      "grndate": date,
      "supplierid": ginModel.supplierid,
      "leadtime": null,
      "creditperiod": null,
      "creditamt": null,
      "updateqtyyn": "N",
      "purchaseorderhdrno": null,
      // editId == 0
      //     ? poModel?.refTableData
      //     : dtlViewList?.ginDetailDtlList?.first.Id,
      "interstateyn":
          editId == 0 ? poModel?.isInterState : dtlViewList.interstateyn,
      "statusbccid":
          editId == 0 ? poModel?.statusBccId : dtlViewList.statusbccid,
      "supplierinvoiceno":
          editId == 0 ? poModel?.transactionNo : dtlViewList.supllierinvno,
      "supplierinvoicedate": editId == 0
          ? BaseDates(convertDateTimePtBR(poModel.transactionDate))
              .dbformatWithTime
          : BaseDates(DateTime.parse(dtlViewList.supllierinvdate))
              .dbformatWithTime,
      "statuswefdate": date,
      "systemgenyn": "N",
      "futuredatedtransyn": "N",
      "gateentryno": null,
      "vehicleno": null,
      "referenceno": null,
      "recordstatus": "A",
      "processinput": "PURCHASE_ORDER",
      "partialgrnstatus": null,
      "fullgrnstatus": null,
      "pendingstatus":
          editId == 0 ? poModel?.statusBccId : dtlViewList.statusbccid,
      "newDate": date,
      "grndateintegerformat": dateWithoutTime.replaceAll("-", ""),
      "paymentmode": ginModel.paymentmode,
      "businesslevelcodeid": location.businesslevelcodeid,
      "blreftabledataid": location.id,
      "blreftableid": location.tableid,
      "dtlDtoList": dtlDataList,
      "discountInfoDtlList": [],
      "inwardno": null,
      "deliverynotedate": null,
      "deliverynoteno": null,
      "fccurrencyid": fcCurrencyId,
      "lccurrencyid": lcCurrencyId,
      "exchrate": ginModel?.exchrate ?? 1,
      "createduserid": ginModel.createduserid,
      "createddate":
          BaseDates(DateTime.parse(ginModel.createddate)).dbformatWithTime,
      "remarks": remarks.isEmpty ? null : remarks,
      "supplierinvoicetotaltax": 0,
      "supplierinvoicetotalafterroundoff": 0,
    };

    String service = "putdata";
    String url = "/inventory/controller/trn/savegrn";
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];

    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";

    jsonArr["checkListDataObj"] = [];
    // jsonArr.removeWhere((key, value) => key == null || value == null);

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
}
