import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';

class SupplierQuotaItemLookupRepository extends BaseRepository {
  fetchData({@required String procedure,
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


    // List params = [
    //   if (searchQuery?.isNotEmpty ?? false)
    //     {
    //       "column": "ItemName",
    //       "value": "%$searchQuery%",
    //       "datatype": "STR",
    //       "restriction": "ILIKE",
    //       "sortorder": "ASC"
    //     }
    // ];

    List params = [

          {
            "column": "name",
            "value": "",
            "datatype": "STR",
            "restriction": "ILIKE",
            "sortorder": "ASC"
          },
      if (searchQuery?.isNotEmpty)
            {
          "column": "name",
          "value": "%${searchQuery}%",
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
      "colName": "name",
      "params": params,
      // "dropDownParams": [
      //   {
      //     "list": "ITEM-LOOKUP",
      //     "procName": "ItemMstProc",
      //     "key": "resultObject",
      //     "actionFlag": "LIST",
      //     "subActionFlag": "ITEMS"
      //   }
      // ]
    };


    //url: /ap/controller/def/getsuppliers
    //jsonArr: [{"flag":"ALL","SOR_Id":1,"EOR_Id":591,"TotalRecords":2,"start":0,"limit":"10","value":0,"colName":"name","params":[{"column":"name","value":"","datatype":"STR","restriction":"ILIKE","sortorder":"ASC"}]}]
    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "10",
      "value": value,
      "colName": "name",
     "params":params,
      // "colName": "name",
      // "dropDownParams": [
      //   {
      //     "list": "ITEM-LOOKUP",
      //     "procName": "ItemMstProc",
      //     "key": "resultObject",
      //     "actionFlag": "LIST",
      //     "subActionFlag": "ITEMS"
      //   }
      // ]
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
          LookupModel responseJson = SupplierQuotaModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
