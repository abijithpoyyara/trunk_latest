import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';

class ItemLookupRepository extends BaseRepository {
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
      String searchQuery}) async {
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);

    String service = "getdata";

    List params = [
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "ItemName",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        }
    ];

    var searchReq = {
      "flag": "ALL",
      "start": 0,
      "limit": "10",
      "value": 0,
      "colName": "id",
      "params": [
        {
          "column": "ItemName",
          "value": "%abcd%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        }
      ],
      "dropDownParams": [
        {
          "list": "ITEM-LOOKUP",
          "procName": "ItemMstProc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "ITEMS"
        }
      ]
    };

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "15",
      "value": value,
      "params": params,
      "colName": "id",
      "dropDownParams": [
        {
          "list": "ITEM-LOOKUP",
          "procName": "ItemMstProc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "ITEMS"
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
          LookupModel responseJson = ItemLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
