import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/src/services/helpers/http_request_helper.dart';
import 'package:base/src/services/model/request/drop_down_params.dart';
import 'package:base/utility.dart';

/// Repository class that requires network calls can extend this.
class BaseRepository {
  void performRequest(
      {List jsonArr,
        String service,
        String url,
        int userid,
        int uuid,
        bool compressdyn,
        String chkflag,
        Function(Map<String, dynamic> response) onRequestSuccess,
        Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(BaseConstants.SSNIDN_KEY);

    Post body = Post(
        ssnidn: ssnId,
        jsonArr: jsonArr,
        service: service,
        url: url,
        compressedyn: compressdyn,
        userid: userid,
        uuid: uuid,
        chkflag: chkflag);

    // try {
    HttpRequestHelper(
        service: service,
        requestParams: body.toMap(),
        onRequestFailure: onRequestFailure,
        onRequestSuccess: onRequestSuccess)
        .post();
    // } catch (e) {
    //   {
    //     onRequestFailure(FetchDataException());
    //     print(e.toString());
    //   }
    // }
  }

  Future<int> getUserId() async => BasePrefs.getInt(BaseConstants.USERID_KEY);

  Future<int> getCompanyId() async =>
      await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

  Future<int> getFinYearID() async =>
      await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);

  DropDownParamsItems createBranchRequestParams({String key, String xml}) {
    return DropDownParamsItems(
        key: '$key',
        params: null,
        xmlStr: '$xml',
        list: "EXEC-PROC",
        procName: "BusinessSubLevelProc",
        actionFlag: "LIST",
        subActionFlag: "OPT_USER_BUSINESS_LEVEL_FITER");
  }

  DropDownParamsItems createBSCRequestParams(
      {String key, List<Map<String, dynamic>> params}) {
    return DropDownParamsItems(
      list: 'BAYASYSTEMCONSTANTS',
      key: '$key',
      params: [...params],
      actionFlag: null,
      procName: null,
      subActionFlag: null,
      xmlStr: null,
    );
  }

  Future<DropDownParamsItems> createBCCRequestParams({
    String key,
    String tableCode,
    bool addCompany = true,
  }) async {
    final companyId = await getCompanyId();
    XMLBuilder xml =
    XMLBuilder(tag: "List").addElement(key: "TableCode", value: tableCode);
    if (addCompany) xml.addElement(key: "CompanyId", value: "$companyId");
    return DropDownParamsItems(
      list: "BAYACONTROLCODES-DROPDOWN",
      key: key,
      xmlStr: xml.buildElement(),
      procName: "bayacontrolcodelistproc",
      actionFlag: "LIST",
      subActionFlag: "",
      params: null,
    );
  }

  List<BranchModel> getBranchesList(Map<String, dynamic> json, String key) {
    return BaseJsonParser.goodList(json, key)
        ?.map((e) => BranchModel.fromJson(e))
        ?.toList() ??
        [];
  }

  List<BSCModel> getBSCList(Map<String, dynamic> json, String key) {
    return BaseJsonParser.goodList(json, key)
        ?.map((e) => BSCModel.fromJson(e))
        ?.toList() ??
        [];
  }

  List<BCCModel> getBCCList(Map<String, dynamic> json, String key) {
    return BaseJsonParser.goodList(json, key)
        ?.map((e) => BCCModel.fromJson(e))
        ?.toList() ??
        [];
  }
}
