import 'package:base/services.dart';
import 'package:base/utility.dart';

class DocumentAttachments extends BaseResponseModel {
  List<Attachments> attachments = [];

  DocumentAttachments.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey("resultObject") &&
        parsedJson["resultObject"] != null) {
      parsedJson["resultObject"]
          .forEach((data) => attachments.add(Attachments.fromJson(data)));
    }
  }
}

class Attachments {
  String documentName;
  List<Files> files;

  Attachments.fromJson(Map<String, dynamic> json) {
    documentName = BaseJsonParser.goodString(json, "documentname");

    files = BaseJsonParser.goodList(json, "attacheddocs")
        .map((json) => Files.fromJson(json))
        .toList();
  }
}

class Files {
  String originalName;
  String physicalName;

  Files.fromJson(Map<String, dynamic> json) {
    originalName = BaseJsonParser.goodString(json, "attachmentoriginalname");
    physicalName = BaseJsonParser.goodString(json, "attachmentphysicalname");
  }
}
