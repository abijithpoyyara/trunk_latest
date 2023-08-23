import 'dart:convert';

import 'package:base/services.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';

class GradeLookupRepository extends BaseRepository {
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
    String service = "getdata";

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "id",
      "params": [
        {
          "column": "Description",
          "value": "%${searchQuery}%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        }
      ],
      "dropDownParams": [
        {
          "list": "ITEM-LOOKUP",
          "key": "resultObject",
          "procName": "grademstlistproc",
          "actionFlag": "GRADE",
          "subActionFlag": "",
        }
      ]
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/inventory/controller/cmn/getdropdownlist";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = GradeLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
