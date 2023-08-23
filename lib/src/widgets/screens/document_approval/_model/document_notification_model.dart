// To parse this JSON data, do
//
//     final documentNotificationModel = documentNotificationModelFromJson(jsonString);

import 'dart:convert';

List<DocumentNotificationModel> documentNotificationModelFromJson(String str) => List<DocumentNotificationModel>.from(json.decode(str).map((x) => DocumentNotificationModel.fromJson(x)));

String documentNotificationModelToJson(List<DocumentNotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DocumentNotificationModel {
  DocumentNotificationModel({
    this.slno,
    this.reftabledataid,
    this.reftableid,
    this.transno,
    this.transdate,
    this.optionid,
    this.optionname,
    this.emailto,
    this.leveltypebccid,
    this.currentlevel,
    this.currapprovedno,
    this.maxlevelid,
    this.maxlevel,
    this.reference,
    this.translastmoddate,
    this.narration,
    this.refno,
    this.refdate,
    this.branchname,
    this.preparedbyid,
    this.preparedby,
    this.prepareddate,
    this.totalvalue,
    this.totaldisc,
    this.grosstotal,
    this.totaltax,
    this.nettotal,
    this.discaftertax,
    this.roundoff,
    this.totalinvoicevalue,
    this.dtltablereqyn,
    this.historydtl,
    this.docattachreqyn,
    this.doccount,
    this.start,
    this.limit,
    this.totalrecords,
  });

  int slno;
  int reftabledataid;
  int reftableid;
  String transno;
  String transdate;
  int optionid;
  String optionname;
  dynamic emailto;
  int leveltypebccid;
  String currentlevel;
  int currapprovedno;
  int maxlevelid;
  String maxlevel;
  String reference;
  String translastmoddate;
  String narration;
  String refno;
  dynamic refdate;
  String branchname;
  int preparedbyid;
  String preparedby;
  String prepareddate;
  int totalvalue;
  int totaldisc;
  double grosstotal;
  double totaltax;
  double nettotal;
  int discaftertax;
  int roundoff;
  double totalinvoicevalue;
  String dtltablereqyn;
  dynamic historydtl;
  dynamic docattachreqyn;
  dynamic doccount;
  int start;
  int limit;
  int totalrecords;

  factory DocumentNotificationModel.fromJson(Map<String, dynamic> json) => DocumentNotificationModel(
    slno: json["slno"],
    reftabledataid: json["reftabledataid"],
    reftableid: json["reftableid"],
    transno: json["transno"],
    transdate: json["transdate"],
    optionid: json["optionid"],
    optionname: json["optionname"],
    emailto: json["emailto"],
    leveltypebccid: json["leveltypebccid"],
    currentlevel: json["currentlevel"],
    currapprovedno: json["currapprovedno"],
    maxlevelid: json["maxlevelid"],
    maxlevel: json["maxlevel"],
    reference: json["reference"],
    translastmoddate: json["translastmoddate"],
    narration: json["narration"],
    refno: json["refno"],
    refdate: json["refdate"],
    branchname: json["branchname"],
    preparedbyid: json["preparedbyid"],
    preparedby: json["preparedby"],
    prepareddate: json["prepareddate"],
    totalvalue: json["totalvalue"],
    totaldisc: json["totaldisc"],
    grosstotal: json["grosstotal"].toDouble(),
    totaltax: json["totaltax"].toDouble(),
    nettotal: json["nettotal"].toDouble(),
    discaftertax: json["discaftertax"],
    roundoff: json["roundoff"],
    totalinvoicevalue: json["totalinvoicevalue"].toDouble(),
    dtltablereqyn: json["dtltablereqyn"],
    historydtl: json["historydtl"],
    docattachreqyn: json["docattachreqyn"],
    doccount: json["doccount"],
    start: json["start"],
    limit: json["limit"],
    totalrecords: json["totalrecords"],
  );

  Map<String, dynamic> toJson() => {
    "slno": slno,
    "reftabledataid": reftabledataid,
    "reftableid": reftableid,
    "transno": transno,
    "transdate": transdate,
    "optionid": optionid,
    "optionname": optionname,
    "emailto": emailto,
    "leveltypebccid": leveltypebccid,
    "currentlevel": currentlevel,
    "currapprovedno": currapprovedno,
    "maxlevelid": maxlevelid,
    "maxlevel": maxlevel,
    "reference": reference,
    "translastmoddate": translastmoddate,
    "narration": narration,
    "refno": refno,
    "refdate": refdate,
    "branchname": branchname,
    "preparedbyid": preparedbyid,
    "preparedby": preparedby,
    "prepareddate": prepareddate,
    "totalvalue": totalvalue,
    "totaldisc": totaldisc,
    "grosstotal": grosstotal,
    "totaltax": totaltax,
    "nettotal": nettotal,
    "discaftertax": discaftertax,
    "roundoff": roundoff,
    "totalinvoicevalue": totalinvoicevalue,
    "dtltablereqyn": dtltablereqyn,
    "historydtl": historydtl,
    "docattachreqyn": docattachreqyn,
    "doccount": doccount,
    "start": start,
    "limit": limit,
    "totalrecords": totalrecords,
  };
}
