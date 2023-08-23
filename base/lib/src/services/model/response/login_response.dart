import 'package:base/src/utils/base_json_parser.dart';

class LoginResponse {
  var statusCode;
  String statusMessage;
  List<LoginModules> modules;
  SSNIDN ssnidn;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];

    if (json['resultObject'] != null) {
      modules = new List<LoginModules>();
      json['resultObject'].forEach((mod) {
        modules.add(new LoginModules.cast(mod));
      });
    }
    if (json['ssnidn'] != null) {
      ssnidn = SSNIDN.fromJson(json['ssnidn']);
    }
  }

  @override
  String toString() {
    return 'statusCode : $statusCode  status message: $statusMessage modules : $modules ssnIdn $ssnidn';
  }
}

class LoginModules {
  String listtype;
  String list;

  List<BusinessLevelModel> businessLevelModel;
  List<ModuleListModel> moduleListModel;
  List<CompanyConstants> companyConstants;
  List<DashboardTileRights> dashBoardTileRights;

  LoginModules.cast(Map<String, dynamic> json) {
    listtype = json['listtype'];
    if (listtype == "BusinessLevelList")
      businessLevelModel = saveBusinessLevelData(json);
    else if (listtype == "CompanyConstants")
      companyConstants = saveCompanyData(json);
    else if (listtype == "ModuleList")
      moduleListModel = saveModulesData(json);
    else if (listtype == "DashboardTileRights")
      dashBoardTileRights = saveDashboardData(json);
    else
      list = json['list'].toString();
  }

  @override
  String toString() {
    return ' list type : $listtype \n list: $list ';
  }
}

class SSNIDN {
  String ssnId;

  SSNIDN.fromJson(Map<String, dynamic> json) {
    ssnId = json['value'];
  }

  @override
  String toString() {
    return ' ssnid: $ssnId ';
  }
}

class ModuleListModel {
  int optionId;
  int id;
  int parentoptionid;
  String title;
  String optiondescription;
  String isactive;
  String ishidden;
  String src;
  int sortorder;
  bool isAttachmentReq;
  String budgetreqyn;
  String context;

  ModuleListModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    optiondescription = json["optiondescription"];
    sortorder = json["sortorder"];
    isactive = json["isactive"];
    ishidden = json["ishidden"];
    src = json["src"];
    context = json["context"];
    budgetreqyn = json["budgetreqyn"];
    parentoptionid = BaseJsonParser.goodInt(json, "parentoptionid");
    isAttachmentReq = BaseJsonParser.goodBoolean(json, "docattachmentreqyn");
    optionId = parentoptionid ?? BaseJsonParser.goodInt(json, "optionid");
  }

  @override
  String toString() {
    return 'optionId   : $optionId' +
        'id : $id' +
        'title : $title' +
        'optiondescription : $optiondescription' +
        'isactive  : $isactive' +
        'ishidden : $ishidden' +
        'src : $src' +
        'parentoptionid: $parentoptionid' +
        'isAttachmentReq: $isAttachmentReq' +
        'sortorder : $sortorder';
  }
}

class BusinessLevelModel {
  int levelvalue;
  String levelcode;
  int levelid;
  String levelname;
  String businesslocationname;
  int reftableid;

  BusinessLevelModel.fromJson(Map<String, dynamic> json) {
    levelvalue = BaseJsonParser.goodInt(json, "levelvalue");
    levelcode = BaseJsonParser.goodString(json, "levelcode");
    levelid = BaseJsonParser.goodInt(json, "levelid");
    levelname = BaseJsonParser.goodString(json, "levelname");
    businesslocationname =
        BaseJsonParser.goodString(json, "businesslocationname");
    reftableid = BaseJsonParser.goodInt(json, "reftableid");
  }

  @override
  String toString() {
    String tostring = " levelvalue : " + levelvalue.toString();
    tostring += "levelcode : " + levelcode;
    tostring += " levelid : " + levelid.toString();
    tostring += " levelname : " + levelname;
    tostring += " businesslocationname : " + businesslocationname;
    return tostring;
  }
}

class CompanyConstants {
  int finyearid;
  String attchmentupdpath;
  String attchmentdwdpath;
  String dsattchmentupdpath;
  String dsattchmenttempupdpath;
  String dsattchmentdwdpath;
  String username;
  int userid;
  bool isSuperUser;
  int companybasecurrencyid;
  int branchcurrencyid;
  int userdepartmentid;

  List<String> notificationTopics;

  CompanyConstants.fromJson(Map<String, dynamic> json) {
    print("ComapanyData : $json");

    finyearid = json["finyearid"];
    attchmentupdpath = json["attchmentupdpath"];
    attchmentdwdpath = json["attchmentdwdpath"];
    dsattchmentupdpath = json["dsattchmentupdpath"];
    dsattchmenttempupdpath = json["dstemplateuploadpath"];
    dsattchmentdwdpath = json["dsattchmentdwdpath"];
    username = json["username"];
    userid = json["userid"];
    companybasecurrencyid = json["companybasecurrencyid"];
    branchcurrencyid = json["branchcurrencyid"];
    userdepartmentid = json["userdepartmentid"];
    isSuperUser = BaseJsonParser.goodBoolean(json, "superuseryn");
    notificationTopics = BaseJsonParser.goodList(json, "notificationtopics")
        .map<String>((e) => e)
        .toList();

    print("Topics");
    notificationTopics.forEach((element) {
      print(element);
    });
  }
}

class DashboardTileRights {
  int id;
  int optionId;
  String context;
  String name;
  String title;
  bool allow;

  DashboardTileRights.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, 'id');
    optionId = BaseJsonParser.goodInt(json, 'optionid');
    context = BaseJsonParser.goodString(json, 'context');
    name = BaseJsonParser.goodString(json, 'name');
    title = BaseJsonParser.goodString(json, 'title');
    allow = BaseJsonParser.goodString(json, 'allowyn').contains('Y');
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['id'] = id;
    map['optionid'] = optionId;
    map['context'] = context;
    map['name'] = name;
    map['title'] = title;
    map['allowyn'] = allow ? "Y" : "N";
    return map;
  }
}

List<DashboardTileRights> saveDashboardData(
    Map<String, dynamic> dashboardData) {
  List<DashboardTileRights> dashboardRights = List();

  dashboardData['list']?.forEach((data) => {
        print("dash data " + data.toString()),
        dashboardRights.add(DashboardTileRights.fromJson(data))
      });
  return dashboardRights;
}

List<BusinessLevelModel> saveBusinessLevelData(
    Map<String, dynamic> businessData) {
  List<BusinessLevelModel> businessList = List();

  print("business data " + businessData['list'].toString());

  businessData['list']
      .forEach((data) => {businessList.add(BusinessLevelModel.fromJson(data))});
  return businessList;
}

List<ModuleListModel> saveModulesData(Map<String, dynamic> modulesData) {
  List<ModuleListModel> moduleList = List();

  modulesData['list']
      .forEach((data) => {moduleList.add(ModuleListModel.fromJson(data))});
  return moduleList;
}

List<CompanyConstants> saveCompanyData(Map<String, dynamic> companyData) {
  List<CompanyConstants> companyList = List();
  companyData['list']
      .forEach((data) => {companyList.add(CompanyConstants.fromJson(data))});
  return companyList;
}
