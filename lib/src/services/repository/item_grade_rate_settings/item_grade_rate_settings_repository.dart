import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_initail_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_details_page_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_page_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_filter_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';

class ItemGradeRateSettingsRepository extends BaseRepository {
  static final ItemGradeRateSettingsRepository _instance =
      ItemGradeRateSettingsRepository._();

  ItemGradeRateSettingsRepository._();

  factory ItemGradeRateSettingsRepository() => _instance;

  Future<void> getProductList({
    String name,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 0,
    @required
        Function(
      List<ProductModel> products, {
      int sorId,
      int eorId,
      int limit,
      int totalRecords,
    })
            onRequestSuccess,
    @required
        Function(AppException) onRequestFailure,
  }) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String date = BaseDates(DateTime.now()).dbformat;
    int limit = 10;
    List params = [
      if (name?.isNotEmpty ?? false)
        {
          "column": "Name",
          "value": "%$name%",
          "datatype": "STR",
          "restriction": "EQU",
          "sortorder": null
        },
      if (code?.isNotEmpty ?? false)
        {
          "column": "Code",
          "value": "%$code%",
          "datatype": "STR",
          "restriction": "EQU",
          "sortorder": null
        },
      // if (optionId != null)
      //   {
      //     "column": "OptionId",
      //     "value": "$optionId",
      //     "datatype": "STR",
      //     "restriction": "EQU",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start ?? 0,
      "limit": 10,
      "value": value,
      "params": params,
      "colName": "description",
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

    String url = "/purchase/controller/cmn/getdropdownlist";

    String service = "getdata";
    ProductsModel responseJson;
    performRequest(
        service: service,
        jsonArr: [json.encode(ddpObjects)],
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ProductsModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: limit,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getItemRateGrades(
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
      "limit": "100",
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

  getItemRateViewListDate(
      {List<ItemLookupItem> items,
      int start,
      int optionId,
      ItemGradeRateSettingsFilterModel itemGradeRateSettingsFilterModel,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      @required
          Function(
                  ItemGradeRateSettingsViewPageModel
                      itemGradeRateSettingsViewPageModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    //  String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    var itemAry = [];
    String xmlBusinessLevel = XMLBuilder(tag: "InputBusinessLevel")
        .addElement(
            key: "businesslevelcodeid",
            value:
                "${itemGradeRateSettingsFilterModel.locObj.businesslevelcodeid}")
        .addElement(
            key: "businessleveltableid",
            value: "${itemGradeRateSettingsFilterModel.locObj.tableid}")
        .addElement(
            key: "businessleveltabledataid",
            value: "${itemGradeRateSettingsFilterModel.locObj.id}")
        .buildElement();
    if (itemGradeRateSettingsFilterModel.datas != null) {
      for (int i = 0; i < itemGradeRateSettingsFilterModel.datas.length; i++) {
        String xmlItems = XMLBuilder(tag: "ITEM")
            .addElement(
                key: "Id",
                value: "${itemGradeRateSettingsFilterModel.datas[i].id}")
            .buildElement();
        itemAry.add(xmlItems);
      }
    }

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": 0,
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "colName": "Id",
      "params": [
        {"column": "OptionId", "value": "$optionId"},
        {
          "column": "Weffromdate",
          "value":
              "${BaseDates(itemGradeRateSettingsFilterModel.fromDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "Weftodate",
          "value":
              "${BaseDates(itemGradeRateSettingsFilterModel.toDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        if (itemGradeRateSettingsFilterModel.pricingNo != null &&
            itemGradeRateSettingsFilterModel.pricingNo.isNotEmpty)
          {
            "column": "Pricingno",
            "value": "%${itemGradeRateSettingsFilterModel.pricingNo}%",
            "datatype": "STR",
            "restriction": "LIKE",
            "sortorder": null
          }
      ],

      "xmlStr": itemGradeRateSettingsFilterModel.datas == null
          ? xmlBusinessLevel
          : xmlBusinessLevel + itemAry.join(''),
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/trn/getdetailsusingprocgradepricing";

    ItemGradeRateSettingsViewPageModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson =
                  ItemGradeRateSettingsViewPageModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getItemRateGradeViewDetailsListData(
      {int optionId,
      int start,
      ItemGradeRateSettingsFilterModel itemGradeRateSettingsFilterModel,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      ItemGradeRateSettingsViewPageList viewPageListId,
      @required
          Function(
                  ItemGradeRateSettingsViewDetailPageListModel
                      itemGradeRateSettingsViewDetailPageListModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String xmlBusinessLevel = XMLBuilder(tag: "InputBusinessLevel")
        .addElement(
            key: "businesslevelcodeid",
            value:
                "${itemGradeRateSettingsFilterModel.locObj.businesslevelcodeid}")
        .addElement(
            key: "businessleveltableid",
            value: "${itemGradeRateSettingsFilterModel.locObj.tableid}")
        .addElement(
            key: "businessleveltabledataid",
            value: "${itemGradeRateSettingsFilterModel.locObj.id}")
        .buildElement();
    //
    // String xmlItems = XMLBuilder(tag: "ITEM")
    //     .addElement(
    //         key: "Id", value: "${itemGradeRateSettingsFilterModel.item?.id}")
    //     .buildElement();

    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start ?? 0,
      "limit": "10",
      "value": viewPageListId.Id,
      // "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "colName": "Id",
      "params": [
        {"column": "OptionId", "value": "$optionId"},
        {
          "column": "Weffromdate",
          "value":
              "${BaseDates(itemGradeRateSettingsFilterModel.fromDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "Weftodate",
          "value":
              "${BaseDates(itemGradeRateSettingsFilterModel.toDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        if (itemGradeRateSettingsFilterModel.pricingNo != null &&
            itemGradeRateSettingsFilterModel.pricingNo.isNotEmpty)
          {
            "column": "Pricingno",
            "value": "%${itemGradeRateSettingsFilterModel.pricingNo}%",
            "datatype": "STR",
            "restriction": "LIKE",
            "sortorder": null
          }
      ],
      // if (itemGradeRateSettingsFilterModel.item != null)
      "xmlStr": xmlBusinessLevel,
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/trn/getdetailsusingprocgradepricing";

    ItemGradeRateSettingsViewDetailPageListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson =
                  ItemGradeRateSettingsViewDetailPageListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getItemGradeRateSettingInitialData(
      {@required
          Function({
        List<BusinessSubLevelObjModel> businessSubLevelObj,
        List<StockLocation> itemGradeRateLocationObj,
        List<BusinessLevelObjModel> businessLevelObj,
        List<BCCModel> currencyList,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String xmlLoc = XMLBuilder(tag: "DropDown")
        .addElement(
            key: "OptionBusinessLevelCode", value: "PRICING_BILLING_LEVEL")
        .addElement(key: "SuperUserYN", value: "Y")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "locationObj",
            xmlStr: xmlLoc,
            procName: "BusinessSubLevelProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
        .addParams(
            procName: "CurrencyListProc",
            list: 'CURRENCY_DROPDOWN',
            key: 'currencyList',
            actionFlag: "LIST",
            subActionFlag: "CURRENCY",
            xmlStr: "<DATA><List></List></DATA>")
        .addParams(
          list: 'BUSINESS-SUB-LEVEL',
          key: 'businessSubLevelObj',
        )
        .addParams(list: "PURCHASE_BL_LEVEL", key: "businessLevelObj", params: [
      {
        "column": "constantcode",
        "value": "PRICING_BILLING_LEVEL",
        "datatype": "STR",
        "restriction": "EQU"
      },
      {
        "column": "constantgroup",
        "value": "PRICING",
        "datatype": "STR",
        "restriction": "EQU"
      }
    ]).callReq();

    String url = "/purchase/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          ItemGradeRateSettingsInitailModel responseJson =
              ItemGradeRateSettingsInitailModel.fromJson(result);
          print("branch Id $branchId");
          if (responseJson.statusCode == 1) {
            onRequestSuccess(
                businessLevelObj: responseJson.businessLevelObj,
                businessSubLevelObj: responseJson.businessSubLevelObj,
                itemGradeRateLocationObj: responseJson.itemGradeRateLocationObj,
                currencyList: responseJson.currencyList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void saveItemGradeRateSettings({
    List<ItemGradeRateSubModel> itemGradeRateListDataItems,
    int optionId,
    final List<BusinessLevelObjModel> businessLevelObj,
    StockLocation sourceLocation,
    DateTime pricingdate,
    int itemRateGradeDtlId,
    ItemGradeRateSettingsViewDetailPageListModel dtlModel,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    String date = BaseDates(DateTime.now()).dbformatWithTime;
    String dateWithOutTime = BaseDates(DateTime.now()).dbformat;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    jsonArr = {
      "Id": itemRateGradeDtlId == 0
          ? 0
          : dtlModel.itemGradeRateSettingsDetailViewPageList.first.id,
      "optionid": optionId,
      "amendmentno": itemRateGradeDtlId == 0
          ? 0
          : dtlModel.itemGradeRateSettingsDetailViewPageList.first.amendmentno,
      "amendmentdate": itemRateGradeDtlId == 0
          ? dateWithOutTime
          : dtlModel
              .itemGradeRateSettingsDetailViewPageList.first.amendmentdate,
      "amendedfromoptionid": optionId,
      "companyid": companyId,
      "branchid": branchId,
      "finyearid": finYearId,
      "pricingno": itemRateGradeDtlId == 0
          ? ""
          : dtlModel.itemGradeRateSettingsDetailViewPageList.first.pricingno,
      "pricingwefdate": BaseDates(pricingdate).dbformat,
      "businesslevelcodeid": sourceLocation.businesslevelcodeid,
      "businessleveltableid": sourceLocation.tableid,
      "businessleveltabledataid": sourceLocation.id,
      "isblockedyn": "N",
      "recordstatus": "A",
    };

    String service = "putdata";
    String url = "/purchase/controller/trn/savegradepricing";

    jsonArr["dtlList"] = itemGradeRateListDataItems
        .map((item) => {
              "Id": itemRateGradeDtlId == 0 ? 0 : item.itemDtlId,
              "optionid": optionId,
              "itemid": item.item.id,
              "gradeid": item.grade.id,
              "rate": item.rate,
              "currencyid": businessLevelObj.first.currencyid,
              "dtlisblockedyn": "N"
            })
        .toList();
    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];
    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";
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
