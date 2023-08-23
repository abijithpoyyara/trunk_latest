import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';

import '../../../../utility.dart';

class CustomerLookupRepository extends BaseRepository {
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
          "column": "Name",
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
      "params": [],
      "dropDownParams": [
        {
          "list": "CUSTOMER-BASIC",
          "procName": "CustomerMstProc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "CUSTOMERLIST"
        }
      ]
    };

    String xmlStatus = XMLBuilder(tag: "CustomerType")
        .addElement(key: "TypeBccId", value: "1159")
        .buildElement();

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "params": params,
      "colName": "id",
      "xmlStr": xmlStatus,

      /*  "dropDownParams": [
        {
          "procName": "CustomerMstProc",
          "key": "resultObject",
          "actionFlag": "LIST",
          "subActionFlag": "CUSTOMERLIST"
        }
      ]*/

      "dropDownParams": [
        {
          "list": "CUSTOMER-BASIC",
          // "procName": "CustomerMstProc",
          "key": "resultObject",
          // "actionFlag": "LIST",
          // "subActionFlag": "CUSTOMERLIST"
        }
      ]
    };
    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/sales/controller/cmn/getdropdownlist";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = CustomerLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
