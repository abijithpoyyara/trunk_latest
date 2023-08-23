import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/bact_items.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/customer_type_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/item_cost_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_detail_list.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_view_list_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/model/uom_object_data_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/currecny_exchange_model.dart';

import '../../../../utility.dart';

class SaleInvoiceRepository extends BaseRepository {
  static final SaleInvoiceRepository _instance = SaleInvoiceRepository._();

  SaleInvoiceRepository._();

  factory SaleInvoiceRepository() => _instance;

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
      if (optionId != null)
        {
          "column": "OptionId",
          "value": "$optionId",
          "datatype": "STR",
          "restriction": "EQU",
          "sortorder": null
        }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": start ?? 0,
      "limit": "$limit",
      "value": value,
      "params": params,
      "colName": "id",
      "dropDownParams": [
        {
          "list": "ITEM-LOOKUP",
          "procName": "mobileitemmstproc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "ITEM"
        }
      ]
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/cmn/getdropdownlist";

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

  getSalesInvoiceView(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      @required
          PVFilterModel filterModel,
      int optionId,
      //@required Function(List<PurchaseViewList> ledgerList) onRequestSuccess,
      @required
          Function(SalesInvoiceViewListModel salesInvoicelistModel)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "Id",
      //  "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      //"TotalRecords": totalRecords,
      "xmlStr": "",
      "params": [
        {
          "column": "ProcessDate",
          "datatype": "EQU",
          "value": "${BaseDates(DateTime.now()).dbformat}"
        },
        {
          "column": "DateFrom",
          "value": "${BaseDates(filterModel?.salesinvoiceFromDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(filterModel?.salesinvoiceToDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        if (filterModel?.salesinvoiceTransno != null &&
            filterModel?.salesinvoiceTransno.isNotEmpty)
          {
            "column": "TransNo",
            "value": "%${filterModel?.salesinvoiceTransno}%",
            "datatype": "STR",
            "restriction": "LIKE",
            "sortorder": null
          },
        {"column": "FinyearId", "datatype": "EQU", "value": finYearId},
        {"column": "OptionId", "datatype": "EQU", "value": optionId}
      ],
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/sales/controller/trn/getsalesinvdetailsusingproc";

    SalesInvoiceViewListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = SalesInvoiceViewListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getDetailListOfSalesInvoice(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      @required
          PVFilterModel filterModel,
      int optionId,
      SalesInvoiceSavedViewList salesInvoicelist,
      @required
          Function(List<SalesInvoiceDetailList> salesInvoiceDtlList)
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": 0,
      "limit": "10",
      "value": salesInvoicelist.Id,
      "colName": "Id",
      //  "SOR_Id": sor_Id,
      // "EOR_Id": eor_Id,
      // "TotalRecords": totalRecords,
      "xmlStr": "",
      "params": [
        {
          "column": "ProcessDate",
          "datatype": "EQU",
          "value": "${BaseDates(DateTime.now()).dbformat}"
        },
        {
          "column": "DateFrom",
          "value": "${BaseDates(filterModel?.salesinvoiceFromDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {
          "column": "DateTo",
          "value": "${BaseDates(filterModel?.salesinvoiceToDate).dbformat}",
          "datatype": "DTE",
          "restriction": "EQU",
          "sortorder": null
        },
        {"column": "FinyearId", "datatype": "EQU", "value": finYearId},
        {"column": "OptionId", "datatype": "EQU", "value": optionId}
      ],
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/sales/controller/trn/getsalesinvdetailsusingproc";

    SalesInvoiceDtlListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = SalesInvoiceDtlListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.salesInvoiceDtlList)
              // onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> addToCart(
      {@required Function() onRequestSuccess,
      @required Function(AppException) onRequestFailure,
      ProductModel product}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String itemXml = XMLBuilder(tag: "ItemCartDtl")
        .addElement(key: "ItemId", value: '${product.itemid}')
        .addElement(key: "MobileUserId", value: '$userId ')
        .addElement(key: "OptionId", value: '59')
        .addElement(key: "Qty", value: '1')
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "itemcartlistproc",
            actionFlag: "INSERT",
            subActionFlag: "",
            key: "resultObject",
            xmlStr: itemXml)
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          print(" response $result");
          if (responseJson.statusCode == 1 &&
              result.containsKey("resultObject")) {
            onRequestSuccess();
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getCartConfigs(
      {@required
          Function(List<LocationModel>, List<BCCModel>, BSCModel)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String service = "getdata";

    List jssArr = DropDownParams()
        .addParams(
          list: 'BAYASYSTEMCONSTANTS',
          key: 'QtyEditableYN',
          params: [
            {
              "column": "constantgroup",
              "value": "SALES",
              "datatype": "STR",
              "restriction": "EQU"
            },
            {
              "column": "constantcode",
              "value": "QTY_EDITABLEYN",
              "datatype": "STR",
              "restriction": "EQU"
            },
          ],
        )
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "StatusHdrList",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "SALE_ENQUIRY_STATUS_HDR")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "BranchBccList",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "MOB_SALEENQ_LOCATION")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "EXEC-PROC",
            key: "branchDetails",
            xmlStr: XMLBuilder(tag: "DropDown")
                .addElement(
                    key: "OptionBusinessLevelCode",
                    value: "INVENTORY_BILLING_LEVEL")
                .buildElement(),
            procName: "BusinessSubLevelProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
        .callReq();
    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LocationListModel responseJson = LocationListModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            List<BCCModel> statusHdr;
            List<BCCModel> branchesBcc = [];
            List<LocationModel> branchList = [];
            BSCModel isQtyUpdatableYn;
            if (result.containsKey("StatusHdrList")) {
              statusHdr = BaseJsonParser.goodList(result, "StatusHdrList")
                  .map((e) => BCCModel.fromJson(e))
                  .toList();
            }
            if (result.containsKey("QtyEditableYN")) {
              isQtyUpdatableYn =
                  BaseJsonParser.goodList(result, "QtyEditableYN")
                      .map((e) => BSCModel.fromJson(e))
                      .first;
            }
            if (result.containsKey("BranchBccList")) {
              print("branches : ${result["BranchBccList"]}");
              branchesBcc = BaseJsonParser.goodList(result, "BranchBccList")
                  .map((e) => BCCModel.fromJson(e))
                  .toList();
            }
            branchList = responseJson.branchList;
            if (branchesBcc.isNotEmpty) {
              branchList = (responseJson?.branchList ?? [])
                  .where((branch) =>
                      branchesBcc.any((bcc) => bcc.code == branch.code))
                  .toList();
            }
            onRequestSuccess(branchList, statusHdr, isQtyUpdatableYn);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  // getBranchList(
  //     {@required Function(List<LocationModel>) onRequestSuccess,
  //     @required Function(AppException) onRequestFailure}) async {
  //   String service = "getdata";
  //
  //   List jssArr = DropDownParams()
  //       .addParams(
  //           list: "BAYACONTROLCODES-DROPDOWN",
  //           key: "BranchBccList",
  //           xmlStr: XMLBuilder(tag: "List")
  //               .addElement(key: "TableCode", value: "MOB_SALEENQ_LOCATION")
  //               .buildElement(),
  //           procName: "bayacontrolcodelistproc",
  //           actionFlag: "LIST",
  //           subActionFlag: "")
  //       .addParams(
  //           list: "EXEC-PROC",
  //           key: "branchDetails",
  //           xmlStr: XMLBuilder(tag: "DropDown")
  //               .addElement(
  //                   key: "OptionBusinessLevelCode",
  //                   value: "INVENTORY_BILLING_LEVEL")
  //               .buildElement(),
  //           procName: "BusinessSubLevelProc",
  //           actionFlag: "DROPDOWN",
  //           subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
  //       .callReq();
  //   String url = "/security/controller/cmn/getdropdownlist";
  //
  //   performRequest(
  //       service: service,
  //       jsonArr: jssArr,
  //       url: url,
  //       onRequestFailure: onRequestFailure,
  //       onRequestSuccess: (result) {
  //         LocationListModel responseJson = LocationListModel.fromJson(result);
  //         if (responseJson.statusCode == 1) {
  //           List<BCCModel> branchesBcc = [];
  //           List<LocationModel> branchList = [];
  //
  //           if (result.containsKey("BranchBccList")) {
  //             branchesBcc = BaseJsonParser.goodList(result, "BranchBccList")
  //                 .map((e) => BCCModel.fromJson(e))
  //                 .toList();
  //           }
  //           branchList = responseJson.branchList;
  //           if (branchesBcc.isNotEmpty) {
  //             branchList = (responseJson?.branchList ?? [])
  //                 .where((branch) =>
  //                     branchesBcc.any((bcc) => bcc.code == branch.code))
  //                 .toList();
  //           }
  //           onRequestSuccess(branchList);
  //         } else
  //           onRequestFailure(InvalidInputException(responseJson.statusMessage));
  //       });
  // }

  Future<void> getCartDetails(
      {@required Function(List<CartItemModel>) onRequestSuccess,
      @required Function(AppException) onRequestFailure,
      ProductDetailModel product}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String itemXml = XMLBuilder(tag: "List")
        .addElement(key: "MobileUserId", value: '$userId ')
        .addElement(key: "OptionId", value: '59 ')
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "itemcartlistproc",
            actionFlag: "LIST",
            subActionFlag: "CART",
            key: "resultObject",
            xmlStr: itemXml)
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          CartListModel responseJson = CartListModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey("resultObject")) {
            onRequestSuccess(responseJson.products);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> updateQty(
      {CartItemModel item,
      int qty,
      @required Function() onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String itemXml = XMLBuilder(tag: "ItemCartDtl")
        .addElement(key: "MobileUserId", value: '$userId')
        .addElement(key: "ItemId", value: '${item.itemId}')
        .addElement(key: "Qty", value: '$qty')
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "itemcartlistproc",
            actionFlag: "UPDATE",
            subActionFlag: "QTY",
            key: "resultObject",
            xmlStr: itemXml)
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey("resultObject")) {
            onRequestSuccess();
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> removeCartItem(
      {CartItemModel item,
      @required Function() onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);

    String itemXml = XMLBuilder(tag: "List")
        .addElement(key: "MobileUserId", value: '$userId ')
        .addElement(key: "ItemId", value: '${item.itemId} ')
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "itemcartlistproc",
            actionFlag: "UPDATE",
            subActionFlag: "REMOVE_ITEM",
            key: "resultObject",
            xmlStr: itemXml)
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey("resultObject")) {
            onRequestSuccess();
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> removeListCartItem(
      {List<CartItemModel> item,
      @required Function() onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    List arry = [];
    List<String> value = [];
    for (int i = 0; i < item.length; i++) {
      String itemXml = XMLBuilder(tag: "ItemCartDtl")
          .addElement(key: "MobileUserId", value: '$userId ')
          .addElement(key: "ItemId", value: '${item[i].itemId} ')
          .buildElement();
      arry.add(itemXml);
    }

    print("Neenu ${arry}");
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "itemcartlistproc",
            actionFlag: "UPDATE",
            subActionFlag: "ProcessedYN",
            key: "resultObject",
            xmlStr: arry.toString())
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey("resultObject")) {
            onRequestSuccess();
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> getCustomerTypes(
      {@required Function(List<CustomerTypes> customerTypes) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "CUSTOMER_TYPE")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "CustomerTypeList",
            xmlStr: xmlStatus,
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    CustomerTypeModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = CustomerTypeModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.customerType)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getItemRate(
      {int refOptionId,
      DateTime transDate,
      int itemId,
      @required Function(CostOverviewModel) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "TransDate", value: "$transDate")
        .addElement(key: "RefOptionId", value: "$refOptionId")
        .addElement(key: "CompanyId", value: "$companyId")
        .addElement(key: "FinyearId", value: "$finyearId")
        .addElement(key: "TaxApplicableFlag", value: "B2C")
        .addElement(key: "InterStateYN", value: "N")
        .buildElement();
    String item = XMLBuilder(tag: "Item")
        .addElement(key: "ItemId", value: "$itemId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlStatus + item,
            procName: "GetItemRateUsingMrp",
            actionFlag: "LIST",
            subActionFlag: "SALES_ITEM_RATE")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          CostOverviewModel responseJson = CostOverviewModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> getInitialConfig(
      {@required Function(List<UomTypes>) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    List jssArr = DropDownParams()
        .addParams(
          list: "UOM",
          key: "uomObject",
        )
        .callReq();

    String url = "/inventory/controller/cmn/getdropdownlist";
    String service = "getdata";
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

  getConfigs(
      {@required Function(BSCModel, List<BCCModel>, BSCModel) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String service = "getdata";

    List jssArr = DropDownParams()
        .addParams(
          list: 'BAYASYSTEMCONSTANTS',
          key: 'analysisCodeObj',
          params: [
            {
              "column": "constantgroup",
              "value": "ACCOUNTS",
              "datatype": "STR",
              "restriction": "EQU"
            },
            {
              "column": "constantcode",
              "value": "DEFAULT_ANALYSIS_CODE",
              "datatype": "STR",
              "restriction": "EQU"
            },
            {"column": "companyid", "datatype": "STR", "restriction": "EQU"},
          ],
        )
        .addParams(
            procName: "CurrencyListProc",
            list: 'CURRENCY_DROPDOWN',
            key: 'currencyList',
            actionFlag: "LIST",
            subActionFlag: "CURRENCY",
            xmlStr: "<DATA><List></List></DATA>")
        .addParams(
          list: 'BAYASYSTEMCONSTANTS',
          key: 'analysisCodeObj',
          params: [
            {
              "column": "constantgroup",
              "value": "ACCOUNTS",
              "datatype": "STR",
              "restriction": "EQU"
            },
            {
              "column": "constantcode",
              "value": "DEFAULT_ANALYSIS_CODE",
              "datatype": "STR",
              "restriction": "EQU"
            },
            {"column": "companyid", "datatype": "STR", "restriction": "EQU"},
          ],
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
          if (responseJson.statusCode == 1) {
            BSCModel analysisCodeObj;
            List<BCCModel> currencyList;
            BSCModel analysisCodeTypeObj;

            if (result.containsKey("analysisCodeObj")) {
              analysisCodeObj =
                  BaseJsonParser.goodList(result, "analysisCodeObj")
                      .map((e) => BSCModel.fromJson(e))
                      .first;
            }

            if (result.containsKey("analysisCodeTypeObj")) {
              analysisCodeTypeObj =
                  BaseJsonParser.goodList(result, "analysisCodeTypeObj")
                      .map((e) => BSCModel.fromJson(e))
                      .first;
            }
            if (result.containsKey("currencyList")) {
              currencyList = BaseJsonParser.goodList(result, "currencyList")
                  .map((e) => BCCModel.fromJson(e))
                  .toList();
            }

            onRequestSuccess(
                analysisCodeObj, currencyList, analysisCodeTypeObj);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getSalesmanObj(
      {@required Function(List<SalesmanObjects> salesman) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "Start", value: "0")
        .addElement(key: "PersonnelType", value: "SALESMAN")
        .addElement(key: "Limit", value: "1000")
        .addElement(key: "FinyearId", value: "$finyearId")
        .addElement(key: "Total", value: "1")
        .addElement(key: "Mode", value: "NEW")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "salesmanObject",
            xmlStr: xmlStatus,
            procName: "GetPersonnelMstProc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          SalesmanModel responseJson = SalesmanModel.fromJson(result);
          print("branch Id $branchId");
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.salesman);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getCurrencyExchange(
      {
      //int typeBccId,
      @required Function(List<CurrencyExchange> currencyEX) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int companyCurrecny = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "CompanyId", value: "1")
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

  getCustomer(
      {
      //int typeBccId,
      @required Function(List<CustomersList> customer) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "Start", value: "0")
        .addElement(key: "Limit", value: "10")
        .buildElement();
    String item = XMLBuilder(tag: "CustomerType")
        .addElement(key: "TypeBccId", value: "1159")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlStatus + item,
            procName: "CustomerMstProc",
            actionFlag: "LIST",
            subActionFlag: "CUSTOMERLIST")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          CustomersModel responseJson = CustomersModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.customers);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  // getBatchItem(
  //     {int optionId,
  //     DateTime wefDate,
  //     int itemId,
  //     int uomID,
  //     @required Function(List<BatchList> batchList) onRequestSuccess,
  //     @required Function(AppException) onRequestFailure}) async {
  //   int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
  //   int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
  //   int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
  //
  //   String xmlStatus = XMLBuilder(tag: "List")
  //       .addElement(key: "WefDate", value: "$wefDate")
  //       .addElement(key: "OptionId", value: "$optionId")
  //       .buildElement();
  //   String item = XMLBuilder(tag: "Item")
  //       .addElement(key: "ItemId", value: "$itemId")
  //       .addElement(key: "UomId", value: "$uomID")
  //       .buildElement();
  //   List jssArr = DropDownParams()
  //       .addParams(
  //           list: "EXEC-PROC",
  //           key: "resultDatchDetailsObject",
  //           xmlStr: xmlStatus + item,
  //           procName: "ItemBatchListProc",
  //           actionFlag: "LIST",
  //           subActionFlag: " ")
  //       .callReq();
  //
  //   String url = "/security/controller/cmn/getdropdownlist";
  //   String service = "getdata";
  //   performRequest(
  //       service: service,
  //       jsonArr: jssArr,
  //       url: url,
  //       onRequestFailure: onRequestFailure,
  //       onRequestSuccess: (result) {
  //         BatchModel responseJson = BatchModel.fromJson(result);
  //         if (responseJson.statusCode == 1) {
  //           onRequestSuccess(responseJson.batchList);
  //         } else
  //           onRequestFailure(InvalidInputException(responseJson.statusMessage));
  //       });
  // }

  getCostItem(
      {int optionId,
      DateTime wefDate,
      int itemId,
      int uomID,
      int itembatchId,
      @required Function(List<CostItem> costItemList) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

    String xmlStatus = XMLBuilder(tag: "List")
        .addElement(key: "WefDate", value: "$wefDate")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();
    String item = XMLBuilder(tag: "Item")
        .addElement(key: "ItemId", value: "$itemId")
        .addElement(key: "UomId", value: "$uomID")
        .addElement(key: "ItemBatchId", value: "$itembatchId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlStatus + item,
            procName: "GetItemCostProc",
            actionFlag: "LIST",
            subActionFlag: " ")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          CostItemModel responseJson = CostItemModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(responseJson.costItemList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getLocationObjects(
      {@required Function(List<StockLocation>) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
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
            xmlStr: XMLBuilder(tag: "DropDown")
                .addElement(
                    key: "OptionBusinessLevelCode",
                    value: "SALES_BILLING_BL_LEVEL")
                .buildElement(),
            procName: "BusinessSubLevelProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "OPT_BUSINESS_LEVEL_FITER")
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
            //  List<StockLocationModel> branchesBcc = [];
            List<StockLocation> location = [];

            if (result.containsKey("locationObject")) {
              location = BaseJsonParser.goodList(result, "locationObject")
                  .map((e) => StockLocation.fromJson(e))
                  .toList();
            }
            location = responseJson.location;
            if (location.isNotEmpty) {
              location = (responseJson?.location ?? [])
                  .where((branch) =>
                      location.any((bcc) => bcc.branchid == branchId))
                  .toList();
            }
            onRequestSuccess(location);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
    //   if (responseJson.statusCode == 1) {
    //     List<StockLocation> location = responseJson.location
    //         .where((e) => e.branchid == branchId)
    //         .toList();
    //
    //     onRequestSuccess(responseJson.location);
    //   } else
    //     onRequestFailure(InvalidInputException(responseJson.statusMessage));
    // });
  }

  void saveInvoice({
    int optionId,
    LocationModel location,
    List<CartItemModel> products,
    BCCModel status,
    // List<BatchList> batch,
    CartItemModel cartItemModel,
    //  BatchList batchList,
    CustomersList customersList,
    //List<CartTax>
    // Cart
    Customer customer,
    double totalValues,
    List<SalesmanObjects> saleman,
    List<StockLocation> despatchFrom,
    List<CurrencyExchange> currencyEx,
    List<CustomersList> custList,
    List<CustomerTypes> types,
    BSCModel analysisCode,
    BSCModel analysisType,
    CustomerTypes customerTypes,
    StockLocation sourceLocation,
    StockLocation targetLocation,
    @required Function() onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int locationId = await BasePrefs.getInt(BaseConstants.LOCATION_ID_KEY);
    int companyCurrencyId =
        await BasePrefs.getInt(BaseConstants.COMPANY_BASE_CURRENCY_ID);
    int branchCurrencyId =
        await BasePrefs.getInt(BaseConstants.BRANCH_CURRENCY_ID);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String date = BaseDates(DateTime.now()).dbformatWithTime;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    // print("neethu=====${model.batchList}");
    SalesmanObjects findSaleman;
    print("salesman===${saleman.length}");
    print(companyCurrencyId);
    print("location Id${locationId}");
    print(branchCurrencyId);
    print("branch Id${branchId}");
    // print("Customer${customersList.name}");
    //print("CustomerType${customerTypes.code}");
    print("Cus${custList.length}");
    print("Cus${types.length}");
    print("temp ${types.first}");
    print("temmpCust${custList.first}");
    CustomersList cusList;
    cusList = custList.first;
    CurrencyExchange currency;
    currency = currencyEx.first;

    int customerId() {
      var id;
      types.forEach((element) {
        if (element.code == "WALK_IN_CUSTMR") {
          print("customerID${element.id}");
          id = element.id;
        }
      });
      return id;
      // types.forEach((element) {
      //   if (element.code == "WALK_IN_CUSTMR") {
      //     print("Elementid${element.id}");
      //     // return element.id;
      //   }
      // });
      // return null;
    }

    int custId() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        print("cuscode${cusList.id}");
        return cusList.id;
      }
    }

    int custAcctId() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        return cusList.account_id;
      }
    }

    int custAnalysisCodeId() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        return cusList.analysiscodeid;
      }
    }

    String custAnalysisTypeId() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        return cusList.analysiscodetypeid;
      }
    }

    String mobileData() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        return cusList.mobile;
      }
    }

    String phone() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        return cusList.phone;
      }
    }

    String custName() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        return cusList.name;
      }
    }

    String custAdd1() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        print("add1====${cusList.address1}");
        return cusList.address1;
      }
    }

    String custAdd2() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        print("add2====${cusList.address2}");
        return cusList.address2;
      }
    }

    String custAdd3() {
      if (cusList.customertype == "WALK_IN_CUSTMR") {
        print("add3====${cusList.address3}");
        return cusList.address3;
      }
    }

    double findExchangeRate() {
      var exrate;
      currencyEx.forEach((element) {
        if (element.fromcurrencyid == branchCurrencyId &&
            element.tocurrencyid == companyCurrencyId) {
          print("exe${element.conversionrate}");
          exrate = element.conversionrate;
        }
      });
      return exrate;
    }

    var exRate = findExchangeRate();
    var exchangeRate = double.parse(exRate.toStringAsFixed(2));
    print(totalValues * exchangeRate);
    print(exchangeRate);

    int findDespatchId() {
      var id;
      despatchFrom.forEach((element) {
        if (element.branchid == branchId) {
          print("Elementid${element.id}");
          id = element.id;
        }
      });
      return id;
    }

    String findDespatchLevelCode() {
      var levelcode;
      despatchFrom.forEach((element) {
        if (element.branchid == branchId) {
          print("Elementid${element.levelcode}");
          levelcode = element.levelcode;
        }
      });
      return levelcode;
    }

    int findDespatchBusinessLvelId() {
      var buslevelcode;
      despatchFrom.forEach((element) {
        if (element.branchid == branchId) {
          print("businesslevelcodeid${element.businesslevelcodeid}");
          buslevelcode = element.businesslevelcodeid;
        }
      });
      return buslevelcode;
    }

    int findDespatchTableId() {
      var tableid;
      despatchFrom.forEach((element) {
        if (element.branchid == branchId) {
          print("Elementid${element.tableid}");
          tableid = element.tableid;
        }
      });
      return tableid;
    }

    int findSalesmanId() {
      var personalId;
      saleman.forEach((element) {
        if (element.userid == userId) {
          print("Elementid${element.userid}");
          personalId = element.personnelid;
        }
      });
      return personalId;
    }

    // var tempDeductedtax = cartItemModel?.rateDtl?.taxes
    //     ?.fold(0, (preval, tax) => preval + tax.deductedTax);
    // double temptotalRate = (cartItemModel?.qty ?? 0) *
    //     (cartItemModel.rateDtl?.mrpDtl?.rateInclTax ?? 0);
    // double temptotalTax = cartItemModel.rateDtl.taxes
    //     .fold(0, (preval, tax) => preval + tax.taxAmt);
    // double tempgrossTotal = temptotalRate + temptotalTax;
    // double tempnetTotal = tempgrossTotal - tempDeductedtax;

    // print("tempDeductedtax${tempDeductedtax}");
    // print("tempnetTotal${tempnetTotal}");
    // print("temptotalTax${temptotalTax}");
    // print("tempgrossTotal${tempgrossTotal}");
    // print("temptotalRate${temptotalRate}");

    var finalTaxAry = [];
    var jsonAryDtl = products.map((record) {
      int bundlingqty = record.bundlingqty ?? 0;
      double deductedTax = record.rateDtl.taxes
          .fold(0, (preval, tax) => preval + tax.deductedTax);
      double totalRate =
          (record?.qty ?? 0) * (record.rateDtl?.mrpDtl?.rateInclTax ?? 0);
      double totalTax =
          record.rateDtl.taxes.fold(0, (preval, tax) => preval + tax.taxAmt);
      double grossTotal = totalRate + totalTax;
      double netTotal = grossTotal - deductedTax;
      double costRate = record?.batchDtl?.nlc;
      double totalCost = (record?.qty ?? 0) * costRate ?? 1;
      var jsonAryTaxDtl = record.rateDtl.taxes.map((taxDetails) {
        return {
          "Id": 0,
          "taxattachmentid": taxDetails.attachmentId,
          "taxapplicableamount":
              double.parse(taxDetails.taxAppAmt.toStringAsFixed(2)),
          "taxperc": taxDetails.taxPerc,
          "effectonparty": taxDetails.effectOnParty,
          "totaltaxamount": taxDetails.deductedTax > 0
              ? double.parse(taxDetails.deductedTax.toStringAsFixed(2))
              : double.parse(taxDetails.taxAmt.toStringAsFixed(2)),
          "taxaccountid": taxDetails.taxAccountId
        };
      }).toList();
      var jsonTaxDtl = record.rateDtl.taxes.map((taxDetails) {
        print("taxDtl${record.rateDtl.taxes}");
        var taxDtl = {
          "Id": 0,
          "taxattachmentid": taxDetails.attachmentId,
          "taxapplicableamount":
              double.parse(taxDetails.taxAppAmt.toStringAsFixed(2)),
          "taxperc": taxDetails.taxPerc,
          "effectonparty": taxDetails.effectOnParty,
          "totaltaxamount": taxDetails.deductedTax > 0
              ? double.parse(taxDetails.deductedTax.toStringAsFixed(2))
              : double.parse(taxDetails.taxAmt.toStringAsFixed(2)),
          "deductedtax":
              double.parse(taxDetails.deductedTax.toStringAsFixed(2)),
          "taxaccountid": taxDetails.taxAccountId
        };
        finalTaxAry.add(taxDtl);
        return taxDtl;
      }).toList();
      print("jsonTaxDtl${jsonTaxDtl}");
      // var taxVch = record.rateDtl.taxes.map((voucher) {
      //   return {
      //     "valuetype": "TAX",
      //     "value": voucher.taxAccountId,
      //     "refvalue": "RTAL_SALE_VCH_CODE",
      //     "crordr": "C",
      //     "amount": voucher.deductedTax > 0
      //         ? voucher.deductedTax.toPrecision()
      //         : voucher.taxAmt.toPrecision(),
      //     "lccurrencyid": 4,
      //     "fccurrencyid": 4,
      //     "exchrate": 1,
      //     "localcurrencyamount": voucher.deductedTax > 0
      //         ? voucher.deductedTax.toPrecision()
      //         : voucher.taxAmt.toPrecision(),
      //     "analysiscodeid": "10",
      //     "analysiscodetypeid": "8"
      //   };
      // }).toList();
      //

      return {
        "Id": 0,
        "itemid": record.itemId,
        "itemnametoprint": record.itemName,
        "uomid": record.rateDtl.uomId,
        // "bundlingqty": record.bundlingqty ?? 0,
        //"packingqty": record.packingqty ?? 0,
        "uomtypebccid": record.rateDtl.uomTypeBccId,
        "qty": record.qty,
        "ratetypebccid": record.rateDtl.rateTypeBccId,
        "rate": record.rateDtl?.mrpDtl?.rateInclTax?.toPrecision(),
        "rateafterdisc": record.rateDtl?.mrpDtl?.rateInclTax,
        "rateincldtax": 0,
        "totalvalue": double.parse(totalRate.toStringAsFixed(2)),
        "totalvaluelc":
            double.parse((totalRate * exchangeRate).toStringAsFixed(2)),
        "totaldisc": 0,
        "subtotal": double.parse(totalRate.toStringAsFixed(2)),
        "totaltax": double.parse(totalTax.toStringAsFixed(2)),
        "grosstotal": double.parse(grossTotal.toStringAsFixed(2)),
        "discaftertax": 0,
        "othercharges": 0,
        "freightcharges": 0,
        "deductedtax": double.parse(deductedTax.toStringAsFixed(2)),
        "nettotal": double.parse(netTotal.toStringAsFixed(2)),
        "roundoff": 0,
        "totalafterroundoff": double.parse(netTotal.toStringAsFixed(2)),
        "fccurrencyid": branchCurrencyId,
        "lccurrencyid": companyCurrencyId,
        "exchrate": exchangeRate ?? 1,
        "lctotalafterroundoff":
            double.parse((netTotal * exchangeRate).toStringAsFixed(2)),
        "orginalrate": double.parse(
            record.rateDtl?.mrpDtl?.rateInclTax?.toStringAsFixed(2)),
        "statucbccid": status.id,
        "statuswefdate": BaseDates(DateTime.now()).dbformat,
        "ishidden": "N",
        "dtlisblockedyn": "N",
        "costrate": double.parse(costRate.toStringAsFixed(2)),
        "totalcost": double.parse(totalCost.toStringAsFixed(2)),
        "dtlTaxDtoList": jsonAryTaxDtl,
        "itemDiscountDtoList": [],
        "dtlSourceMappingDtoList": [],
        "dtlStockList": [
          {
            "date": (BaseDates(DateTime.now()).dbformat).replaceAll("-", ""),
            //  BaseDates(DateTime.now()).dbformat,
            "companyid": companyId.toString(),
            "branchid": branchId.toString(),
            "finyearid": finYearId,
            "businesslevelcodeid": findDespatchBusinessLvelId(),
            "blreftableid": findDespatchTableId(),
            "blreftabledataid": locationId,
            "uomid": record.rateDtl.uomId,
            "uomtypeid": record.rateDtl.uomTypeBccId,
            "itemid": record.itemId,
            "isstockinyn": "N",
            "rate": record?.rate ?? 0,
            "mrp": record.rateDtl.mrpDtl.mrp ?? 0,
            "nlc": record.batchDtl?.nlc,
            "additionalcost": 0,
            "itembatchid": record.batchDtl?.itembatchid,
            "recordstatus": "A",
            "bookstockquantity": record.qty,
            "physicalstockquantity": record.qty,
            "srcMapodelList": [
              {
                "optionid": optionId,
                "reftableid": null,
                "reftabledataid": null,
                "generateduomid": record.rateDtl.uomId,
                "generateduomtypebccid": record.rateDtl.uomTypeBccId,
                "generatedqty": record.qty,
                "refhdrtableid": null,
                "refhdrtabledataid": null
              }
            ],
            "itemUomWiseModelList": []
          }
        ],
        "itemwiseList": [
          {
            "optionid": optionId,
            "itemid": record.itemId,
            "reftabledataid": record.batchDtl?.itembatchid ?? 18818,
            "nlc": record.batchDtl?.nlc ?? 195,
            "qty": record.qty
          }
        ]
        // batchDtl,
      };
    }).toList();

    var uniqueActId = [];
    finalTaxAry.forEach((element) {
      var flag = uniqueActId.contains(element["taxaccountid"]);
      if (!flag) {
        uniqueActId.add(element["taxaccountid"]);
      }
    });

    print("uniq${uniqueActId}");

    List tempVchArray = [
      {
        "valuetype": "CUSTOMER",
        "value": custAcctId() ?? 50168,
        "crordr": "D",
        "refvalue": "RTAL_SALE_VCH_CODE",
        "amount": double.parse(totalValues.toStringAsFixed(2)),
        "lccurrencyid": companyCurrencyId,
        "fccurrencyid": branchCurrencyId,
        "exchrate": exchangeRate ?? 1,
        "localcurrencyamount":
            double.parse((totalValues * exchangeRate ?? 1).toStringAsFixed(2)),
        "analysiscodeid": custAnalysisCodeId(),
        "analysiscodetypeid": custAnalysisTypeId()
      }
    ];

    uniqueActId.forEach((id) {
      var filteredAry = [];

      finalTaxAry.forEach((element) {
        if (element["taxaccountid"] == id) filteredAry.add(element);
      });
      print("filtered${filteredAry}");
      double taxAmt = 0;
      double deductedTax = 0;

      var finalTaxAmt = filteredAry.forEach((element) {
        taxAmt += element["totaltaxamount"];
      });
      var finaldeductedTax = filteredAry.forEach((element) {
        deductedTax += element["deductedtax"];
      });
      //  finalTaxAry.clear();

      var taxRowVal = (deductedTax > 0 ? deductedTax : taxAmt);
      tempVchArray.add({
        "valuetype": "TAX",
        "value": id,
        "refvalue": "RTAL_SALE_VCH_CODE",
        "crordr": deductedTax > 0 ? "D" : "C",
        "amount": deductedTax > 0
            ? double.parse(deductedTax.toStringAsFixed(2))
            : double.parse(taxAmt.toStringAsFixed(2)),
        "lccurrencyid": companyCurrencyId,
        "fccurrencyid": branchCurrencyId,
        "exchrate": exchangeRate ?? 1,
        "localcurrencyamount":
            double.parse((taxRowVal * exchangeRate ?? 1).toStringAsFixed(2)),
        "analysiscodeid": analysisCode.constantValue.toString(),
        "analysiscodetypeid": analysisType.constantValue.toString()
      });
    });

    // var tempT = products.map((e) {
    //   double vchdeductedTx =
    //       e.rateDtl.taxes.fold(0, (preval, tax) => preval + tax.deductedTax);
    //   double vchRate = (e?.qty ?? 0) * (e.rateDtl?.mrpDtl?.rateInclTax ?? 0);
    //   double vchTax =
    //       e.rateDtl.taxes.fold(0, (preval, tax) => preval + tax.taxAmt);
    //
    //   double vchGrossTotal = vchRate + vchTax;
    //   double vchNetTotal = vchGrossTotal - vchdeductedTx;
    //   //  var taxAcct=e.rateDtl.taxes.forEach((element) {element.taxAccountId})
    //   var taxValue = e?.rateDtl?.taxes.map((voucher) {
    //     var taxRowVal =
    //         (voucher.deductedTax > 0 ? voucher.deductedTax : voucher.taxAmt);
    //     return {
    //       "valuetype": "TAX",
    //       "value": voucher.taxAccountId,
    //       "refvalue": "RTAL_SALE_VCH_CODE",
    //       "crordr": voucher.deductedTax > 0 ? "D" : "C",
    //       "amount": voucher.deductedTax > 0
    //           ? voucher.deductedTax.toPrecision()
    //           : voucher.taxAmt.toPrecision(),
    //       "lccurrencyid": companyCurrencyId,
    //       "fccurrencyid": branchCurrencyId,
    //       "exchrate": findExchangeRate() ?? 1,
    //       "localcurrencyamount":
    //           (taxRowVal * findExchangeRate() ?? 1).toPrecision(),
    //       "analysiscodeid": analysisCode.constantValue.toString(),
    //       "analysiscodetypeid": analysisType.constantValue.toString()
    //     };
    //   }).toList();
    //
    //   return taxValue;
    // }).toList();
    print("out${tempVchArray}");

    // tempVchArray.addAll(tempT);

    jsonArr = {
      "Id": 0,
      "optionid": optionId,
      "amendmentno": 0,
      "amendmentdate": BaseDates(DateTime.now()).dbformatWithTime,
      "amendedfromoptionid": optionId,
      "companyid": companyId.toString(),
      "branchid": branchId.toString(),
      "finyearid": finYearId,
      "salesinvno": "",
      "salesinvdate": BaseDates(DateTime.now()).dbformatWithTime,
      "delduedate": BaseDates(DateTime.now()).dbformatWithTime,
      "paymentmode": "CA",
      "customertypebccid": customerId(),
      "customerid": custId(),
      "emailid": null,
      "mobile": mobileData(),
      "phone": phone(),
      "deliveryadd1": custName(),
      "deliveryadd2": custAdd1(),
      "deliveryadd3": custAdd2(),
      "deliveryadd4": custAdd3(),
      "remarks": "",
      "fsno": null,
      "refinvoiceno": null,
      "refinvoicedate": null,
      "fccurrencyid": branchCurrencyId ?? 4,
      "lccurrencyid": companyCurrencyId,
      "exchrate": exchangeRate ?? 1,
      "referenceno": "",
      "salesmanid": findSalesmanId(),
      "statusbccid": status?.id,
      "processfrom": "DIRECT",
      "reasonid": 0,
      "statuswefdate": BaseDates(DateTime.now()).dbformat,
      "businesslevelcode": findDespatchLevelCode(),
      "businesslevelcodeid": findDespatchBusinessLvelId(),
      "reftableid": findDespatchTableId(),
      "reftabledataid": locationId,
      "isblockedyn": "N",
      "recordstatus": "A",
      "transactionuniqueid": 0,
      "createduserid": userId,
      "createddate": BaseDates(DateTime.now()).dbformat,
      "dtlDtoList": jsonAryDtl,
      "discDtoList": [],
      "voucherhdrid": 0,
      "docAttachReqYN": true,
      "vchList": tempVchArray,
      "docAttachXml": "",
    };
    //  jsonArr.removeWhere((key, value) => null);
    Text("neenu====${jsonArr}");

    String service = "putdata";
    String url = "/sales/controller/trn/savesalesinv";

    jsonArr["extensionDataObj"] = [];

    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];

    jsonArr["SerialNoCol"] = "salesinvno";
    jsonArr["supperuseryn"] = "N";
    jsonArr["warningacceptyn"] = "N";

    jsonArr["TransDateCol"] = "salesinvdate";

    jsonArr["checkListDataObj"] = [];
    print("data::::=====${jsonArr}");

    print("data111::::=====${json.encode(jsonArr)}");
    // print("nbb===${batch.length}");
    // print("voucher${batchDtl}");
    var request = json.encode(jsonArr);

    print("data====${jsonArr}");
    print("value===${request}");
    // print("list${vchArr}");
    List resultValue = [];
    resultValue.add(request);
    List jssArr = List();
    jssArr.add(request);
    print(json.encode(jsonArr));
    print(jsonArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        userid: 0,
        uuid: 0,
        compressdyn: false,
        chkflag: "N",
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              // if (responseJson?.statusMessage?.contains("Success") &&
              //     responseJson.result)
              //   onRequestSuccess()
              if (responseJson.statusCode == 1 &&
                  result.containsKey("resultObject") &&
                  responseJson.statusMessage == "Success")
                onRequestSuccess()
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
