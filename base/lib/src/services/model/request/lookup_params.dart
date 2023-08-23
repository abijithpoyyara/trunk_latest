import 'dart:convert';

import 'package:flutter/cupertino.dart';

class LookupParams {
  Map lookupParams;

  final String actionFlag;
  final String key;
  final String flag;
  final String procName;
  final String actionSubFlag;
  final String xmlStr;

  LookupParams(
      {@required this.actionFlag,
      @required this.key,
      @required this.flag,
      @required this.procName,
      @required this.actionSubFlag,
      @required this.xmlStr});

  Map toMap() {
    lookupParams = Map<String, String>();
    lookupParams["list"] = flag;
    lookupParams["key"] = key;
    lookupParams["procName"] = procName;
    lookupParams["actionFlag"] = actionFlag;
    lookupParams["actionSubFlag"] = actionSubFlag;
    lookupParams["xmlStr"] = xmlStr;
    return lookupParams;
  }

  String callReq(String varName) {
    //  [{"dropDownParams":[{"list":"EXEC-PROC","key":"documentListObj","store":"documentTypeStore","removeAll":false,"procName":"dsmasterlistproc","actionFlag":"DOCUMENT_MASTER","subActionFlag":"","xmlStr":"<List CompanyID =\"2\" ></List>"}]}]

    toMap();
    varName = varName.isEmpty ? "dropDownParams" : varName;
    return "[{\"" + varName + "\":[" + json.encode(lookupParams) + "]}]";
  }
}
