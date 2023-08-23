import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/pricing/itemdetails_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';

class PricingRepository extends BaseRepository {
  static final PricingRepository _instance = PricingRepository._();

  PricingRepository._();

  factory PricingRepository() => _instance;

  Future<void> getProductList({
    @required
        int optionId,
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
      "limit": 10022,
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

  Future<void> getItemGrpLIst({
    @required
        String searchQuery,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 1,
    @required
        Function(
      List<ItemGroupLookupItem> products, {
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

    String service = "getdata";

    List params = [
      {
        "column": "AttributeId",
        "value": "1",
        "datatype": "INT",
        "restriction": "EQU",
        "sortorder": null
      },
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Description",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },

      // if (searchQuery?.isNotEmpty ?? false)
      //   {
      //     "column": "Description",
      //     "value": "%$searchQuery%",
      //     "datatype": "STR",
      //     "restriction": "ILIKE",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "100000",
      "value": value,
      "colName": "attributeid",
      "params": params
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/common/controller/cmn/getattributevalue";
    ItemGroupLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        // [
        //   {
        //     "colName": "attributeid",
        //     "params": [
        //       {
        //         "column": "AttributeId",
        //         "value": "1",
        //         "datatype": "INT",
        //         "restriction": "EQU",
        //         "sortorder": null
        //       }
        //     ],
        //     "start": 0,
        //     "limit": "10",
        //     "flag": "ALL",
        //     "value": 1
        //   }
        // ],

        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemGroupLookupModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: 10,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getClassificationLIst({
    @required
        String searchQuery,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 2,
    @required
        Function(
      List<ItemGroupLookupItem> products, {
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

    String service = "getdata";

    List params = [
      {
        "column": "AttributeId",
        "value": "2",
        "datatype": "INT",
        "restriction": "EQU",
        "sortorder": null
      },
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Description",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },

      // if (searchQuery?.isNotEmpty ?? false)
      //   {
      //     "column": "Description",
      //     "value": "%$searchQuery%",
      //     "datatype": "STR",
      //     "restriction": "ILIKE",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "1000",
      "value": value,
      "colName": "attributeid",
      "params": params
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/common/controller/cmn/getattributevalue";
    ItemGroupLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemGroupLookupModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: 10,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getLocationList({
    @required
        String searchQuery,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 0,
    @required
        Function(
      List<LocationLookUpItem> products, {
      int sorId,
      int eorId,
      int limit,
      int totalRecords,
    })
            onRequestSuccess,
    @required
        Function(AppException) onRequestFailure,
  }) async {
    bool superUser = await BasePrefs.getBool(BaseConstants.SUPER_USER_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String service = "getdata";
    String xmlStr = XMLBuilder(tag: "DropDown ")
        .addElement(
            key: "OptionBusinessLevelCode ", value: "ACCOUNT_BILLING_LEVEL")
        .addElement(key: "ParentBusinessLevelCode ", value: "L1")
        .addElement(key: "SuperUserYN", value: "Y")
        .addElement(key: "UserId ", value: "$userId")
        .addElement(key: "BranchId ", value: "$branchId")
        .buildElement();

    List params = [
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Name",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },

      // if (searchQuery?.isNotEmpty ?? false)
      //   {
      //     "column": "Description",
      //     "value": "%$searchQuery%",
      //     "datatype": "STR",
      //     "restriction": "ILIKE",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": 0,
      "limit": "10",
      "value": value,
      "colName": "Id",
      "params": params,
      "dropDownParams": [
        {
          "list": "EXEC-PROC",
          "procName": "BusinessSubLevelProc",
          "key": "resultObject",
          "actionFlag": "DROPDOWN",
          "xmlStr": xmlStr,
          "subActionFlag": "OPT_BUSINESS_LEVEL_FITER"
        }
      ]
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/cmn/getdropdownlist";
    LocationLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = LocationLookupModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: 10,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getBrandList({
    @required
        String searchQuery,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 3,
    @required
        Function(
      List<ItemGroupLookupItem> products, {
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

    String service = "getdata";

    List params = [
      {
        "column": "AttributeId",
        "value": "3",
        "datatype": "INT",
        "restriction": "EQU",
        "sortorder": null
      },
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Description",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },

      // if (searchQuery?.isNotEmpty ?? false)
      //   {
      //     "column": "Description",
      //     "value": "%$searchQuery%",
      //     "datatype": "STR",
      //     "restriction": "ILIKE",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "45",
      "value": value,
      "colName": "attributeid",
      "params": params
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/common/controller/cmn/getattributevalue";
    ItemGroupLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemGroupLookupModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: 10,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getItemBrandLIst({
    @required
        String searchQuery,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 4,
    @required
        Function(
      List<ItemGroupLookupItem> products, {
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

    String service = "getdata";

    List params = [
      {
        "column": "AttributeId",
        "value": "4",
        "datatype": "INT",
        "restriction": "EQU",
        "sortorder": null
      },
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Description",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },

      // if (searchQuery?.isNotEmpty ?? false)
      //   {
      //     "column": "Description",
      //     "value": "%$searchQuery%",
      //     "datatype": "STR",
      //     "restriction": "ILIKE",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "attributeid",
      "params": params
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/common/controller/cmn/getattributevalue";
    ItemGroupLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemGroupLookupModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: 10,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getItemModelLIst({
    @required
        String searchQuery,
    String code,
    int start = 0,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int value = 5,
    @required
        Function(
      List<ItemGroupLookupItem> products, {
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

    String service = "getdata";

    List params = [
      {
        "column": "AttributeId",
        "value": "5",
        "datatype": "INT",
        "restriction": "EQU",
        "sortorder": null
      },
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Description",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },

      // if (searchQuery?.isNotEmpty ?? false)
      //   {
      //     "column": "Description",
      //     "value": "%$searchQuery%",
      //     "datatype": "STR",
      //     "restriction": "ILIKE",
      //     "sortorder": null
      //   }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "2",
      "value": value,
      "colName": "attributeid",
      "params": params
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/common/controller/cmn/getattributevalue";
    ItemGroupLookupModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemGroupLookupModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject"))
                {
                  onRequestSuccess(
                    responseJson.lookupItems,
                    totalRecords: responseJson.totalRecords,
                    sorId: responseJson.SOR_Id,
                    eorId: responseJson.EOR_Id,
                    limit: 10,
                  )
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getItemDetails(
      {
      //  ItemLookupItem itemDtl,
      //  ItemGroupLookupItem lookupDtl,
      List<ItemLookupItem> itemDtl,
      List<ItemGroupLookupItem> lookupDtl,
      @required Function(List<ItemDetailListItems>) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(
            key: "ProcessDate",
            value: BaseDates(DateTime.now()).dbformatWithTime)
        .addElement(key: "FinyearId", value: "$finyearId")
        .buildElement();

    List<String> arry = [];
    for (int i = 0; i < itemDtl.length; i++) {
      String itemXml = XMLBuilder(tag: "Item")
          .addElement(key: "ItemId", value: '${itemDtl[i].id} ')
          .buildElement();
      arry.add(itemXml);
    }

    // String itemXml = XMLBuilder(tag: "Item")
    //     .addElement(key: "ItemId", value: '${itemDtl.id} ')
    //     .buildElement();
    //
    List<String> attributes = [];
    for (int i = 0; i < lookupDtl.length; i++) {
      String attributeXml = XMLBuilder(tag: "Attribute")
          .addElement(key: "AttributeId", value: '${lookupDtl[i].attributeid} ')
          .addElement(
              key: "AttributeRefId",
              value: '${lookupDtl[i].parenttabledataid} ')
          .buildElement();
      attributes.add(attributeXml);
    }

    // String attributeXml = XMLBuilder(tag: "Attribute")
    //     .addElement(key: "AttributeId", value: '${lookupDtl.attributeid} ')
    //     .addElement(
    //         key: "AttributeRefId", value: '${lookupDtl.parenttabledataid} ')
    //     .buildElement();

    String businessXml = XMLBuilder(tag: "InputBusinessLevel")
        .addElement(key: "LevelId", value: "2")
        .addElement(key: "LevelCode", value: "L2")
        .addElement(key: "LevelValue", value: "$branchId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXCPROC",
            key: "ItemDtlObj",
            xmlStr: xmlStatus +
                attributes.toString() +
                arry.toString() +
                businessXml,
            //  xmlStr: xmlStatus + attributeXml + itemXml + businessXml,
            procName: "PricingDtlProc",
            actionFlag: "LIST",
            subActionFlag: "ITEM_DETAILS")
        .callReq();

    String url = "/purchase/controller/cmn/getdropdownlist";
    String service = "getdata";
    ItemDetailModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ItemDetailModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.itemDetailList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
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

  // ItemAttributeListProc('LIST','ATTRIBUTE_VALUE_LIST','<DATA><List Start= "0" Limit= "10" AttributeId="1"></List></DATA> ')

  getItemGroup(
      {@required Function(List<ItemGroup> itemGrp) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "Start", value: "0")
        .addElement(key: "Limit", value: "10")
        .addElement(key: "AttributeId", value: "1")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: "<DATA>" + xml + "</DATA>",
            procName: "ItemAttributeListProc",
            actionFlag: "LIST",
            subActionFlag: "ATTRIBUTE_VALUE_LIST")
        .callReq();

    String url = "/common/controller/cmn/getattributevalue";
    //  String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: [
          {
            "colName": "attributeid",
            "params": [
              {
                "column": "AttributeId",
                "value": "1",
                "datatype": "INT",
                "restriction": "EQU",
                "sortorder": null
              }
            ],
            "start": 0,
            "limit": "10",
            "flag": "ALL",
            "value": 1
          }
        ],
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          ItemGroupModel responseJson = ItemGroupModel.fromJson(result);
          //   print("branch Id $branchId");
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.itemGroup);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  void savePricing(
      {List<PricingModel> items,
      int optionId,
      StockLocation sourceLocation,
      StockLocation targetLocation,
      List<LocationLookUpItem> locationItems,
      List<ItemDetailListItems> itemDetails,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String attachmentXml}) async {
    int levelValue = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int tableId = await BasePrefs.getInt(BaseConstants.BRANCH_TABLEID);
    int levelCodeId =
        await BasePrefs.getInt(BaseConstants.BRANCH_LEVEL_CODE_ID);
    String levelCode =
        await BasePrefs.getString(BaseConstants.BRANCH_LEVEL_CODE);
    String date = BaseDates(DateTime.now()).dbformatWithTime;

    print(levelCode);
    print(levelCodeId);
    print(levelValue);
    print(tableId);

    Map<String, dynamic> jsonArr = Map<String, dynamic>();

    var jsFinalAry = [
      {
        "LevelId": levelCodeId ?? 2,
        "LevelCode": levelCode ?? "L2",
        "LevelValue": levelValue,
      }
    ];
    var jsLocation = locationItems.map((location) {
      return {
        if (locationItems != null &&
            locationItems.isNotEmpty &&
            locationItems.length > 0)
          "LevelId": location.businesslevelcodeid ?? 2,
        "LevelCode": location.levelcode ?? "L2",
        "LevelValue": location.id ?? 9,
      };
    }).toList();
    jsFinalAry.addAll(jsLocation);

    var jsdataList = itemDetails.map((dataList) {
      if (dataList.newPrice != null)
        return {
          "Id": 0,
          "OptionId": optionId,
          "ItemId": dataList.itemid,
          "pricingDtlId": dataList.pricingdtlid,
          "PricingUomTypeBccId": dataList.uomtypebccid,
          "PricingUomId": dataList.uomid,
          "MRP": dataList.mrp,
          "AdditionalCost": dataList.additionalcost,
          "LandingCost": dataList.landingcost,
          "MfdDate": null,
          "BarCodingQty": dataList.barcodeqty,
          "mrpmarginperc": dataList.mrpmarginperc,
          "mrpmarginamount": dataList.mrpmarginamount,
          "detailsList": [
            {
              "Id": 0,
              "OptionId": optionId,
              "RateTypeBccId": dataList.rateDtl.ratetypebccid,
              "Rate": dataList.rateDtl.rate,
              "TotalMargin": 0,
              "MarginPerc": dataList.rateDtl.marginper,
              "TaxAmount": dataList.rateDtl.tax,
              "SellingCost": dataList.newPrice,
              "taxList": []
            }
          ]
        };
    }).toList();
    jsdataList.removeWhere((element) => element == null);

    jsonArr = {
      "Id": 0,
      "OptionId": optionId,
      "BarCodeGenarateYN": "N",
      "AmendmentDate": date,
      "AmendedFromOptionId": 49,
      "RefTableId": 0,
      "RefTableDataId": 0,
      "date": BaseDates(DateTime.now()).dbformat,
      "BusinessLevelCodeId": levelCodeId,
      "BusinessLevelTableId": tableId,
      //sourceLocation.tableid,
      "RecordStatus": "A",
      "BusinessLevelTableDataId": levelValue ?? "L2",
      "dataList": jsdataList,
      "locationBusinessLevelList": jsFinalAry,
    };

    String service = "putdata";
    String url = "/purchase/controller/trn/savepricingdetail";
    jsonArr["extensionDataObj"] = [];
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
        uuid: 0,
        userid: 0,
        compressdyn: false,
        chkflag: "N",
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result["resultObject"] == "SUCCESS") {
            onRequestSuccess();
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
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
