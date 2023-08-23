import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';

class TransTypeLookupRepository extends BaseRepository {
  fetchData(
      {@required String flag,
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

    List params = [
      if (searchQuery?.isNotEmpty ?? false)
        {
          "column": "TransNo",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        }
    ];

    var ddpObjects = {
      "flag": "ALL",
      "start": 0,
      "limit": "10",
      "value": 0,
      "colName": "Id",
      "params": [
        {
          "column": 'DateFrom',
          "value": BaseDates(DateTime.now()).dbformat,
        },
        {
          "column": 'DateTo',
          "value":
              BaseDates(DateTime.now().subtract(Duration(days: 30))).dbformat,
        },
        {"column": 'Flag', "value": flag},
        ...params
      ],
      "dropDownParams": [
        {
          "list": "SERVICE-LOOKUP",
          "key": "resultObject",
          "procName": "PaymentRequestListProc",
          "actionFlag": "LIST",
          "subActionFlag": "TRANSTYPE"
        }
      ]
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/ap/controller/cmn/getdropdownlist";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = TransTypeLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
