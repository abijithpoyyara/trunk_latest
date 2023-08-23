// To parse this JSON data, do
//
//     final fetchBccIdModel = fetchBccIdModelFromJson(jsonString);

import 'dart:convert';

FetchBccIdModel fetchBccIdModelFromJson(String str) => FetchBccIdModel.fromJson(json.decode(str));

String fetchBccIdModelToJson(FetchBccIdModel data) => json.encode(data.toJson());

class FetchBccIdModel {
  FetchBccIdModel({
    this.statusCode,
    this.statusMessage,
    this.resultApprovalTypes,
  });

  int statusCode;
  String statusMessage;
  List<ResultApprovalType> resultApprovalTypes;

  factory FetchBccIdModel.fromJson(Map<String, dynamic> json) => FetchBccIdModel(
    statusCode: json["statusCode"],
    statusMessage: json["statusMessage"],
    resultApprovalTypes: List<ResultApprovalType>.from(json["resultApprovalTypes"].map((x) => ResultApprovalType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "statusMessage": statusMessage,
    "resultApprovalTypes": List<dynamic>.from(resultApprovalTypes.map((x) => x.toJson())),
  };
}

class ResultApprovalType {
  ResultApprovalType({
    this.tablecode,
    this.slno,
    this.fieldcodename,
    this.id,
    this.code,
    this.description,
    this.extra,
    this.sortorder,
  });

  String tablecode;
  int slno;
  String fieldcodename;
  int id;
  String code;
  String description;
  dynamic extra;
  int sortorder;

  factory ResultApprovalType.fromJson(Map<String, dynamic> json) => ResultApprovalType(
    tablecode: json["tablecode"],
    slno: json["slno"],
    fieldcodename: json["fieldcodename"],
    id: json["id"],
    code: json["code"],
    description: json["description"],
    extra: json["extra"],
    sortorder: json["sortorder"],
  );

  Map<String, dynamic> toJson() => {
    "tablecode": tablecode,
    "slno": slno,
    "fieldcodename": fieldcodename,
    "id": id,
    "code": code,
    "description": description,
    "extra": extra,
    "sortorder": sortorder,
  };
}
