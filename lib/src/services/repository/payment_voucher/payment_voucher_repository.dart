import 'dart:convert';

import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/process_from_list.dart';
import 'package:redstars/src/services/model/response/payment_voucher/account_balance_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/initial_data_list_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/payment_voucher/voucher_purchase_order_model.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';

String r;

class PaymentVoucherRepository extends BaseRepository {
  static final PaymentVoucherRepository _instance =
      PaymentVoucherRepository._();

  PaymentVoucherRepository._();

  factory PaymentVoucherRepository() => _instance;

  Future<void> getInitialConfigs(
      {@required
          Function({
        List<BCCModel> paymentFlowTypes,
        List<BCCModel> voucherTypes,
        List<BCCModel> voucherTypesRender,
        List<BCCModel> instrumentTypes,
        List<BSCModel> editableYnObj,
        List<BCCModel> paymentEntryProcessFromObj,
        List<BCCModel> paymentTypes,
        List<BCCModel> paidToTypes,
        List<BSCModel> analysisCodeObj,
        List<BSCModel> analysisCodeTypeObj,
        List<BCCModel> paidToTypeBccId,
        List<BCCModel> settlementTypes,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "paymentTypes",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_REQ_TRANS_TYPE")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "EXEC-PROC",
            key: "reqTypeObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_REQ_TYPE")
                .addElement(key: "CodeName ", value: "Code")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "EXEC-PROC",
            key: "paidtotypebccid",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_PAIDTO_FILTER")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "BAYASYSTEM_CONSTANTS",
            key: "analysisCodeObj",
            params: [
              {
                "column": "constantcode",
                "value": "DEFAULT_ANALYSIS_CODE",
                "datatype": "STR",
                "restriction": "EQU"
              },
              {
                "column": "constantgroup",
                "value": "ACCOUNTS",
                "datatype": "STR",
                "restriction": "EQU"
              },
              {
                "column": "companyid",
                "value": companyId,
                "datatype": "STR",
                "restriction": "EQU"
              }
            ])
        .addParams(
            list: "BAYASYSTEM_CONSTANTS",
            key: "analysisCodeTypeObj",
            params: [
              {
                "column": "constantcode",
                "value": "DEFAULT_ANALYSISCODE_TYPE",
                "datatype": "STR",
                "restriction": "EQU"
              },
              {
                "column": "constantgroup",
                "value": "ACCOUNTS",
                "datatype": "STR",
                "restriction": "EQU"
              },
              {
                "column": "companyid",
                "value": companyId,
                "datatype": "STR",
                "restriction": "EQU"
              }
            ])
        .addParams(
            actionFlag: "LIST",
            key: "paidToTypeObj",
            list: "EXEC-PROC",
            procName: "analysiscodelistproc",
            subActionFlag: "ANALYSISCODETYPE",
            xmlStr: "")
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "paymentFlowTypes",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_FLOW_TYPES")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        // .addParams(
        //     list: "BAYACONTROLCODES-DROPDOWN",
        //     key: "paidTo",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_PAIDTO_FILTER")
        //         .addElement(key: "CompanyId ", value: "$companyId")
        //         .buildElement(),
        //     procName: "bayacontrolcodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "")
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
            key: "voucherTypesrender",
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
            key: "instrumnetTypes",
            xmlStr: "",
            procName: "InstrumentMstProc",
            actionFlag: "DROPDOWN",
            subActionFlag: "")
        // .addParams(
        //     list: "EXEC-PROC",
        //     key: "vchCodeList",
        //     xmlStr: XMLBuilder(tag: "DropDown ")
        //             .addElement(key: "CompanyId ", value: "$companyId")
        //             .addElement(key: "BranchId", value: "$branchId")
        //             .addElement(key: "VchCodeFlag  ", value: "VCH_CODE_TYPE")
        //             .buildElement() +
        //         XMLBuilder(tag: "DropDn  ")
        //             .addElement(key: "VchCodeCode ", value: "CASH")
        //             .buildElement() +
        //         XMLBuilder(tag: "DropDn ")
        //             .addElement(key: "VchCodeCode  ", value: "BANK")
        //             .buildElement() +
        //         XMLBuilder(tag: "DropDn ")
        //             .addElement(key: "VchCodeCode  ", value: "JOURNAL")
        //             .buildElement(),
        //     procName: "VoucherCodeListProc",
        //     actionFlag: "DROPDOWN",
        //     subActionFlag: "VCHTYPE_BASED_VCHCODE")
        // .addParams(
        //     list: "BAYASYSTEMCONTANTS",
        //     key: "ChequeleafpathObj",
        //     params: [
        //       {
        //         "column": "constantcode",
        //         "value": "CHEQUE_TEMPLATE_PATH",
        //         "datatype": "STR",
        //         "restriction": "EQU"
        //       },
        //       {
        //         "column": "constantgroup",
        //         "value": "ACCOUNTS",
        //         "datatype": "STR",
        //         "restriction": "EQU"
        //       },
        //       {
        //         "column": "companyid",
        //         "value": companyId,
        //         "datatype": "INT",
        //         "restriction": "EQU"
        //       }
        //     ])
        .addParams(list: "BAYASYSTEM_CONSTANTS", key: "editableYnObj", params: [
          {
            "column": "constantcode",
            "value": "PAYMENTENTRY_EDIT_YN",
            "datatype": "STR",
            "restriction": "EQU"
          },
          {
            "column": "constantgroup",
            "value": "ACCOUNTS",
            "datatype": "STR",
            "restriction": "EQU"
          },
        ])
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "paymentEntryProcessFromObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_ENTRY_INPUT_LIST")
                .addElement(key: "CompanyId ", value: "$companyId")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        // .addParams(
        //     list: "CURRENCY_DROPDOWN",
        //     key: "currencyList",
        //     xmlStr: XMLBuilder(tag: "List").buildElement(),
        //     procName: "CurrencyListProc",
        //     actionFlag: "LIST",
        //     subActionFlag: "CURRENCY")
        // .addParams(
        //     list: "CURRENCY_DROPDOWN",
        //     key: "currencyExchRateList",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_ENTRY_INPUT_LIST")
        //         .addElement(key: "CompanyId ", value: "$companyId")
        //         .addElement(key: "CurrencyId ", value: "1")
        //         .addElement(
        //             key: "Date ",
        //             value: "${BaseDates(DateTime.now()).dbformat}")
        //         .buildElement(),
        //     procName: "CurrencyListProc",
        //     actionFlag: "LIST",
        //     subActionFlag: "EXCHRATE")
        // .addParams(
        //     list: "BAYASYSTEMCONTANTS",
        //     key: "analysisCodeTypeObj",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_REQ_TRANS_TYPE")
        //         .addElement(key: "CompanyId ", value: "$companyId")
        //         .buildElement(),
        //     procName: "bayacontrolcodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "")
        // .addParams(
        //     list: "EXEC-PROC",
        //     key: "paidToTypeObj",
        //     xmlStr: "",
        //     procName: "analysiscodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "ANALYSISCODETYPE")
        // .addParams(
        //     list: "BAYACONTROLCODES-DROPDOWN",
        //     key: "paymentSearchTypes",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_TYPE")
        //         .addElement(key: "CompanyId ", value: "$companyId")
        //         .buildElement(),
        //     procName: "bayacontrolcodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "")
        // .addParams(
        //     list: "BAYASYSTEMCONTANTS",
        //     key: "analysisCodeTypeObj",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_REQ_TRANS_TYPE")
        //         .addElement(key: "CompanyId ", value: "$companyId")
        //         .buildElement(),
        //     procName: "bayacontrolcodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "")
        // .addParams(
        //     list: "EXEC-PROC",
        //     key: "reqFromObj",
        //     xmlStr: "",
        //     procName: "analysiscodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "ANALYSISCODETYPE")
        // .addParams(
        //     list: "BAYACONTROLCODES-DROPDOWN",
        //     key: "reqTransTypeObj",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_REQ_TRANS_TYPE")
        //         .addElement(key: "CodeName", value: "Code")
        //         .buildElement(),
        //     procName: "bayacontrolcodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "")
        // .addParams(
        //     list: "BAYACONTROLCODES-DROPDOWN",
        //     key: "transTypeAllObj",
        //     xmlStr: XMLBuilder(tag: "List")
        //         .addElement(key: "TableCode", value: "PAYMENT_REQ_PROCESS_TYPE")
        //         .addElement(key: "CodeName", value: "Code")
        //         .buildElement(),
        //     procName: "bayacontrolcodelistproc",
        //     actionFlag: "LIST",
        //     subActionFlag: "")
        // .addParams(
        //   actionFlag: "LIST",
        //   key: "taxConfigObj",
        //   list: "EXEC-PROC",
        //   procName: "TaxLedgerConfigurationListProc",
        //   subActionFlag: "TAX_LEDGER",
        //   xmlStr: XMLBuilder(tag: "List")
        //       .addElement(
        //           key: "WefDate", value: BaseDates(DateTime.now()).dbformat)
        //       .addElement(key: "OptionId", value: "429")
        //       .addElement(key: "Flag", value: "JSON")
        //       .buildElement(),
        // )
        // .addParams(list: "BAYACONTROLCODES-DROPDOWN", key: "reqTypeObj", xmlStr: XMLBuilder(tag: "List").addElement(key: "TableCode ", value: "PAYMENT_REQ_TYPE").addElement(key: "CodeName ", value: "Code").buildElement(), procName: "bayacontrolcodelistproc", actionFlag: "LIST", subActionFlag: "")

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
                    analysisCodeObj: responseJson.analysisCodeObj,
                    analysisCodeTypeObj: responseJson.analysisCodeTypeObj,
                    paidToTypes: responseJson.paidToTypes,
                    paymentFlowTypes: responseJson.paymentFlowTypes,
                    voucherTypes: responseJson.voucherTypes,
                    voucherTypesRender: responseJson.voucherTypesRender,
                    instrumentTypes: responseJson.instrumentTypes,
                    editableYnObj: responseJson.editableYnObj,
                    paymentEntryProcessFromObj:
                        responseJson.paymentEntryProcessFromObj,
                    paymentTypes: responseJson.paymentTypes,
                    paidToTypeBccId: responseJson.paidToTypeBccId,
                    settlementTypes: responseJson.settlementTypes)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getService(
      {@required Function(List<ServiceList> serviceList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "servicemstlistproc",
          actionFlag: "LIST",
          subActionFlag: "OPTION_SERVICELIST",
          xmlStr: "",
          key: "serviceObject",
        )
        .callReq();

    String url = "/gl/controller/cmn/getdropdownlist";

    ServiceModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ServiceModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.serviceList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getCashierBalance(
      {@required
          accountId,
      @required
          analysisCodeId,
      @required
          analysisCodeTypeId,
      @required
          Function(List<CashierBalance> cashierBalanceList) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "AsOnDate", value: BaseDates(DateTime.now()).dbformat)
        .addElement(key: "CompanyId", value: "$companyId")
        .addElement(key: "IsAllBranchYN", value: "N")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "FinyearId", value: "$finyearId")
        .addElement(key: "AnalysisCodeId", value: "$analysisCodeId")
        .addElement(key: "AnalysisCodeTypeId", value: "$analysisCodeTypeId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "GetAccountBalanceProc",
          actionFlag: "LIST",
          subActionFlag: "DEF_CURR_ANAL_CODE_ACC_BAL",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/ap/controller/cmn/getdropdownlist";

    CashierBalanceModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = CashierBalanceModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.cashierBalanceList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getAccountBalance(
      {@required accountId,
      @required Function(List<AccountBalance> acctBalanceList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "AsOnDate", value: BaseDates(DateTime.now()).dbformat)
        .addElement(key: "CompanyId", value: "$companyId")
        .addElement(key: "IsAllBranchYN", value: "Y")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "FinyearId", value: "$finyearId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "GetAccountBalanceProc",
          actionFlag: "LIST",
          subActionFlag: "DEF_CURR_ACC_BAL",
          xmlStr: xml,
          key: "accountBalance",
        )
        .callReq();

    String url = "/gl/controller/cmn/getdropdownlist";

    AccountBalanceModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = AccountBalanceModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.accountBalanceList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getCashAccountBalance(
      {@required accountId,
      @required Function(List<AccountBalance> acctBalanceList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "AccountId", value: "$accountId")
        .addElement(key: "AsOnDate", value: BaseDates(DateTime.now()).dbformat)
        .addElement(key: "CompanyId", value: "$companyId")
        .addElement(key: "IsAllBranchYN", value: "N")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "FinyearId", value: "$finyearId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "GetAccountBalanceProc",
          actionFlag: "LIST",
          subActionFlag: "DEF_CURR_ACC_BAL",
          xmlStr: xml,
          key: "accountBalance",
        )
        .callReq();

    String url = "/gl/controller/cmn/getdropdownlist";

    AccountBalanceModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = AccountBalanceModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.accountBalanceList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getVoucherPurchaseList(
      {@required
          PVFilterModel filterRange,
      String transNo,
      int start = 0,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      @required
          Function(List<VoucherPurchaseOder> voucherPurchaseOderList)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(
            key: "DateFrom",
            value: "${BaseDates(filterRange.fromDate).dbformat}")
        .addElement(
            key: "DateTo", value: "${BaseDates(filterRange.toDate).dbformat}")
        .addElement(key: "Start", value: "0")
        .addElement(key: "Limit", value: "10000")
        .addElement(key: "TransNo", value: "%${transNo}%")
        .addElement(key: "FilterFlag", value: "")
        .addElement(key: "Flag", value: "PURCHASE_ORDER_KHAT")
        .addElement(key: "OptionCode ", value: "PURCHASE_ORDER_KHAT")
        .buildElement();

    String dataXml = XMLBuilder(tag: "List")
        .addElement(
            key: "DateFrom",
            value: "${BaseDates(filterRange.fromDate).dbformat}")
        .addElement(
            key: "DateTo", value: "${BaseDates(filterRange.toDate).dbformat}")
        .addElement(key: "Start", value: "0")
        .addElement(key: "Limit", value: "10000")
        .addElement(key: "TransNo", value: "%${transNo}%")
        .addElement(key: "FilterFlag", value: "DOCUMENT")
        .addElement(key: "Flag", value: "PURCHASE_ORDER_KHAT")
        .addElement(key: "OptionCode ", value: "PURCHASE_ORDER_KHAT")
        .buildElement();

    var ddpObjects = {
      "flag": "ALL",
      "start": 0,
      "limit": "15",
      "value": value,
      "SOR_Id": 0,
      "EOR_Id": 0,
      "TotalRecords": 0,
      "params": [],
      "dropDownParams": [
        {
          "list": "EXEC-PROCWITHPAGING",
          "procName": "PaymentEntryListProc",
          "actionFlag": "LIST",
          "subActionFlag": "PROCESS_FROM_LIST",
          if (transNo.isEmpty) "xmlStr": xml,
          if (transNo != null && transNo.isNotEmpty) "xmlStr": dataXml,
          "key": "resultObject",
        }
      ]
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROCWITHPAGING",
          procName: "PaymentEntryListProc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    VoucherPurchaseOderModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = VoucherPurchaseOderModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.voucherPurchaseOrderList)
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
    // int supplierId = filterData.supplier.id;
    // String transNo = filterData?.transNo ?? "";
    DateTimeRange rangeData = filterData?.dateRange;
    String service = "getdata";

    List jssArr = [
      {
        "flag": "ALL",
        "SOR_Id": 973,
        "EOR_Id": 973,
        "TotalRecords": 1,
        "start": 0,
        "limit": "10",
        "value": 0,
        "params": [
          {
            "column": "DateFrom",
            "value": "${BaseDates(rangeData?.start).dbformat}"
          },
          {
            "column": "DateTo",
            "value": "${BaseDates(rangeData?.end).dbformat}"
          },
          {"column": "OptionFlag", "value": "GRN_KHAT"}
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
    DateTimeRange rangeData = filterData?.dateRange;

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

  getProcessPOFillList(
      {int id,
      @required
          Function(List<PurchaseOrderProcessFill> purchaseOderProcessFillList)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    int finyearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: "$id")
        .addElement(
            key: "OperationalDate",
            value: "${BaseDates(DateTime.now()).dbformat}")
        .addElement(key: "DepartmentId", value: "${departmentId}")
        .addElement(key: "FinyearId", value: "$finyearId")
        .addElement(key: "Flag", value: "PURCHASE_ORDER_KHAT")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xml,
            procName: "PaymentEntryListProc",
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
          PurchaseOderProcessFillModel responseJson =
              PurchaseOderProcessFillModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.purchaseOderProcessFillList);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getBudget(
      {@required int optionId,
      @required int accountId,
      @required Function(List<BudgetDtlModel> budgetlist) onRequestSuccess,
      @required Function(AppException) onRequestFailure}) async {
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlList = XMLBuilder(tag: "List")
        .addElement(key: "Date", value: "${BaseDates(DateTime.now()).dbformat}")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();

    String xmlItem = XMLBuilder(tag: "Item")
        .addElement(key: "DepartmentId", value: "$departmentId")
        .addElement(key: "BranchId", value: "$branchId")
        .addElement(key: "AccountId", value: "$accountId")
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

  void saveVoucher(
      {List<CurrencyExchange> currencyEx,
      List<PurchaseOrderProcessFill> poList,
      List<BCCModel> voucherTypes,
      List<GradeModel> gradeModel,
      List<BSCModel> analysisCodeType,
      List<BSCModel> analysisCode,
      List<ItemDetailModel> itemDtl,
      List<BCCModel> paymentFlowTypes,
      List<BCCModel> paymentTypes,
      List<BCCModel> requesters,
      List<BCCModel> paidToTypeBccId,
      String paymentMode,
      int optionId,
      List<PaymentVoucherDtlModel> acctDetails,
      PaymentVoucherHdrModel paymentVchModel,
      @required Function() onRequestSuccess,
      //int id, int voucherId, String voucherNo
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
    var analysiscodeid;
    analysisCode.forEach((element) {
      print("analysiscodeid ${element.constantValue}");
      analysiscodeid = element.constantValue;
      return analysiscodeid;
    });
    var analysiscodtypeid;
    analysisCodeType.forEach((element) {
      print("analysiscodtypeid ${element.constantValue}");
      analysiscodtypeid = element.constantValue;
      return analysiscodtypeid;
    });
    var paymentTypeBccid;
    paymentTypes.forEach((element) {
      if (element.description == "Purchase Order Khat") {
        return paymentTypeBccid = element.id;
      }
      print("paymentTypeBccid${paymentTypeBccid}");
      return paymentTypeBccid;
    });

    var paymentFlowTypeId;
    paymentFlowTypes.forEach((element) {
      if (element.code == "PF") {
        print("paymentFlowTypeId ${element.id}");
        paymentFlowTypeId = element.id;
      }

      return paymentFlowTypeId;
    });

    var paidtotypebccid;
    paidToTypeBccId.forEach((element) {
      if (element.code == "ACCOUNT") {
        print("paidtotypebccid ${element.id}");
        paidtotypebccid = element.id;
      }

      return paidtotypebccid;
    });
    var serviceTypeId;
    requesters.forEach((element) {
      if (element.code == "CASHIER") {
        return serviceTypeId = element.id;
      }
      return serviceTypeId;
    });

    var screenSpecField;
    String getScreenSpecField(String mode) {
      if (mode == 'cash') {
        return screenSpecField = "CPV-";
      } else if (mode == 'bank') {
        return screenSpecField = "BPV-";
      }
      return screenSpecField;
    }

    var paidFromAnalysisCodeId;
    int getPaidFromAnalysisCodeId(String mode) {
      if (mode == 'cash') {
        return paidFromAnalysisCodeId = paymentVchModel.requestFromName.id;
      } else if (mode == 'bank') {
        return paidFromAnalysisCodeId = analysiscodeid;
      }
      return paidFromAnalysisCodeId;
    }

    var paidFromAnalysisCodeTypeId;
    int getPaidFromAnalysisCodeTypeId(String mode) {
      if (mode == 'cash') {
        return paidFromAnalysisCodeTypeId = serviceTypeId;
      } else if (mode == 'bank') {
        return paidFromAnalysisCodeTypeId = analysiscodtypeid;
      }
      return paidFromAnalysisCodeTypeId;
    }

    var bookAnalysisCodeId;
    int getBookFromAnalysisCodeId(String mode) {
      if (mode == 'cash') {
        return bookAnalysisCodeId = paymentVchModel.requestFromName.id;
      } else if (mode == 'bank') {
        return bookAnalysisCodeId = analysiscodeid;
      }
      return bookAnalysisCodeId;
    }

    var bookAnalysisCodeTypeId;
    int getBookAnalysisCodeTypeId(String mode) {
      if (mode == 'cash') {
        return bookAnalysisCodeTypeId = serviceTypeId;
      } else if (mode == 'bank') {
        return bookAnalysisCodeTypeId = analysiscodtypeid;
      }
      return bookAnalysisCodeTypeId;
    }

    var instrumentModeType;
    String getInstrumentType(String mode) {
      if (mode == 'cash') {
        return instrumentModeType = paymentVchModel.instrumentTypes.name;
      } else if (mode == 'bank') {
        return instrumentModeType = paymentVchModel.instrumentBankTypes.name;
      }
      return instrumentModeType;
    }

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
    var exchangeRate = double.parse(exRate?.toStringAsFixed(2));
    print(exchangeRate);
    var totalAmount = acctDetails.fold(
        0, (previousValue, element) => previousValue + element.amount);
    print(totalAmount);

    String amount;
    var voucherDtl = poList.map((vdtl) {
      return {
        "amount": totalAmount,
        "analysiscodeid": vdtl.analysiscodeid,
        "analysiscodetypeid": vdtl.analysiscodetypeid,
        "bookanalysiscodeid": getBookFromAnalysisCodeId(paymentMode),
        "bookanalysiscodetypeid": getBookAnalysisCodeTypeId(paymentMode),
        "crordr": "D",
        "exchangerate": exRate,
        "foreigncurrencyid": fcCurrencyId,
        "localcurrencyamount": totalAmount,
        "localcurrencyid": lcCurrencyId,
        "narration":
            "${paymentVchModel.remarks}; Instrument Name :${getInstrumentType(paymentMode)};Instrumnet No. :${paymentVchModel.instNo != null ? paymentVchModel.instNo : " "}; Instrument Date : ${BaseDates(paymentVchModel.insDate).dbformatWithTime};",
        "value": vdtl.dtljson.accountid,
        "vchdtlid": 0,
      };
    }).toList();
    var paymentinstDtl = [];
    paymentinstDtl.add({
      "Id": 0,
      "amount": totalAmount,
      if (paymentMode == 'cash' && paymentVchModel.voucherTypes != null)
        "bankaccountid": paymentVchModel.voucherTypes.bankaccountid ?? 0,
      if (paymentMode == 'bank' && paymentVchModel.voucherBankTypes != null)
        "bankaccountid": paymentVchModel.voucherBankTypes.bankaccountid ?? 0,
      "convertedamount": totalAmount,
      "exchangerate": exRate,
      if (paymentMode == 'cash' && paymentVchModel.instrumentTypes != null)
        "instrumentid": paymentVchModel.instrumentTypes.id,

      if (paymentMode == 'bank' && paymentVchModel.instrumentBankTypes != null)
        "instrumentid": paymentVchModel.instrumentBankTypes.id,
      // "instrumentid": paymentVchModel.instrumentTypes.id,
      "instrumentrefdate": BaseDates(paymentVchModel.insDate).dbformatWithTime,
      if (paymentVchModel.instNo != null)
        "instrumentrefno": paymentVchModel.instNo,
      "instrumentremarks": paymentVchModel?.remarks ?? "",
      "optionid": optionId,
      "originalcurrencyid": fcCurrencyId,
      if (paymentMode == 'cash' && paymentVchModel.voucherTypes != null)
        "vouchercodeid": paymentVchModel.voucherTypes.vouchercodeid,
      if (paymentMode == 'bank' && paymentVchModel.voucherBankTypes != null)
        "vouchercodeid": paymentVchModel.voucherBankTypes.vouchercodeid,
      "voucherid": 0
    });

    var dtlanalysiscodeid;
    var dtlanalysiscodetypeid;
    var paidto;
    var data;
    var budgetDtl = poList.map((budget) {
      data = budget;
      print(budget.dtljson.budgetdtljson.budgeted);
      print(budget.dtljson.budgetdtljson.inprocess);
      print(budget.dtljson.budgetdtljson.remaining);
      print(data.dtljson.budgetdtljson.budgeted);
      print(data.dtljson.budgetdtljson.inprocess);
      print(data.dtljson.budgetdtljson.remaining);
      dtlanalysiscodeid = budget.analysiscodeid;
      dtlanalysiscodetypeid = budget.analysiscodetypeid;
      paidto = budget.paidto;

      return {
        "Id": 0,
        "accountid": budget.dtljson.budgetdtljson.accountid,
        "actualamount": budget.dtljson.budgetdtljson.actual,
        "amount": budget.dtljson.amount,
        "branchid": budget.dtljson.budgetdtljson.branchid,
        "budgetdate": budget.dtljson.budgetdtljson.budgetdate ??
            BaseDates(DateTime.now()).dbformat,
        "budgetedamount": budget.dtljson.budgetdtljson.budgeted,
        "departmentid": budget.dtljson.budgetdtljson.departmentid,
        "inprogressamount": budget.dtljson.budgetdtljson.inprocess,
        "optionid": optionId,
        "remainingamount": budget.dtljson.budgetdtljson.remaining,
      };
    }).toList();
    print(budgetDtl);
    int grnhdrId;
    var sourceDtl = poList.map((source) {
      grnhdrId = source.grnvoucherhdrid;
      print(grnhdrId);
      return {
        "Id": 0,
        "Optionid": optionId,
        "refdataid": source.dtlid,
        "refhdrtabledataid": source.dtljson.id,
        "refhdrtableid": source.dtltableid,
        "reftableid": source.dtljson.tableid,
      };
    }).toList();

    var jsonDtl = acctDetails.map((e) {
      return {
        "Id": 0,
        "amount": e.amount,
        "budgetDtl": [
          {
            "Id": 0,
            "accountid": e.serviceList?.accountid,
            "actualamount": e.budgetList?.actual ?? 0.0,
            "amount": e.amount,
            "branchid": branchId,
            "budgetdate":
                e.budgetList?.budgetdate ?? BaseDates(DateTime.now()).dbformat,
            "budgetedamount": e.budgetList?.budgeted ?? 0.0,
            "departmentid": data.dtljson.budgetdtljson.departmentid,
            "inprogressamount": e.budgetList?.inprocess ?? 0.0,
            "optionid": optionId,
            "remainingamount": e.budgetList?.remaining ?? 0.0,
          }
        ],
        "taxDtlList": [],
        "convertedamount": e.amount,
        "exchangerate": exRate,
        "optionid": optionId,
        "originalcurrencyid": fcCurrencyId,
        "paidtoaccountid": e.serviceList.accountid,
        "refdate": "",
        "refno": "",
        "serviceid": e.serviceList.serviceid,
        "sourcemapingDtlDto": sourceDtl,
      };
    }).toList();
    print(grnhdrId);

    jsonArr = {
      "Id": 0,
      "optionid": optionId,
      //"branchid": branchId,
      "amendmentno": 0,
      "amendedfromoptionid": optionId,
      "amendmentdate": date,
      "processfromflag": "PURCHASE_ORDER_KHAT",
      "paymentdate": date,
      "paymenttypebccid": paymentTypeBccid,
      "currencyid": fcCurrencyId,
      "recordstatus": "A",
      "dtlDto": jsonDtl,
      "chequeto": paidto,
      "paymentflowtypebccid": paymentFlowTypeId,
      if (paymentMode == 'cash' && paymentVchModel.voucherTypes != null)
        "payfromtotabledataid": paymentVchModel.voucherTypes.bookaccountid ?? 0,
      if (paymentMode == 'bank' && paymentVchModel.voucherBankTypes != null)
        "payfromtotabledataid":
            paymentVchModel.voucherBankTypes.bookaccountid ?? 0,
      "payfromtotypebccid": paidtotypebccid,
      "grnvoucherhdrid": grnhdrId ?? 0,
      "isblockedyn": "N",
      "supplieryn": "Y",
      "analysiscodetypeid": dtlanalysiscodetypeid,
      "analysiscodeid": dtlanalysiscodeid,
      "paidfromanalysiscodetypeid": getPaidFromAnalysisCodeTypeId(paymentMode),
      "paidfromanalysiscodeid": getPaidFromAnalysisCodeId(paymentMode),
      if (paymentMode == 'cash' && paymentVchModel.voucherTypes != null)
        "context": paymentVchModel.voucherTypes.typebcccode,
      if (paymentMode == 'bank' && paymentVchModel.voucherBankTypes != null)
        "context": paymentVchModel.voucherBankTypes.typebcccode,
      "remarks": paymentVchModel.remarks,
      "screenSpecField": getScreenSpecField(paymentMode),
      "settlebefore": (BaseDates(paymentVchModel.tillDate).date).toString(),
      "settlementtypebccid": paymentVchModel.settlementTypes.id,
      "supplieryn": "Y",
      "paymentInstdtlDto": paymentinstDtl,
      "voucherList": voucherDtl,
    };

    String service = "putdata";
    String url = "/ap/controller/trn/paymententrysave";
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
        chkflag: "N",
        uuid: 0,
        userid: 0,
        compressdyn: false,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BaseResponseModel.fromJson(result),
              if (responseJson.statusCode == 1 &&
                  responseJson.statusMessage == "Success")
                {
                  responseJson.voucherno.isNotEmpty
                      ? responseJson.voucherno
                      : "",
                  print(responseJson.voucherno),
                  r = responseJson.voucherno,
                  onRequestSuccess()
                }
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
