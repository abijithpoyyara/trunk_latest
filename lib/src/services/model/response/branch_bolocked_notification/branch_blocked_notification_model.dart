import 'package:base/services.dart';

import '../../../../../utility.dart';

class BlockedNotificationModel extends BaseResponseModel {
  List<BLockedNotificaionList> bLockedNotificaionList ;

  BlockedNotificationModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    bLockedNotificaionList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => BLockedNotificaionList.fromJson(e))
        .toList();
  }
}

class BLockedNotificaionList {
  List<Branchdtl> branchdtl;
  List<Notificationcount> notificationcount;
  int nextoptionid;
  bool nextoptionuserrightyn;

  BLockedNotificaionList.fromJson(Map parsedJson) {
    notificationcount = BaseJsonParser.goodList(parsedJson, "notificationcount")
        .map((e) => Notificationcount.fromJson(e))
        .toList();
    branchdtl = BaseJsonParser.goodList(parsedJson, "branchdtl")
        .map((e) => Branchdtl.fromJson(e))
        .toList();
    nextoptionid = BaseJsonParser.goodInt(parsedJson, "nextoptionid");
    nextoptionuserrightyn =
        BaseJsonParser.goodBoolean(parsedJson, "nextoptionuserrightyn");
  }
}

class Branchdtl{
  int drowno;
  int branchid;
  String branchname;
  String duemessage;
  String blockdate;
  String servercurrenttime;
  int count;
  String notificationtype;
  Branchdtl.fromJson(Map parsedJson) {
    drowno = BaseJsonParser.goodInt(parsedJson, "drowno");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    branchname = BaseJsonParser.goodString(parsedJson, "branchname");
    duemessage = BaseJsonParser.goodString(parsedJson, "duemessage");
    blockdate = BaseJsonParser.goodString(parsedJson, "blockdate");
    blockdate = BaseJsonParser.goodString(parsedJson, "servercurrenttime");
    count = BaseJsonParser.goodInt(parsedJson, "count");
    notificationtype =
        BaseJsonParser.goodString(parsedJson, "notificationtype");
  }
}

class Notificationcount {
  String notificationtype;
  int notificationcount;

  Notificationcount.fromJson(Map parsedJson) {
    notificationtype =
        BaseJsonParser.goodString(parsedJson, "notificationtype");
    notificationcount = BaseJsonParser.goodInt(parsedJson, "notificationcount");
  }
}