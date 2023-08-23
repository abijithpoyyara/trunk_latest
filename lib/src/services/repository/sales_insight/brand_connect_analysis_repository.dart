import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/sales_insight/brand_connect_analysis.dart';

class BrandConnectAnalysisRepository extends BaseRepository {
  getBrandConnectList(
      {@required
          DateTime fromDate,
      @required
          DateTime toDate,
      bool margin = true,
      bool showMajorBrand = true,
      @required
          Function(BrandConnectAnalysisModel brandconnectModel)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DateFrom", value: BaseDates(fromDate).dbformat)
        .addElement(key: "DateTo", value: BaseDates(toDate).dbformat)
        .addElement(
            key: "ShowMajorBrandYN", value: (showMajorBrand ? "Y" : "N"))
        .addElement(key: "ShowMarginYN", value: (margin ? "Y" : "N"))
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "BrandFilterProc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    BrandConnectAnalysisModel responseJson;
    performRequest(
        jsonArr: jssArr,
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = BrandConnectAnalysisModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
