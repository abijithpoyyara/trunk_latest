// To parse this JSON data, do
//
//     final payloadModel = payloadModelFromJson(jsonString);

import 'dart:convert';

PayloadModel payloadModelFromJson(String str) =>
    PayloadModel.fromJson(json.decode(str));

String payloadModelToJson(PayloadModel data) => json.encode(data.toJson());

class PayloadModel {
  PayloadModel(
      {this.transid,
      this.approvaloptionid,
      this.optionid,
      this.view,
      this.subTypeId,
      this.clickAction,
      this.transtableid,
      this.refoptionid,
      this.approvalOptionCode,
      this.refoptnCode,
      this.approvalOptName,
      this.branchid,
      this.clientid});

  String transid;
  String approvaloptionid;
  String optionid;
  String view;
  String subTypeId;
  String clickAction;
  String transtableid;
  String refoptionid;
  String refoptnCode;
  String approvalOptionCode;
  String approvalOptName;
  String clientid;
  String branchid;

  factory PayloadModel.fromJson(Map<String, dynamic> json) => PayloadModel(
      transid: json["transid"],
      approvaloptionid: json["approptionid"],
      optionid: json["optionid"],
      subTypeId: json["subtypeid"],
      view: json["view"],
      refoptionid: json["refoptionid"],
      branchid: json["branchid"],
      clickAction: json["click_action"],
      transtableid: json["transtableid"],
      approvalOptionCode: json["approptioncode"],
      refoptnCode: json["refoptioncode"],
      clientid: json["clientid"],
      approvalOptName: json["optionname"]);

  Map<String, dynamic> toJson() => {
        "transid": transid,
        "approvaloptionid": approvaloptionid,
        "optionid": optionid,
        "view": view,
        "subtypeid": subTypeId,
        "refoptionid": refoptionid,
        "click_action": clickAction,
        "branchid": branchid,
        "transtableid": transtableid,
        "approptioncode": approvalOptionCode,
        "refoptioncode": refoptnCode,
        "optionname": approvalOptName,
        "clientid": clientid,
      };
}
