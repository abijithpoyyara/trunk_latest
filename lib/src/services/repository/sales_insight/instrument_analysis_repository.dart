import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/sales_insight/instrument_analysis_model.dart';

class InstrumentAnalysisRepository extends BaseRepository {
  getInstrumentHeaders(
      {DateTime fromDate,
      DateTime toDate,
      @required Function(List<InstrumentHeader> headers) onRequestSuccess,
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
          subActionFlag: "INSTRUMENT_INDEX",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";


    InstrumentHeaderModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = InstrumentHeaderModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.instrumentHeaders)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getInstrumentAnalysisList(
      {DateTime fromDate,
      DateTime toDate,
      @required
          Function(InstrumentAnalysisModel analysisModel) onRequestSuccess,
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
          subActionFlag: "INSTRUMENT_ANALYSYS",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    InstrumentAnalysisModel responseJson;

    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = InstrumentAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
