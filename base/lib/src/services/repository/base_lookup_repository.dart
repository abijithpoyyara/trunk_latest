import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';

/// Repository for lookups
class LookupRepository extends BaseRepository {
  fetchData(
      {@required String procedure,
      @required String actionFlag,
      @required Function(LookupModel lookupModel) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String actionSubFlag,
      int start = 0,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      String accountCode,
      String accountName,
      String subActionFlag,
      String url,
      String list,
      String searchQuery,
      List<Map<String, dynamic>> params}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "procName": procedure,
      "actionFlag": actionFlag,
      "actionSubFlag": actionSubFlag ?? "",
      "subActionFlag": subActionFlag ?? "",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "Id",
      "params": params
    };
    if (list != null) {
      ddpObjects["list"] = list;
    }
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String urlStr = "/security/controller/def/getdetailsusingproc";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: urlStr,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = LookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}

class GenericLookupRepository extends LookupRepository {
  fetchLookupData(
      {@required Function(LookupModel lookupModel) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      String actionSubFlag,
      int start = 0,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      String url,
      List<Map<String, dynamic>> jssArr}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String service = "getdata";

    var ddpObjects = jssArr.first;
    ddpObjects["start"] = start;
    ddpObjects["limit"] = "10";
    ddpObjects["value"] = value;
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String urlStr = url ?? "/security/controller/def/getdetailsusingproc";
//    String urlStr = "/security/controller/def/getdetailsusingproc";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: urlStr,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = LookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
