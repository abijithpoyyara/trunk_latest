import 'dart:convert';

import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';

class LoginPost {
  Map logparams;
  final String username;
  final String clientId;
  final String password;
  final String apptype;
  final LoginParams loginBusinessLevels;

  LoginPost(
      {@required this.username,
      @required this.clientId,
      @required this.password,
        this.apptype,
      this.loginBusinessLevels}) {
    logparams = new Map<String, dynamic>();
    logparams["clientid"] = clientId.trim();
    logparams["userid"] = username.trim();
    logparams["versionno"] = Settings.getVersion();
    logparams["versioncode"] = "mobile";
    logparams["loginDate"] = BaseDates(DateTime.now()).dbformat;
    logparams["password"] = password;
    logparams["apptype"] = apptype;
    logparams['procName'] = "MobileLoginProc";
    logparams['logParamDtl'] = loginBusinessLevels.toMap();
  }

  List callReq() {
    var requestParams = new List();
    requestParams.add(json.encode(logparams));
    return requestParams;
  }
}

class LoginParams {
  final ClientLevelDetails company;
  final ClientLevelDetails branch;
  final ClientLevelDetails location;

  LoginParams({this.company, this.branch, this.location});

  List<Map<String, dynamic>> toMap() {
    return company != null || branch != null || location != null
        ? [
            {
              "LevelId": "1",
              "LevelCode": "L1",
              "LevelValue": "${company.id}"
            },
            {
              "LevelId": "2",
              "LevelCode": "L2",
              "LevelValue": "${branch.id}"
            },
            {
              "LevelId": "3",
              "LevelCode": "L3",
              "LevelValue": "${location.id}"
            },
          ]
        :
    [];
  }
}
