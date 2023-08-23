class DocumentApprovalModel {
  int id;
  int optionId;
  int refTableId;
  int refOptionId;
  int refTableDataId;
  int levelNo;
  int levelTypeBccid;
  int userId;
  String username;
  String isCancelled;
  String password;
  int userActionBccId;
  int userRejectionBccId;
  int userApprovalBccId;
  int minimumPersonstoApproveorReject;
  int lastApprovalLevelBccId;
  int lastApprovalLevelminiPersontoApprove;
  String tableName;
  String recordStatus;
  String statusDate;
  String userRemarks;
  String transLastModDate;
  String dtlTableName;
  int subtypeId;

  List<Map<String, dynamic>> dtlApprovals;

  bool emailOnApproval;
  bool smsOnApproval;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["Id"] = id;
    map["optionid"] = optionId;
    map["subtypeId"] = subtypeId;
    map["reftableid"] = refTableId;
    map["refoptionid"] = refOptionId;
    map["reftabledataid"] = refTableDataId;
    map["levelno"] = levelNo;
    map["leveltypebccid"] = levelTypeBccid;
    map["userid"] = userId;
    map["username"] = username;
    map["iscancelledyn"] = isCancelled;
    map["password"] = password;
    map["useractionbccid"] = userActionBccId;
    map["userrejectionbccid"] = userRejectionBccId;
    map["userapprovalbccid"] = userApprovalBccId;
    map["minimumpersonstoapproveorreject"] = minimumPersonstoApproveorReject;
    map["lastapprovallevelbccid"] = lastApprovalLevelBccId;
    map["lastapprovallevelminipersontoapprove"] =
        lastApprovalLevelminiPersontoApprove;
    map["tablename"] = tableName;
    map["recordsatus"] = recordStatus;
    map["statusdate"] = statusDate;
    map["userremarks"] = userRemarks ?? "";
    map["translastmoddate"] = transLastModDate;
    map["dtltablename"] = dtlTableName;
    map["mobile"] = true;
    map["emailonapprovalreqyn"] = emailOnApproval ?? false ? "Y" : "N";
    map["smsonapprovalreqyn"] = smsOnApproval ?? false ? "Y" : "N";

    if (dtlApprovals != null) map["dtlapprovalary"] = dtlApprovals;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
