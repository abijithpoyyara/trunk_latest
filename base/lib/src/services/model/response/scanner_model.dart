import 'package:base/services.dart';
import 'package:base/src/utils/base_json_parser.dart';

class ScannerConfigModel extends BaseResponseModel {
  List<FileFormatsModel> fileFormats;
  List<DocOption> options;

  ScannerConfigModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    fileFormats = BaseJsonParser.goodList(json, "fileFormats")
        .map((e) => FileFormatsModel.fromJson(e))
        .toList();
    options = BaseJsonParser.goodList(json, "optionList")
        .map((e) => DocOption.fromJson(e))
        .toList();
  }
}

class FileFormatsModel {
  int id;
  String code;
  String description;
  String extra;
  String fieldcodename;
  String tablecode;

  FileFormatsModel.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "id");
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    extra = BaseJsonParser.goodString(json, "extra");
    fieldcodename = BaseJsonParser.goodString(json, "fieldcodename");
    tablecode = BaseJsonParser.goodString(json, "tablecode");
  }
}

class DocOption {
  String docattachoption;
  int documentsattachedoptionid;
  String dropdowncall;
  int dropdowncallbccid;
  int id;
  String mappingname;
  String screenfields;

  DocOption.fromJson(Map<String, dynamic> json) {
    docattachoption = BaseJsonParser.goodString(json, "docattachoption");
    documentsattachedoptionid =
        BaseJsonParser.goodInt(json, "documentsattachedoptionid");
    dropdowncall = BaseJsonParser.goodString(json, "dropdowncall");
    dropdowncallbccid = BaseJsonParser.goodInt(json, "dropdowncallbccid");
    id = BaseJsonParser.goodInt(json, "id");
    mappingname = BaseJsonParser.goodString(json, "mappingname");
    screenfields = BaseJsonParser.goodString(json, "screenfields");
  }

  @override
  String toString() {
    return {
      "docattachoption": docattachoption,
      "documentsattachedoptionid": documentsattachedoptionid,
      "dropdowncall": dropdowncall,
      "id": id,
    }.toString();
  }
}
