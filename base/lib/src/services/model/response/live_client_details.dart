import '../../../../services.dart';
import '../../../../utility.dart';

class LiveClientDetailsModel extends BaseResponseModel {
  List<LiveClientDetails> clientDetailsList;

  LiveClientDetailsModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      clientDetailsList = new List<LiveClientDetails>();
      parsedJson['resultObject'].forEach((mod) {
        clientDetailsList.add(new LiveClientDetails.fromJson(mod));
      });
    } else
      clientDetailsList = List<LiveClientDetails>();
  }
}

class LiveClientDetails {
  String client_id;
  String clientname;
  String address1;

  LiveClientDetails.fromJson(Map<String, dynamic> json) {
    client_id =
//    json["client_id"];
        BaseJsonParser.goodString(json, "client_id");
    clientname = BaseJsonParser.goodString(json, "clientname");
//    json["clientname"];
    address1 = BaseJsonParser.goodString(json, "address1");
//    json["address1"];
  }
  LiveClientDetails({this.client_id, this.address1, this.clientname});

  Map toMap() {
    Map<String, dynamic> kMap = Map<String, dynamic>();
    kMap["client_id"] = client_id;
    kMap["clientname"] = clientname;
    kMap["address1"] = address1;
    return kMap;
  }

  Map<String, dynamic> toJson() => {
        'client_id': client_id,
        'clientname': clientname,
        'address1': address1,
      };
}

class NotificationCountFromDbModel extends BaseResponseModel {
  List<NotificationCountFromDbList> notificationCountFromDbList;

  NotificationCountFromDbModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      notificationCountFromDbList = new List<NotificationCountFromDbList>();
      parsedJson['resultObject'].forEach((mod) {
        notificationCountFromDbList
            .add(new NotificationCountFromDbList.fromJson(mod));
      });
    } else
      notificationCountFromDbList = List<NotificationCountFromDbList>();
  }
}

class NotificationCountFromDbList {
  int notificationcount;
  String clientid;

  NotificationCountFromDbList.fromJson(Map<String, dynamic> json) {
    clientid =
//    json["client_id"];
        BaseJsonParser.goodString(json, "clientid");
    notificationcount = BaseJsonParser.goodInt(json, "notificationcount");
//    json["clientname"];

//    json["address1"];
  }
  NotificationCountFromDbList({this.clientid, this.notificationcount});

  Map toMap() {
    Map<String, dynamic> kMap = Map<String, dynamic>();
    kMap["clientid"] = clientid;
    kMap["notificationcount"] = notificationcount;

    return kMap;
  }

  Map<String, dynamic> toJson() => {
        'clientid': clientid,
        'notificationcount': notificationcount,
      };
}
