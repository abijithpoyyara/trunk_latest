import 'package:base/services.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';

class POAckSupplierLookupRepository extends BaseRepository {
  fetchData({
    @required Function(AppException exception) onRequestFailure,
    @required Function(LookupModel lookupModel) onRequestSuccess,
    String searchQuery
  }) {


    var ddpObjects = {
      "dropDownParams": [
        {
          "list": "EXEC-PROC",
          "key": "userObj",
          "procName": "MobileUserListProc",
          "actionFlag": "LIST",
          "subActionFlag": "",
          "xmlStr": " <List Start = \"0\" Limit = \"10\" Name = \"%$searchQuery%\"> </List>",
        },
      ]
    };

    String service = "getdata";
    String url = '/purchase/controller/cmn/getdropdownlist';
    performRequest(
        jsonArr: [json.encode(ddpObjects)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          LookupModel responseJson = POAckSupplierLookupModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }
}
