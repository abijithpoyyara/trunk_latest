import 'package:redstars/utility.dart';

class JobProgressRptSummaryModel {
  String description;
  String dataIndex;
  var value;
  bool isPercentage;

  JobProgressRptSummaryModel.fromJson(Map<String, dynamic> json) {
    description = BaseJsonParser.goodString(json, "hdrdesc");
    dataIndex = BaseJsonParser.goodString(json, "dataindex");
    value = BaseJsonParser.goodValue(json, "value");
    isPercentage = BaseJsonParser.goodBoolean(json, "percyn");
  }
}

class JobRptModel {
  String roottransno;
  String refoptionname;
  String reftransno;
  String reftransdate;
  String startdate;
  String enddate;
  String name;
  String id;
  String parentid;
  String approvaltime;
  String timetaken;
  String difference;
  String drilldownyn;

  String status;
  String transNo;
  String transTableId;

  int level;
  int colorCode;
  int sequenceno;
  int sortorder;

  bool isLeaf;
  bool isHeader;
  bool isGroupNode;
  bool hasDrillDown;
  bool isCompleted;

  JobRptModel.fromJson(Map<String, dynamic> json) {
    roottransno = BaseJsonParser.goodString(json, "roottransno");
    refoptionname = BaseJsonParser.goodString(json, "refoptionname");
    reftransno = BaseJsonParser.goodString(json, "reftransno");
    reftransdate = BaseJsonParser.goodString(json, "reftransdate");
    startdate = BaseJsonParser.goodString(json, "startdate");
    enddate = BaseJsonParser.goodString(json, "enddate");
    name = BaseJsonParser.goodString(json, "name");
    approvaltime = BaseJsonParser.goodString(json, "approvaltime");
    timetaken = BaseJsonParser.goodString(json, "timetaken");
    difference = BaseJsonParser.goodString(json, "difference");
    drilldownyn = BaseJsonParser.goodString(json, "drilldownyn");

    status = BaseJsonParser.goodString(json, "status");
    id = BaseJsonParser.goodString(json, "id");
    if (id?.isNotEmpty ?? false) {
      var trans = id.split('_');
      transTableId = trans?.first ?? '';
      transNo = trans?.last ?? '';
    }
    parentid = BaseJsonParser.goodString(json, "parentid");

    sequenceno = BaseJsonParser.goodInt(json, "sequenceno");
    colorCode = BaseJsonParser.goodInt(json, "color");
    level = BaseJsonParser.goodInt(json, "level");
    sortorder = BaseJsonParser.goodInt(json, "sortorder");

    hasDrillDown = BaseJsonParser.goodBoolean(json, "drilldownflag");
    isGroupNode = BaseJsonParser.goodBoolean(json, "groupnodeyn");
    isCompleted = BaseJsonParser.goodBoolean(json, "completedyn");
    isLeaf = BaseJsonParser.goodBoolean(json, "leafyn");
    isHeader = BaseJsonParser.goodBoolean(json, "headeryn");
  }
}
