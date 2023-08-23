import 'dart:convert';

import 'package:base/services.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/vehicle_enquiry/vehicle_enquiry_production_lookup_model.dart';

class VehicleEnquiryLookupRepository extends BaseRepository {
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
      "limit": "15",
      "value": value,
      "colName": "name",
      "params": [
        {"column": "LookUpFilterYN", "datatype": "EQU", "value": "Y"},
        {"column": "Flag", "datatype": "EQU", "value": "ALL"},
        // {
        //   "column": "ModelName",
        //   "value": "%$searchQuery%",
        //   "datatype": "STR",
        //   "restriction": "ILIKE",
        //   "sortorder": null
        // },
        // {
        //   "column": "VehicleNo",
        //   "value": "%$searchQuery%",
        //   "datatype": "STR",
        //   "restriction": "ILIKE",
        //   "sortorder": null
        // },
        // {
        //   "column": "EngineNo",
        //   "value": "%$searchQuery%",
        //   "datatype": "STR",
        //   "restriction": "ILIKE",
        //   "sortorder": null
        // },
        {
          "column": "Mobilefilter",
          "value": "%$searchQuery%",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },
        {
          "column": "MobilefilterFlag",
          "value": "MOBILE",
          "datatype": "STR",
          "restriction": "ILIKE",
          "sortorder": null
        },
        // {
        //   "column": "CustomerName",
        //   "value": "%$searchQuery%",
        //   "datatype": "STR",
        //   "restriction": "ILIKE",
        //   "sortorder": null
        // },
        // {
        //   "column": "PhoneNo",
        //   "value": "%$searchQuery%",
        //   "datatype": "STR",
        //   "restriction": "ILIKE",
        //   "sortorder": null
        // }
      ],
      "dropDownParams": [
        {
          "list": "LOCATION_MULTI_SEL",
          "key": "resultObject",
          "procName": "VehicleEnquiryListProc",
          "actionFlag": "LIST",
          "subActionFlag": "VIEW"
        }
      ]
    };

    if (sor_Id != null) ddpObjects["SOR_Id"] = sor_Id;
    if (eor_Id != null) ddpObjects["EOR_Id"] = eor_Id;
    if (totalRecords != null) ddpObjects["TotalRecords"] = totalRecords;

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = VehicleEnquiryLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
