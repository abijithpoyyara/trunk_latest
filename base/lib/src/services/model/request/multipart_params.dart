import 'dart:io';

import 'package:flutter/cupertino.dart';

class MultipartBody {
  File filedata;
  String filename;
  bool overwriteFile;
  String ssnidn;
  String uploadurl;

  MultipartBody(
      {@required this.filedata,
      @required this.filename,
      @required this.overwriteFile,
      @required this.ssnidn,
      @required this.uploadurl});

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["filedata"] = filedata.path;
    map["filename"] = filename;
    map["overwriteFile"] = overwriteFile;
    map["uploadurl"] = uploadurl;
    map["ssnidn"] = ssnidn;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
