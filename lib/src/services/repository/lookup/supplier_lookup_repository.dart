import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';

class SupplierLookupRepository extends BaseRepository {
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

    String service = "getdata";

    List params = [];

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "15",
      "value": value,
      "colName": "name",
      "params": [
        if (searchQuery?.isNotEmpty ?? false)
          {
            "column": "name",
            "value": "%$searchQuery%",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": null,
            // "totalRecords": totalRecords
          },
        {
          "column": "name",
          "value": "",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": "ASC"
        },
        // ...params
      ],
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/ap/controller/def/getsuppliers";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = SupplierLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
