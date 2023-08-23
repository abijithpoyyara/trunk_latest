import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/sales_insight/customer_analysis.dart';

class CustomerAnalysisRepository extends BaseRepository {
  getCustomerEngagement(
      {DateTime fromDate,
      DateTime toDate,
      @required
          Function(CustomerEngagementModel engagementModel) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "CustomerAnalysysProc",
          actionFlag: "LIST",
          subActionFlag: "CUSTOMER",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    CustomerEngagementModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = CustomerEngagementModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getCustomerBranchAnalysisList(
      {DateTime fromDate,
      DateTime toDate,
      @required Function(List<CustomerBranchList> branchList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "CustomerAnalysysProc",
          actionFlag: "LIST",
          subActionFlag: "CUSTOMER_BRANCH",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    CustomerBranchAnalysisModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = CustomerBranchAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.customerBranchList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getMarginAnalysisList(
      {DateTime fromDate,
      DateTime toDate,
      @required Function(List<CustomerMarginList> branchList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "CustomerAnalysysProc",
          actionFlag: "LIST",
          subActionFlag: "MARGIN_ANALYSYS",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Post body =
        Post(ssnidn: ssnId, jsonArr: jssArr, service: service, url: url);

    CustomerMarginAnalysisModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = CustomerMarginAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.customerMarginList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
