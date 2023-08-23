import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';

class LocationLookupRepository extends BaseRepository {
  fetchData(
      {@required int flag,
      @required Function(LookupModel lookupModel) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure,
      int start = 0,
      int sor_Id,
      int eor_Id,
      int totalRecords,
      int value = 0,
      String searchQuery}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    // int superUser = await BasePrefs.getInt(BaseConstants.SUPER_USER_KEY);

    String service = "getdata";

    List params = [
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "Name",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        }
    ];

    String xml = XMLBuilder(tag: "DropDown")
        .addElement(
            key: "OptionBusinessLevelCode", value: "ACCOUNT_BILLING_LEVEL")
        .addElement(key: "ParentBusinessLevelCode", value: "L1")
        .addElement(key: "SuperUserYN", value: "Y")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "BranchId", value: "$branchId")
        .buildElement();

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "Id",
      "params": params,
      "dropDownParams": [
        {
          "list": "EXEC-PROC",
          "key": "resultObject",
          "procName": "BusinessSubLevelProc",
          "xmlStr": xml,
          "actionFlag": "DROPDOWN",
          "subActionFlag": "OPT_BUSINESS_LEVEL_FITER"
        }
      ]
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/purchase/controller/cmn/getdropdownlist";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = LocationLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
