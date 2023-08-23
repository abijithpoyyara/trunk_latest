import 'package:flutter/cupertino.dart';

class Post {
  List jsonArr;
  final String url;
  final String ssnIdn;
  final String service;
  final String chkflag;
  final bool compressedyn;
  final int uuid;
  final int userid;

  Post(
      {@required this.jsonArr,
      @required url,
      @required String ssnidn,
        @required this.chkflag,
        this.userid,
        this.uuid,
        this.compressedyn,
      @required this.service})
      : url = url ?? "/security/controller/cmn/getdropdownlist",
        ssnIdn = ssnidn.trim();

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["jsonArr"] = jsonArr;
    map["url"] = url;
    map["ssnidn"] = ssnIdn;
    map["chkflag"] = chkflag;
    map["compressedyn"] = compressedyn;
    map["uuid"] = uuid;
    map["userid"] = userid;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
