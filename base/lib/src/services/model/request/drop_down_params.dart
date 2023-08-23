import 'dart:convert';

import 'package:flutter/cupertino.dart';

class DropDownParams {
  List<Map> dropDownParams;

  DropDownParams() {
    dropDownParams = [];
  }
  DropDownParams addDDP(DropDownParamsItems param) {
    dropDownParams.add(param.toMap());
    return this;
  }

  DropDownParams addParams(
      {String actionFlag,
      String key,
      String list,
      String procName,
      String subActionFlag,
      String xmlStr,
      List<Map<String, dynamic>> params}) {
    dropDownParams.add(DropDownParamsItems(
      actionFlag: actionFlag,
      key: key,
      list: list,
      procName: procName,
      subActionFlag: subActionFlag,
      xmlStr: xmlStr,
      params: params,
    ).toMap());
    return this;
  }

  List callReq() {
    Map map = Map<String, dynamic>();
    map["dropDownParams"] = dropDownParams;
    List objList = List();
    objList.add(json.encode(map));

    return objList;
  }
}

class DropDownParamsItems {
  Map dropDownParams;

  final String actionFlag;
  final String key;
  final String list;
  final String procName;
  final String subActionFlag;
  final String xmlStr;
  final List<Map<String, dynamic>> params;

  DropDownParamsItems({
    @required this.actionFlag,
    @required this.key,
    @required this.list,
    @required this.procName,
    @required this.subActionFlag,
    @required this.xmlStr,
    @required this.params,
  });

  Map toMap() {
    dropDownParams = Map<String, dynamic>();
    dropDownParams["list"] = list;
    dropDownParams["key"] = key;
    dropDownParams["procName"] = procName;
    dropDownParams["actionFlag"] = actionFlag;
    dropDownParams["subActionFlag"] = subActionFlag;
    dropDownParams["xmlStr"] = xmlStr;
    if (params?.isNotEmpty ?? false) dropDownParams["params"] = params;
    return dropDownParams;
  }

  List callReq({List requestParams}) {
    Map map = Map<String, dynamic>();
    if (requestParams == null) {
      requestParams = new List();
      requestParams.add(toMap());
    }
    map["dropDownParams"] = requestParams;
    List objList = List();
    objList.add(json.encode(map));

    return objList;
  }
}
