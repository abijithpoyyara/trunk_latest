import 'package:base/services.dart';
import 'package:base/src/utils/base_json_parser.dart';

class ClientInfo extends BaseResponseModel {
  String clientId;
  String clientName;
  int id;

  ClientInfo.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    var _result = parsedJson.containsKey("resultObject") &&
            parsedJson["resultObject"] != null
        ? parsedJson["resultObject"][0]
        : {"Client_ID": "", "ClientName": ""};
    clientId = BaseJsonParser.goodString(_result, "Client_ID");
    clientName = BaseJsonParser.goodString(_result, "ClientName");
    id = BaseJsonParser.goodInt(_result, "Id");
  }
}

class ClientDetails extends BaseResponseModel {
  ClientLevel companies;
  ClientLevel branches;
  ClientLevel locations;

  ClientDetails.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey("resultObject") &&
        parsedJson["resultObject"] != null) {
      parsedJson["resultObject"].forEach((obj) {
        ClientLevel levelObj = ClientLevel.fromJson(obj);
        switch (levelObj.code) {
          case "L1":
            companies = levelObj;
            break;
          case "L2":
            branches = levelObj;
            break;
          case "L3":
            locations = levelObj;
            break;
        }
      });
    }
  }
}

class ClientLevel {
  int id;
  String code;
  int userId;
  List<String> notificationTopics;
  List<ClientLevelDetails> levels;


  ClientLevel.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "id");
    code = BaseJsonParser.goodString(json, "code");
    userId = BaseJsonParser.goodInt(json, "userid");
    notificationTopics = BaseJsonParser.goodList(json, "notificationtopics").map<String>((e) => e)
        .toList();
    print("Topics");
    notificationTopics.forEach((element) {
      print(element);
    });
    levels = [];
    if (json["data"] != null)
      json["data"]
          .forEach((lev) => levels.add(ClientLevelDetails.fromJson(lev)));
  }
}

class ClientLevelDetails {
  int id;
  String name;
  int parentLevelId;
  int parentLevelDataId;
  String levelCode;
  bool isDefault;
  String notificationcount;

  ClientLevelDetails(this.id, this.name, this.parentLevelId, this.isDefault,
      this.levelCode, this.parentLevelDataId);

  ClientLevelDetails.fromJson(Map<String, dynamic> json) {
    id =
//    json["id"];
        BaseJsonParser.goodInt(json, "id");
    name =
//    json["name"];
        BaseJsonParser.goodString(json, "name");
    parentLevelId =
//    json["parentbusinesslevelid"];
        BaseJsonParser.goodInt(json, "parentbusinesslevelid");
    parentLevelDataId =
//    json["parentbusinessleveldataid"];
        BaseJsonParser.goodInt(json, "parentbusinessleveldataid");
    levelCode =
//    json["businesslevelcode"];
        BaseJsonParser.goodString(json, "businesslevelcode");
    isDefault = BaseJsonParser.goodBoolean(json, "defaultyn");
    notificationcount = BaseJsonParser.goodString(json, "notificationcount");
  }

  ClientLevelDetails.fromMap(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "LevelValue");
    parentLevelId = BaseJsonParser.goodInt(json, "LevelId");
    levelCode = BaseJsonParser.goodString(json, "LevelCode");
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'parentLevelId': parentLevelId,
        'parentLevelDataId': parentLevelDataId,
        'levelCode': levelCode,
        'isDefault': isDefault
      };
}

class UnreadNotificationListModel {
  int transid;
  int transtableid;
  String readstatusyn;

  UnreadNotificationListModel.fromJson(Map<String, dynamic> json) {
    transid = BaseJsonParser.goodInt(json, "transid");
    transtableid = BaseJsonParser.goodInt(json, "transtableid");
    readstatusyn = BaseJsonParser.goodString(json, "readstatusyn");
  }

  UnreadNotificationListModel(
      {this.transid, this.transtableid, this.readstatusyn});
}

class UnreadNotificationList extends BaseResponseModel {
  List<UnreadNotificationListModel> notificationUnread;

  UnreadNotificationList.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      notificationUnread = new List<UnreadNotificationListModel>();
      parsedJson['resultObject'].forEach((mod) {
        notificationUnread.add(new UnreadNotificationListModel.fromJson(mod));
      });
    } else
      notificationUnread = List<UnreadNotificationListModel>();
  }
}

class NotificationCountDetailsModel extends BaseResponseModel {
  List<NotificationCountDetails> notificationCount;

  NotificationCountDetailsModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      notificationCount = new List<NotificationCountDetails>();
      parsedJson['resultObject'].forEach((mod) {
        notificationCount.add(new NotificationCountDetails.fromJson(mod));
      });
    } else
      notificationCount = List<NotificationCountDetails>();
  }
}

class NotificationCountDetails {
  int notificationcount;
  int notificationoptionid;
  int refoptionid;
  int unblockrequestnotificationid;
  int filterbranchid;
  String clientid;
  int approvalsubtypeid;

  NotificationCountDetails.fromJson(Map<String, dynamic> json) {
    notificationcount = BaseJsonParser.goodInt(json, "notificationcount");
    notificationoptionid = BaseJsonParser.goodInt(json, "notificationoptionid");
    refoptionid = BaseJsonParser.goodInt(json, "refoptionid");
    unblockrequestnotificationid =
        BaseJsonParser.goodInt(json, "unblockrequestnotificationid");
    approvalsubtypeid = BaseJsonParser.goodInt(json, "approvalsubtypeid");
    filterbranchid = BaseJsonParser.goodInt(json, "filterbranchid");
    clientid = BaseJsonParser.goodString(json, "clientid");
  }

  NotificationCountDetails(
      {this.notificationcount, this.notificationoptionid, this.refoptionid});
}
