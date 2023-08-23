import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_analysis_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_branch_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_item_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_salesman_model.dart';

class SalesInsightRepository extends BaseRepository {
  getBranchSummaryReport(
      {@required DateTime fromDate,
      @required DateTime toDate,
      bool margin = true,
      bool showMajorCategory = true,
      @required Function(RevenueAnalysisModel analysisList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    String xml = new XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(
            key: "ShowMajorCategoryOrBrandYN",
            value: (showMajorCategory ? "Y" : "N"))
        .addElement(key: "ShowMarginYN", value: (margin ? "Y" : "N"))
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultBranchList",
            xmlStr: xml,
            procName: "RevenueListProc",
            actionFlag: "LIST",
            subActionFlag: "BRANCH_WISE")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    RevenueAnalysisModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = RevenueAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getCategorySummaryReport(
      {@required DateTime fromDate,
      @required DateTime toDate,
      bool margin = true,
      bool showMajorCategory = true,
      @required Function(RevenueAnalysisModel analysisList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";
    String xml = new XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(
            key: "ShowMajorCategoryOrBrandYN",
            value: (showMajorCategory ? "Y" : "N"))
        .addElement(key: "ShowMarginYN", value: (margin ? "Y" : "N"))
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultCategoryList",
            xmlStr: xml,
            procName: "RevenueListProc",
            actionFlag: "LIST",
            subActionFlag: "CATEGORY_WISE")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    RevenueAnalysisModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = RevenueAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getBrandSummaryReport(
      {@required DateTime fromDate,
      @required DateTime toDate,
      bool margin = true,
      bool showMajorCategory = true,
      @required Function(RevenueAnalysisModel analysisList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";
    String xml = new XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(
            key: "ShowMajorCategoryOrBrandYN",
            value: (showMajorCategory ? "Y" : "N"))
        .addElement(key: "ShowMarginYN", value: (margin ? "Y" : "N"))
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultBrandList",
            xmlStr: xml,
            procName: "RevenueListProc",
            actionFlag: "LIST",
            subActionFlag: "BRAND_WISE")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    RevenueAnalysisModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = RevenueAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getRevenueAnalysisBranchList(
      {@required DateTime fromDate,
      @required DateTime toDate,
      bool margin = false,
      @required Function(List<RevenueBranchItem>) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    String service = "getdata";

    int userId = await BasePrefs.getInt(USERID_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(key: "ShowMarginYN", value: (margin ? "Y" : "N"))
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "RevenueListProc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Post body =
        Post(ssnidn: ssnId, jsonArr: jssArr, service: service, url: url);

    RevenueBranchModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = RevenueBranchModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.revenueBranchList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getRevenueAnalysisSalesmanList(
      {@required
          DateTime fromDate,
      @required
          DateTime toDate,
      @required
          Function(List<RevenueSalesmanItem> salesmanList) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "RevenueListProc",
          actionFlag: "LIST",
          subActionFlag: "SALESMAN",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    RevenueSalesmanModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = RevenueSalesmanModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.revenueSalesmanList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getRevenueAnalysisItemList(
      {DateTime fromDate,
      DateTime toDate,
      @required
          Function(List<RevenueItemList> revenueItemList) onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "Flag", value: "TOP10")
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "RevenueListProc",
          actionFlag: "LIST",
          subActionFlag: "ITEMWISE",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    RevenueItemModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = RevenueItemModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.revenueItemList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
