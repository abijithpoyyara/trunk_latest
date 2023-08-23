import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';

class SEMisRepository extends BaseRepository {
  static final SEMisRepository _instance = SEMisRepository._();

  SEMisRepository._();

  factory SEMisRepository() => _instance;

  Future<void> getInitialConfigs(
      {@required
          Function({
        List<FinYearModel> finYears,
        List<BCCModel> reportType,
        List<BranchModel> branches,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await getCompanyId();
    int userId = await getUserId();
    String branchXml = XMLBuilder(tag: "List")
        .addElement(key: "OptionBusinessLevelCode", value: "FA")
        .addElement(key: "ParentBusinessLevelCode", value: "L2")
        .addElement(key: "UserId", value: '$userId')
        .buildElement();
    List jssArr = DropDownParams()
        .addDDP(await createBCCRequestParams(
          key: "reportType",
          tableCode: "SALES_ENQ_REPORT_TYPE",
          addCompany: true,
        ))
        .addParams(list: "FINYEAR", key: "finYearObj", params: [
          {
            "column": "companyid",
            "value": companyId,
            "datatype": "INT",
            "restriction": "EQU"
          }
        ])
        .addDDP(createBranchRequestParams(
          key: "branchObj",
          xml: branchXml,
        ))
        .callReq();

    String url = "/sales/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          var responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            print("finYearObj : ${result["finYearObj"]}");
            onRequestSuccess(
                finYears: BaseJsonParser.goodList(result, "finYearObj")
                    .map((e) => FinYearModel.fromJson(e))
                    .toList(),
                reportType: getBCCList(result, "reportType"),
                branches: getBranchesList(result, "branchObj"));
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> getFinYearMonths(
      {@required Function(List<CalendarModel>) onRequestSuccess,
      @required Function(AppException) onRequestFailure,
      @required int finYearId}) async {
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "FinYearId", value: '$finYearId')
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            procName: "calendarlistproc",
            actionFlag: "LIST",
            subActionFlag: "",
            key: "resultObject",
            xmlStr: xml)
        .callReq();

    String url = "/sales/controller/cmn/getdropdownlist";
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BaseResponseModel responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(BaseJsonParser.goodList(result, "resultObject")
                .map((e) => CalendarModel.fromJson(e))
                .toList());
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> getReportSummary({
    @required Function(List<SalesEnquiryMisModel>) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
    DateTime fromDate,
    DateTime toDate,
    bool allBranch,
    int reportTypeBccId,
    bool onDate,
    BranchModel branch,
  }) async {
    int companyId = await getCompanyId();
    String periodXml = XMLBuilder(tag: "Report")
        .addElement(key: "AllBranchYN", value: allBranch ? 'Y' : 'N')
        .addElement(key: "ReportTypeBccId", value: '$reportTypeBccId')
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .buildElement();

    String asOnDateXml = XMLBuilder(tag: "Report")
        .addElement(key: "AllBranchYN", value: allBranch ? 'Y' : 'N')
        .addElement(key: "ReportTypeBccId", value: '$reportTypeBccId')
        .addElement(key: "AsonDate", value: BaseDates(toDate).dbformat)
        .buildElement();
    String branchXml = "";

    if (!allBranch && branch != null) {
      branchXml = XMLBuilder(tag: 'InputLoginParamDtl')
          .addElement(key: "LevelId", value: "${branch.businessLevelCodeId}")
          .addElement(key: "LevelCode", value: "${branch.levelCode}")
          .addElement(key: "LevelValue", value: "${branch.id}")
          .buildElement(appendFlag: false);
      branchXml = XMLBuilder(tag: 'InputLoginParamDtl')
          .addElement(key: "LevelId", value: '1')
          .addElement(key: "LevelCode", value: "L1")
          .addElement(key: "LevelValue", value: "$companyId")
          .buildElement(appendFlag: false);
    }
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            procName: "RptSalesEnquiryMISProc",
            actionFlag: "REPORT",
            subActionFlag: "",
            xmlStr: (onDate ? asOnDateXml : periodXml) + branchXml)
        .callReq();

    String url = "/sales/controller/cmn/getdropdownlist";
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
            final summary = BaseJsonParser.goodList(result, "resultObject")
                .map((e) => SalesEnquiryMisModel.fromJson(e))
                .toList();

            onRequestSuccess(summary);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> getReportDtl({
    @required Function(List<SalesEnquiryDtlModel>) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
    DateTime fromDate,
    DateTime toDate,
    bool allBranch,
    int reportTypeBccId,
    int itemId,
    bool onDate,
    BranchModel branch,
  }) async {
    int companyId = await getCompanyId();

    String periodXml = XMLBuilder(tag: "Report")
        .addElement(key: "AllBranchYN", value: allBranch ? 'Y' : 'N')
        .addElement(key: "ReportTypeBccId", value: '$reportTypeBccId')
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(key: "Flag", value: "ADS_COUNT")
        .addElement(key: "ItemId", value: "$itemId")
        .buildElement();

    String asOnDateXml = XMLBuilder(tag: "Report")
        .addElement(key: "AllBranchYN", value: allBranch ? 'Y' : 'N')
        .addElement(key: "ReportTypeBccId", value: '$reportTypeBccId')
        .addElement(key: "AsonDate", value: BaseDates(toDate).dbformat)
        .addElement(key: "Flag", value: "ADS_COUNT")
        .addElement(key: "ItemId", value: "$itemId")
        .buildElement();
    String branchXml = "";

    if (!allBranch && branch != null) {
      branchXml = XMLBuilder(tag: 'InputLoginParamDtl')
          .addElement(key: "LevelId", value: "${branch.businessLevelCodeId}")
          .addElement(key: "LevelCode", value: "${branch.levelCode}")
          .addElement(key: "LevelValue", value: "${branch.id}")
          .buildElement(appendFlag: false);
      branchXml = XMLBuilder(tag: 'InputLoginParamDtl')
          .addElement(key: "LevelId", value: '1')
          .addElement(key: "LevelCode", value: "L1")
          .addElement(key: "LevelValue", value: "$companyId")
          .buildElement(appendFlag: false);
    }
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "RptSalesEnquiryMISProc",
          actionFlag: "REPORT",
          subActionFlag: "",
          xmlStr: (onDate ? asOnDateXml : periodXml) + branchXml,
        )
        .callReq();

    String url = "/sales/controller/cmn/getdropdownlist";
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
            final dtl = BaseJsonParser.goodList(result, "resultObject")
                .map((e) => SalesEnquiryDtlModel.fromJson(e))
                .toList();

            onRequestSuccess(dtl);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }
}
