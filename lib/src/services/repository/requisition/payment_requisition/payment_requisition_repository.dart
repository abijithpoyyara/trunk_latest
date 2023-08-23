import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_reqst_detail.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_view_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/process_from_fill_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

class PaymentRequisitionRepository extends BaseRepository {
  static final PaymentRequisitionRepository _instance =
      PaymentRequisitionRepository._();

  PaymentRequisitionRepository._();

  factory PaymentRequisitionRepository() => _instance;

  Future<void> getTransactionFillDetails(
      {@required Function(ServiceLookupItem) onRequestSuccess,
      @required Function(AppException) onRequestFailure,
      @required TransTypeLookupItem transaction}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String supplierXml = XMLBuilder(tag: "List")
        .addElement(key: "Start", value: '0')
        .addElement(key: "Limit ", value: '10')
        .addElement(key: "TransId", value: '${transaction.id}')
        .addElement(key: "TransTableId", value: "${transaction.tableid}")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "PaymentRequestListProc",
            actionFlag: "LIST",
            subActionFlag: "REQUESTFROM",
            key: "resultObject",
            xmlStr: supplierXml)
        .callReq();

    String url = "/gl/controller/cmn/getdropdownlist";
    String service = "getdata";
    ProcessFromModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ProcessFromModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.status?.first)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  Future<void> getTransactionListDetails(
      {@required Function(List<ProcessFromDtlList>) onRequestSuccess,
      @required Function(AppException) onRequestFailure,
      @required TransTypeLookupItem transaction}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String itemXml = XMLBuilder(tag: "List")
        .addElement(key: "Id", value: '${transaction.id}')
        .addElement(key: "ReqDate", value: BaseDates(DateTime.now()).dbformat)
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "itemAccounDetailObj",
            procName: "PaymentRequestListProc",
            actionFlag: "LIST",
            subActionFlag: "LPO_FILL",
            xmlStr: itemXml)
        .callReq();

    String url = "/gl/controller/cmn/getdropdownlist";
    String service = "getdata";
    ProcessFromDtlListModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ProcessFromDtlListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.list)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getPaymentItemBudget(
      {@required int optionId,
      @required int acctId,
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
        .addElement(key: "AccountId ", value: "$acctId")
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

  Future<void> getInitialConfigs(
      {@required
          Function({
        List<BSCModel> settleWithin,
        List<BSCModel> analysisCode,
        List<BSCModel> analysisType,
        List<BCCModel> reqFromModel,
        List<BCCModel> reqTransTypeModel,
        List<BCCModel> reqProcessTypeModel,
        List<BCCModel> paymentTypeModel,
        List<TaxConfigModel> taxConfigs,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    List jssArr = DropDownParams()
        .addParams(list: "BAYASYSTEMCONTANTS", key: "analysisCodeObj", params: [
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
        ])
        .addParams(
            list: "BAYASYSTEMCONTANTS",
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
            ])
        .addParams(
            list: "EXEC-PROC",
            key: "reqFromObj",
            xmlStr: "",
            procName: "analysiscodelistproc",
            actionFlag: "LIST",
            subActionFlag: "ANALYSISCODETYPE")
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "reqTransTypeObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_REQ_TRANS_TYPE")
                .addElement(key: "CodeName", value: "Code")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "transTypeAllObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode", value: "PAYMENT_REQ_PROCESS_TYPE")
                .addElement(key: "CodeName", value: "Code")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
          actionFlag: "LIST",
          key: "taxConfigObj",
          list: "EXEC-PROC",
          procName: "TaxLedgerConfigurationListProc",
          subActionFlag: "TAX_LEDGER",
          xmlStr: XMLBuilder(tag: "List")
              .addElement(
                  key: "WefDate", value: BaseDates(DateTime.now()).dbformat)
              .addElement(key: "OptionId", value: "429")
              .addElement(key: "Flag", value: "JSON")
              .buildElement(),
        )
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "reqTypeObj",
            xmlStr: XMLBuilder(tag: "List")
                .addElement(key: "TableCode ", value: "PAYMENT_REQ_TYPE")
                .addElement(key: "CodeName ", value: "Code")
                .buildElement(),
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(list: "BAYASYSTEMCONTANTS", key: "settleWithinObj", params: [
          {
            "column": "constantcode",
            "value": "PAYMENT_REQ_SETTLE_DATE",
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
            "datatype": "INT",
            "restriction": "EQU"
          }
        ])
        .callReq();

    String url = "/purchase/controller/cmn/getdropdownlist";
    String service = "getdata";
    PaymentRequisitionConfigModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PaymentRequisitionConfigModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(
                  settleWithin: responseJson.settleWithin,
                  reqFromModel: responseJson.reqFromModel,
                  reqTransTypeModel: responseJson.reqTransTypeModel
                      .where(
                          (element) => !element.code.contains("AGAINST_BILL"))
                      .toList(),
                  reqProcessTypeModel: responseJson.reqProcessTypeModel,
                  paymentTypeModel: responseJson.paymentTypeModel,
                  taxConfigs: responseJson.taxConfigs,
                  analysisCode: responseJson.analysisCode,
                  analysisType: responseJson.analysisType,
                )
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getPaymentReqstnView(
      {int start,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      int optionId,
      @required PVFilterModel filterModel,
      // @required Function(List<PurchaseViewList> ledgerList) onRequestSuccess,
      @required Function(PaymentListModel ledgerList) onRequestSuccess,
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
      "params": [
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
        if (filterModel.amountFrom != null && filterModel.amountFrom.isNotEmpty)
          {
            "column": "AmountFrom",
            "value": filterModel.amountFrom,
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        if (filterModel.amountTo != null && filterModel.amountTo.isNotEmpty)
          {
            "column": "AmountTo",
            "value": filterModel.amountTo,
            "datatype": "INT",
            "restriction": "EQU",
            "sortorder": null
          },
        if (filterModel.reqNo != null && filterModel.reqNo.isNotEmpty)
          {
            "column": "requestno",
            "value": "%${filterModel.reqNo}%",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": null
          },
        if (filterModel.transactionType != null)
          {
            "column": "TransOptionCode",
            "value": "${filterModel.transactionType.code}",
            "datatype": "STR",
            "restriction": "EQU",
            "sortorder": null
          },
        if (filterModel.transNo != null)
          {
            "column": "TransTypeNo",
            "value": "%${filterModel.transNo}%",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": null
          }
      ]
    };

    print("SORID-----$sor_Id");
    print("EORID-----$eor_Id");
    print("ttal-----$totalRecords");
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/ap/controller/trn/getpaymentreqdetails";

    PaymentListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PaymentListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                // onRequestSuccess(responseJson.purchaseViewList)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  // url: /ap/controller/trn/getpaymentreqdetails
  // jsonArr: [{"flag":"EQU","SOR_Id":2296,"EOR_Id":2451,
  // "TotalRecords":30,"start":0,"limit":"10","value":2295,
  // "colName":"Id","params":[{"column":"OptionId","value":429},
  // {"column":"DateFrom","value":"2021-10-01  00:00:00","datatype":"DTE","restriction":"EQU","sortorder":null},
  // {"column":"DateTo","value":"2021-10-29  00:00:00","datatype":"DTE","restriction":"EQU","sortorder":null}]}]

  getPaymentRequisitionDetailList(
      {@required
          int start,
      int optionId,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      PaymentListview paymentRqstId,
      @required
          PVFilterModel filterModel,
      @required
          Function(List<PaymentDetailViewList> ledgerList) onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    String service = "getdata";

    var ddpObjects = {
      "flag": "EQU",
      "start": start,
      "limit": "10",
      "value": paymentRqstId.Id,
      "SOR_Id": 0,
      "EOR_Id": 0,
      "TotalRecords": 0,
      "Key": 50,
      "params": [
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

    String url = "/ap/controller/trn/getpaymentreqdetails";

    PaymentDetailListModel responseJson;
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PaymentDetailListModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.paymentDetailViewList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  void saveRequisition(
      {PaymentRequisitionHdrModel hdrModel,
      List<PaymentRequisitionDtlModel> requisitionItems,
      int optionId,
      BSCModel defaultAnalysisCode,
      BSCModel defaultAnalysisType,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String attachmentXml}) async {
    int finYearId = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    String date = BaseDates(DateTime.now()).dbformatWithTime;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int userID = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int departmentId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    jsonArr = {
      "Id": 0,
      "optionid": optionId,
      "amendmentno": 0,
      "amendmentdate": date,
      "amendedfromoptionid": optionId,
      "companyid": companyId,
      "branchid": branchId,
      "finyearid": finYearId,
      "requestno": "A",
      "requestdate": BaseDates(hdrModel.transDate).dbformatWithTime,
      "recordstatus": "A",
      "analysiscodeid":
          hdrModel?.requestFromName?.id ?? defaultAnalysisCode.constantValue,
      "analysiscodetypeid":
          hdrModel?.requestFrom?.id ?? defaultAnalysisType.constantValue,
      "requestedamount": hdrModel.requestAmount,
      "remarks": hdrModel?.remarks ?? "",
      "paymenttypebccid": hdrModel.paymentType.id,
      "settlebefore": BaseDates(hdrModel.settleWithin).dbformatWithTime,
      "transtypeoptionid": hdrModel?.transactionType?.extra,
      "transcode": hdrModel?.transactionType?.code,
      "paidto": hdrModel.paidTo,
      "transtypebccid": hdrModel?.transactionType?.id,
      "createduserid": userID,
      "createddate": date,
    };
    var dtlSourceMappingDtoList = [];
    if (hdrModel.transNo != null) {
      dtlSourceMappingDtoList = [
        {
          "Id": 0,
          "optionid": optionId,
          "reftableid": hdrModel.transNo.tableid,
          "reftabledataid": hdrModel.transNo.id,
          "refhdrtableid": hdrModel.transNo.tableid,
          "refhdrtabledataid": hdrModel.transNo.id,
        }
      ];
    }
    jsonArr["dtlDtoList"] = requisitionItems
        .map((dtlList) => {
              "Id": 0,
              "accountid": dtlList.ledger.accountid,
              "amount": dtlList.amount,
              "attributeid": dtlList.ledger.attributeId,
              "attributevaluerefid": dtlList.ledger.attributeValueRefId,
              "dtlSourceMappingDtoList": dtlSourceMappingDtoList,
              "taxDtlList": dtlList.taxes
                      ?.map((taxes) => {
                            "Id": 0,
                            "taxattachmentid": taxes.tax.attachmentid,
                            "taxapplicableamount": taxes.totalAmount,
                            "taxperc": taxes.taxDtl.taxperc,
                            "totaltaxamount": taxes.taxedAmount,
                            "effectonparty": taxes.tax.effectonparty
                          })
                      ?.toList() ??
                  [],
              if (dtlList.budget != null)
                "budgetDtl": [
                  {
                    "Id": 0,
                    "optionid": optionId,
                    "branchid": branchId,
                    "accountid": dtlList.budget?.accountid ?? 0,
                    "departmentid": departmentId,
                    "amount": dtlList.amount,
                    "budgetedamount": dtlList.budget?.budgeted ?? 0,
                    "inprogressamount": dtlList.budget?.inprocess ?? 0,
                    "actualamount": dtlList.budget?.actual ?? 0,
                    "remainingamount": dtlList.budget?.remaining ?? 0,
                    "budgetdate": "2021-09-03"
                  }
                ],
              if (dtlList.budget == null) "budgetDtl": [],
            })
        .toList();

    String service = "putdata";
    String url = "/ap/controller/trn/savepaymentrequest";

    jsonArr["extensionDataObj"] = [];
    jsonArr["screenNoteDataObj"] = [];
    jsonArr["screenFieldDataApprovalInfoObj"] = [];

    jsonArr["SerialNoCol"] = "requestno";
    jsonArr["TransDateCol"] = "requestdate";
    if (hdrModel.transNo != null) {
      jsonArr["transreftabledataid"] = hdrModel.transNo.id;
      jsonArr["transreftableid"] = hdrModel.transNo.tableid;
    }
    jsonArr["checkListDataObj"] = [];

    print(json.encode(jsonArr));

    if (attachmentXml != null) {
      jsonArr["docAttachReqYN"] = true;
      jsonArr["docAttachXml"] = attachmentXml;
    }
    var request = json.encode(jsonArr);

    List jssArr = List();
    jssArr.add(request);
    print(jssArr);
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
