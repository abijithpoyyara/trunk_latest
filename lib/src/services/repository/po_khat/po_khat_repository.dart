import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_initial_config_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_detail_list_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_pending_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/po_khat_save_model.dart';
import 'package:redstars/src/widgets/screens/po_khat/model/pokhat_model.dart';

class POKhatRepository extends BaseRepository {
  static final POKhatRepository _instance = POKhatRepository._();

  POKhatRepository._();

  factory POKhatRepository() => _instance;

  Future<void> getPOKhatInitialConfig(
      {@required
          Function(
                  {List<BCCModel> transportModeTypes,
                  List<KhatPurchasers> purchaserObj})
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "TRANSPORT_MODE_TYPES")
        .addElement(key: "CodeName", value: "Code")
        .addElement(key: "CompanyId", value: "$companyId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            actionFlag: "LIST",
            key: "trasportmodeObj",
            list: "BAYACONTROLCODES-DROPDOWN",
            procName: "bayacontrolcodelistproc",
            subActionFlag: "",
            xmlStr: xml)
        .addParams(
          key: "purchaserObject",
          list: "PURCHASER",
        )
        .callReq();

    String url = "/purchase/controller/cmn/getdropdownlist";
    String service = "getdata";
    POkhatConfigModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          responseJson = POkhatConfigModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(
                transportModeTypes: responseJson.transportModeTypes,
                purchaserObj: responseJson.purchaserObj);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getPoKhatDetailList(
      {@required
          int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int optionId,
      POKhatPendingListModelList selectedPendingList,
      // @required
      FilterModel filterModel,
      @required
          Function(POKhatDetailListModel poKhatDetailListModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    //String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start,
      "limit": "10",
      "colName": "Id",
      "value": selectedPendingList.Id,
      // "SOR_Id":sor_Id,
      //  "EOR_Id":eor_Id,
      // "TotalRecords": totalRecords,
      "xmlStr": "",
      "params": [
        {"column": "FinyearId", "value": finYearId},
        {"column": "OptionForListing", "value": "FOR_VIEW"},
        {"column": "OptionId", "value": optionId},
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
      ],
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/trn/getpodetails";

    POKhatDetailListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = POKhatDetailListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getPokhatSuplliers(
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
      "limit": "10000",
      "value": value,
      "colName": "name",
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "params": [],
      "dropDownParams": [
        {
          "list": "SUPPLIER-LOOKUP",
          "key": "resultObject",
          "procName": "Partylistingproc",
          "actionFlag": "DROPDOWN",
          "subActionFlag": "",
          "xmlStr": ""
        }
      ]
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/cmn/getdropdownlist";

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

  getLocationList(
      {@required Function(List<BranchStockLocation> locations) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlStatus = XMLBuilder(tag: "DropDown")
        .addElement(key: "OptionBusinessLevelCode", value: "PURCHASE_BL_LEVEL")
        .addElement(key: "SuperUserYN", value: "Y")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXCPROC",
            key: "locationObj",
            xmlStr: xmlStatus,
            procName: "BusinessSubLevelProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
        .callReq();

    String url = "/purchase/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BranchsModel responseJson = BranchsModel.fromJson(result);
          // List<BranchStockLocation> locations = responseJson.branches
          //     .where((e) => e.branchid == branchId)
          //     .toList();
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.branches);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getPoKhatPendingList(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      bool initialLoading,
      @required
          FilterModel pokhatFilter,
      int optionId,
      @required
          Function(POKhatPendingListModel poKhatPendingListModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String service = "getdata";
    String businessLevel;
    if (pokhatFilter?.loc != null)
      businessLevel = XMLBuilder(tag: "FilterBusinessLevelDtl")
          .addElement(
              key: "LevelCode", value: '${pokhatFilter?.loc?.levelcode}')
          .addElement(key: "LevelValue", value: '${pokhatFilter?.loc?.id}')
          .buildElement();

    List<String> suppliers = [];
    if (pokhatFilter?.suppliers != null) {
      for (int i = 0; i < pokhatFilter?.suppliers?.length; i++) {
        String supplierXml = XMLBuilder(tag: "Supplier")
            .addElement(
                key: "SupplierId",
                value: '${pokhatFilter.suppliers[i].supplierId} ')
            .buildElement();
        suppliers.add(supplierXml);
      }
    }

    var ddpObjects = {
      "flag": "ALL",
      "start": initialLoading ?? false ? 0 : start,
      "limit": "10",
      "xmlStr": pokhatFilter?.loc != null && pokhatFilter?.suppliers != null
          ? businessLevel + suppliers.toString()
          : pokhatFilter?.suppliers != null
              ? suppliers.toString()
              : pokhatFilter?.loc != null
                  ? businessLevel
                  : "",
      "value": value,
      "colName": "Id",
      // "SOR_Id":4379191,
      //sor_Id,
      //"EOR_Id":4379198,
      // eor_Id,
      //  "TotalRecords": 52,
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,

      "params": [
        {"column": "FinyearId", "value": finYearId},
        {"column": "OptionForListing", "value": "FOR_VIEW"},
        {"column": "OptionId", "value": optionId},
        {
          "column": "DateFrom",
          "value": "${BaseDates(pokhatFilter?.fromDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(pokhatFilter?.toDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        if (pokhatFilter?.reqNo != null && pokhatFilter?.reqNo.isNotEmpty)
          {
            "column": "PurchaseOrderNo",
            "value": "%${pokhatFilter.reqNo}%",
            "datatype": "STR",
            "restriction": "LIKE",
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

    String url = "/purchase/controller/trn/getpodetails";

    POKhatPendingListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = POKhatPendingListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  void savePOKhat({
    POKhatDetailListModel poKhatDetailListModel,
    int optionId,
    List<POKhatSaveModel> pokhatitems,
    PoKhatHdrModel hdrModel,
    String remarks,
    BranchStockLocation selectedLocation,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    String date = BaseDates(DateTime.now()).dbformatWithTime;
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    String dateWithOutTime = BaseDates(DateTime.now()).dbformat;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    var dtlList;
    var dtlList2;
    var itemDeliveryDtl;
    var itemDeliveryDtl2;
    int StatusBccid;
    if (poKhatDetailListModel != null)
      dtlList2 = poKhatDetailListModel.pokhatPendingDetailList.first.detailsDtls
          .map((dtl) {
        var srcMappingDtl = dtl.posrcmapDtl != null
            ? dtl.posrcmapDtl.map((src) {
                return {
                  "Id": src.id,
                  "optionid": src.optionid,
                  "reftableid": src.reftableid,
                  "reftabledataid": src.reftabledataid,
                  "refhdrtableid": src.refhdrtableid,
                  "refhdrtabledataid": src.refhdrtabledataid,
                  "generateduomid": src.generateduomid,
                  "generateduomtypebccid": src.generateduomtypebccid,
                  "generatedqty": src.generatedqty
                };
              }).toList()
            : [];
        srcMappingDtl.removeWhere(
            (element) => element.values == null || element.keys == null);
        print(srcMappingDtl);

        itemDeliveryDtl2 = dtl.location.map((delivery) {
          return {
            "Id": delivery.id,
            "optionid": optionId,
            "deliverylocationtableid": delivery.deliverylocationtableid,
            "deliverylocationtabledataid": delivery.deliverylocationtabledataid,
            "qtytodeliver": delivery.qty
          };
        }).toList();
        StatusBccid = dtl.statusbccid;
        //  srcMappingDtl.removeWhere((element) => element == null);
        return {
          "Id": dtl.Id,
          "optionid": optionId,
          "itemid": dtl.itemid,
          "uomid": dtl.uomid,
          "uomtypebccid": dtl.uomtypebccid,
          "qty": dtl.qty,
          "rate": 0,
          "totalvalue": 0,
          "totaldiscount": 0,
          "totalduties": null,
          "subtotal": 0,
          "tax": 0,
          "nettotal": 0,
          "discaftertax": 0,
          "othercharges": 0,
          "freightcharges": 0,
          "grosstotal": 0,
          "roundoff": 0,
          "purordaftrrndoff": 0,
          "deductedtax": 0,
          "remarks": hdrModel.remarks,
          "statusbccid": dtl.statusbccid,
          "statuswefdate":
              BaseDates(DateTime.parse(dtl.statuswefdate)).dbformatWithTime,
          "deliveryduedate":
              BaseDates(DateTime.parse(dtl.deliveryduedate)).dbformatWithTime,
          "poItemTaxDtlList": [],
          "dtlSourceMappingDtoList": [],
          //srcMappingDtl,
          "dtlItemDeliveryDtoList": itemDeliveryDtl,
          "dtlisblockedyn": "N",
          "fccurrencyid": finYearId,
          "exchrate": dtl.exchrate,
          "lcnettotal": 0,
          "budgetDtl": []
        };
      }).toList();

    dtlList = pokhatitems.map((detail) {
      remarks = detail.remarks;
      itemDeliveryDtl = detail?.location?.map((delivery) {
        return {
          "Id": delivery.id,
          "optionid": optionId,
          "deliverylocationtableid": delivery.deliverylocationtableid,
          "deliverylocationtabledataid": delivery.deliverylocationtabledataid,
          "qtytodeliver": delivery.qty
        };
      }).toList();

      return {
        "Id": detail?.pokhatId ?? 0,
        "optionid": optionId,
        "itemid": detail.item.id,
        "uomid": detail.uom?.uomid ?? 13,
        "uomtypebccid": detail?.uom?.uomtypebccid ?? 64,
        "qty": detail.qty,
        "rate": 0,
        "totalvalue": 0,
        "totaldiscount": 0,
        "totalduties": null,
        "subtotal": 0,
        "tax": 0,
        "nettotal": 0,
        "discaftertax": 0,
        "othercharges": 0,
        "freightcharges": 0,
        "grosstotal": 0,
        "roundoff": 0,
        "purordaftrrndoff": 0,
        "deductedtax": 0,
        "remarks": hdrModel.remarks,
        "statusbccid": detail?.statusBccId ?? StatusBccid,
        "statuswefdate": detail?.statusDate != null
            ? BaseDates(DateTime.parse(detail.statusDate)).dbformatWithTime
            : BaseDates(DateTime.now()).dbformatWithTime,
        "deliveryduedate": detail?.deliveryDueDate != null
            ? BaseDates(DateTime.parse(detail.deliveryDueDate)).dbformatWithTime
            : BaseDates(DateTime.now()).dbformatWithTime,
        "poItemTaxDtlList": [],
        "dtlSourceMappingDtoList": [],
        //srcMappingDtl,
        "dtlItemDeliveryDtoList": itemDeliveryDtl,
        //?? itemDeliveryDtl2,
        "dtlisblockedyn": "N",
        "fccurrencyid": finYearId,
        "exchrate": detail?.exchangeRate ?? 1,
        "lcnettotal": 0,
        "budgetDtl": []
      };
    }).toList();

    jsonArr = {
      "Id": poKhatDetailListModel?.pokhatPendingDetailList?.first?.id,
      "optionid": optionId,
      "amendmentno":
          poKhatDetailListModel?.pokhatPendingDetailList?.first?.amendmentno,
      "amendmentdate": BaseDates(DateTime.parse(poKhatDetailListModel
              ?.pokhatPendingDetailList.first.amendmentdate))
          .dbformatWithTime,
      "amendedfromoptionid": optionId,
      "companyid":
          poKhatDetailListModel.pokhatPendingDetailList.first.companyid,
      "branchid": branchId,
      "finyearid": finYearId,
      "purchaseorderno":
          poKhatDetailListModel.pokhatPendingDetailList.first.purchaseorderno,
      "purchaseorderdate": BaseDates(DateTime.parse(poKhatDetailListModel
              .pokhatPendingDetailList.first.purchaseorderdate))
          .dbformatWithTime,
      "dtlDtoList": dtlList,
      "supplierid":
          poKhatDetailListModel.pokhatPendingDetailList.first.supplierid,
      "leadtime": null,
      "creditperiod": null,
      "creditamt": null,
      "remarks": hdrModel.remarks,
      "statusbccid":
          poKhatDetailListModel.pokhatPendingDetailList.first.statusbccid,
      "statuswefdate": BaseDates(DateTime.parse(poKhatDetailListModel
              .pokhatPendingDetailList.first.statuswefdate))
          .dbformatWithTime,
      "duedate": BaseDates(DateTime.parse(
              poKhatDetailListModel.pokhatPendingDetailList.first.duedate))
          .dbformatWithTime,
      "recordstatus": "A",
      "interstateyn": "N",
      "paymentmode":
          poKhatDetailListModel.pokhatPendingDetailList.first.paymentmode,
      "isblockedyn": "N",
      "purchaserid":
          poKhatDetailListModel.pokhatPendingDetailList.first.purchaserid,
      "exchrate": poKhatDetailListModel.pokhatPendingDetailList.first.exchrate,
      "fccurrencyid":
          poKhatDetailListModel.pokhatPendingDetailList.first.fccurrencyid,
      "lccurrencyid":
          poKhatDetailListModel.pokhatPendingDetailList.first.lccurrencyid,
      "ordertypebccid":
          poKhatDetailListModel.pokhatPendingDetailList.first.ordertypebccid,
      "refno": null,
      "trasportmodebccid": null,
      "createduserid":
          poKhatDetailListModel.pokhatPendingDetailList.first.createduserid,
      "createddate": BaseDates(DateTime.parse(
              poKhatDetailListModel.pokhatPendingDetailList.first.createddate))
          .dbformatWithTime,
      "validitydate": null,
      "pricebasisbccid": null,
      "shipmentdate": null,
      "freightpaidbccid": null,
      "insurancepaidbccid": null,
      "paymenttypebccid": null,
      "processfrom": "",
    };
    String service = "putdata";
    String url = "/purchase/controller/trn/savepurchaseorder";

    jsonArr["containerDtlDtoList"] = [];
    jsonArr["extensionDataObj"] = [];
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];
    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";

    jsonArr["checkListDataObj"] = [];
    // dtlList.removeWhere((key, value) => key == null || value == null);
    jsonArr.removeWhere((key, value) => key == null || value == null);
    var request = json.encode(jsonArr);
    jsonArr.values.where((element) => element == null);
    List jssArr = List();
    jssArr.add(request);
    print(jsonArr);

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
