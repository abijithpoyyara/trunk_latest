import 'dart:convert';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/analysis_code_user_lookup_model.dart';

import '../../../../utility.dart';

class AnalysisCodeLookupRepository extends BaseRepository{

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
    String searchQuery}) async{
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    String service = "getdata";

    List params = [
      {
        "column": "Name",
        "value": "",
        "datatype": "STR",
        "restriction": "ILIKE",
        "sortorder": null
      },
      ];
    List searchParams = [
      {
        "column": "Name",
        "value": "%${searchQuery}%",
        "datatype": "STR",
        "restriction": "ILIKE",
        "sortorder": null
      }
    ];

    var searchReq = {
      "flag": "ALL",
      "start": 0,
      "limit": "100000",
      "value": 0,
      "colName": "name",
      "params": params,
    };

    var ddpObjects = {
      "flag": "ALL",
      "start": start,
      "limit": "30000",
      "value": value,
      "colName": "Id",
      "params": searchQuery.isNotEmpty ? searchParams : params,
    "dropDownParams":[{"list":"SERVICE-LOOKUP","key":"resultObject","procName":"analysiscodelistproc",
         "actionFlag":"LIST","subActionFlag":"ANALYSISCODE"}]
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
          LookupModel responseJson = AnalysisCodeUserModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }}
