class ImageModel {
  ImageModel(this.success);

  ImageModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        success = json['success'],
        data = FileDtls.fromJson(json['data']);

  String success;
  FileDtls data;

  Map toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["success"] = success;
    map["data"] = data.toMap();
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class FileDtls {
  String filephysicalname;
  String fileextension;
  String filename;
  String status;
  String statusMessage;

  FileDtls.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        filephysicalname = json["filephysicalname"],
        fileextension = json["fileextension"],
        filename = json["filename"],
        status = json["status"],
        statusMessage = json["statusMessage"] {
    print(json);
  }

  Map toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["filephysicalname"] = filephysicalname;
    map["fileextension"] = fileextension;
    map["filename"] = filename;
    map["status"] = status;
    map["statusMessage"] = statusMessage;
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
