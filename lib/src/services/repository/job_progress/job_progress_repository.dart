import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/job_progress/job_progress_rpt_model.dart';

class JobProgressRepository extends BaseRepository {
  static final JobProgressRepository _instance = JobProgressRepository._();

  JobProgressRepository._();

  factory JobProgressRepository() => _instance;

  Future<void> getInitialConfigs(
      {@required
          Function({
        List<BCCModel> processFlows,
        List<BranchModel> branches,
      })
              onRequestSuccess,
      @required
          Function(AppException) onRequestFailure}) async {
    int companyId = await getCompanyId();
    int userId = await getUserId();

    String processFlowXml = XMLBuilder(tag: "List")
        .addElement(key: "Name", value: "%%")
        .addElement(key: "Code", value: "%%")
        .addElement(key: "Flag", value: 'ALL')
        .addElement(key: "Start", value: '0')
        .addElement(key: "Limit", value: '10')
        .buildElement();

    String branchXml = XMLBuilder(tag: "List")
        .addElement(key: "OptionBusinessLevelCode", value: "FA")
        .addElement(key: "ParentBusinessLevelCode", value: "L2")
        .addElement(key: "UserId", value: '$userId')
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
          key: "processFlowObj",
          list: "EXEC-PROC",
          xmlStr: processFlowXml,
          procName: "ProcessFlowListProc",
          actionFlag: "LIST",
          subActionFlag: "VIEW",
        )
        .addDDP(createBranchRequestParams(key: "branchObj", xml: branchXml))
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          var responseJson = BaseResponseModel.fromJson(result);
          if (responseJson.statusCode == 1) {
            onRequestSuccess(
                processFlows: BaseJsonParser.goodList(result, "processFlowObj")
                    .map((e) => BCCModel.fromJson(e))
                    .toList(),
                branches: getBranchesList(result, "branchObj"));
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  Future<void> getReport({
    @required
        Function(List<JobProgressRptSummaryModel>, List<JobRptModel>)
            onRequestSuccess,
    @required Function(AppException) onRequestFailure,
    DateTime fromDate,
    DateTime toDate,
    bool allBranch = true,
    int processFlowId,
    String filterFlag,
    BranchModel branch,
    int start,
    int end,
    int limit,
  }) async {
    int companyId = await getCompanyId();
    int finYearId = await getFinYearID();

    String xml = XMLBuilder(tag: "Report")
        .addElement(key: "AllBranchYN", value: allBranch ? 'Y' : 'N')
        .addElement(key: "ProcessFlowId", value: '$processFlowId')
        .addElement(key: "BranchId", value: '${branch?.id}')
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(key: "Start", value: '${start ?? 0}')
        .addElement(key: "Limit", value: '${limit ?? 1000000000}')
        // .addElement(key: "End", value: '${end ?? 0}')
        .addElement(key: "FinyearId", value: '$finYearId')
        .addElement(key: "FilterFlag", value: '${filterFlag ?? "SUMMARY"}')
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "rptjobprogressproc",
          actionFlag: "REPORT",
          subActionFlag: "",
          xmlStr: xml,
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
              result.containsKey("resultObject") &&
              (result["resultObject"] as List).isNotEmpty) {
            final resultObject = result["resultObject"][0];
            final details = BaseJsonParser.goodList(resultObject, "dtldata")
                .map((e) => JobRptModel.fromJson(e))
                .toList();

            var summary;
            if (filterFlag == null)
              summary = BaseJsonParser.goodList(resultObject, "summarydata")
                  .map((e) => JobProgressRptSummaryModel.fromJson(e))
                  .toList();

            onRequestSuccess(summary, details);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }

  Future<void> getReportProgress({
    @required Function(List<JobRptModel>) onRequestSuccess,
    @required Function(AppException) onRequestFailure,
    bool allBranch = true,
    int processFlowId,
    BranchModel branch,
    String transNo,
    String transTableId,
  }) async {
    XMLBuilder builder = XMLBuilder(tag: "Report")
        .addElement(key: "AllBranchYN", value: allBranch ? 'Y' : 'N')
        .addElement(key: "ProcessFlowId", value: '$processFlowId');
    if (!allBranch) builder.addElement(key: "BranchId", value: '${branch?.id}');
    if ((transNo?.isNotEmpty ?? false) && (transTableId?.isNotEmpty ?? false)) {
      builder.addElement(key: "TransNo", value: '$transNo');
      builder.addElement(key: "TransTableId", value: '$transTableId');
    }
    String xml = builder.buildElement();
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          key: "resultObject",
          procName: "RptJobProgressProc",
          actionFlag: "REPORT",
          subActionFlag: "",
          xmlStr: xml,
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
              result.containsKey("resultObject") &&
              (result["resultObject"] as List).isNotEmpty) {
            final resultObject = result["resultObject"][0];
            final details = BaseJsonParser.goodList(resultObject, "dtldata")
                .map((e) => JobRptModel.fromJson(e))
                .toList();

            onRequestSuccess(details);
          } else {
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
          }
        });
  }
}
