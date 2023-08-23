import 'dart:convert';

import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/Action_Taken%20Agst_Whom_Model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/pending_transaction_detail_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/TransactionUnblockReqInitModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtl%20listtModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtlHeadingModel l.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/user_object.dart';

import '../../../../utility.dart';

class TransactionUnblockRepository extends BaseRepository {
  static final TransactionUnblockRepository _instance =
  TransactionUnblockRepository._();

  TransactionUnblockRepository._();

  factory TransactionUnblockRepository() => _instance;

  getPendingTransactions({
    int optionId,
    @required Function(List<TransactionReqHeadingList> pendingList) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "Flag", value: "ALL")
        .buildElement();
    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "resultObject",
      xmlStr: xml,
      procName: "NotificationListProc",
      actionFlag: "LIST",
      subActionFlag: "SUMMARY",
    ).callReq();

    String url = "/ap/controller/cmn/getdropdownlist";

    TransactionReqHeading responseJson;
    print(jssArr);
    performRequest(
      service: service,
      jsonArr: jssArr,
      url: url,
      onRequestFailure: onRequestFailure,
      onRequestSuccess: (result) => {
        responseJson = TransactionReqHeading.fromJson(result),
        if (responseJson.statusCode == 1)
          onRequestSuccess(responseJson.transactionReqHeadingList)
        else
          onRequestFailure(
            InvalidInputException(responseJson.statusMessage)
          )
      }
    );
  }

  getPendingTransactionsReqDtlListDetail ({
    int id,int optionId,int st,int branchId,
    @required Function( List<TransUnblockReqDtlModel> budgetList ) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int userId = await BasePrefs.getInt(USERID_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value:"${optionId}")
        .addElement(key: "Id", value: "${id}")
        .addElement(key: "MobileYN", value: "Y")
        .buildElement();
    String axml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value: "${optionId}")
        .addElement(key: "Id", value: "${id}")
        .addElement(key: "BranchId", value: "${branchId}")
        .addElement(key: "MobileYN", value: "Y")

        .buildElement();


    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "resultObject",
      xmlStr: st==0?xml:axml,
      procName: "NotificationListProc",
      actionFlag: "LIST",
      subActionFlag: "DETAIL",
    ).callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    print(jssArr);
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          PendingTransactionReqDetailModel responseJson = PendingTransactionReqDetailModel.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
            List budgetList = BaseJsonParser.goodList(result, 'resultObject')
                .map((e) => TransUnblockReqDtlModel.fromJson(e))
                .toList();
            onRequestSuccess(budgetList);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }




/// detail list heading
  getTransReqDtlListHeadings(
      {  @required int rptId ,
        @required Function(TransactionReqHeading pendingLis ) onRequestSuccess,
        @required Function(AppException) onRequestFailure}) async {

    String xmlItem = XMLBuilder(

        tag: "List")
        .addElement(key: "RptFormatId ", value: "$rptId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(

      list:"EXEC-PROC",
      key:"resultObject",
      procName:"getreportengineformatsproc",
      actionFlag:"LIST",
      subActionFlag:"DYNAMICGRID",
      xmlStr: xmlItem,

    )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          TransactionReqHeading responseJson = TransactionReqHeading.fromJson(result);
          if (responseJson.statusCode == 1 &&
              result.containsKey('resultObject')) {
//            List budgetList = BaseJsonParser.goodList(result, 'resultObject')
//                .map((e) => TransactionUnblockListHeading.fromJson(e))
//                .toList();
            onRequestSuccess(responseJson);
          } else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }





  /// main boxes
  getTransactionReqinitList({
    int optionId,
    @required Function(List<TransactionUnblockReqInitModelList> pendingList) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    String service = "getdata";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value: "${optionId}" )
        .addElement(key: "Flag", value: "ALL")
        .buildElement();
    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "resultObject",
      xmlStr: xml,
      procName: "NotificationListProc",
      actionFlag: "LIST",
      subActionFlag: "SUMMARY",
    ).callReq();

    String url = "/ap/controller/cmn/getdropdownlist";

    TransactionUnblockReqInitType responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = TransactionUnblockReqInitType.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.transactionUnblockReqInitModelList)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage)
            )
        }
    );
  }


/// seach by filter usr
  getPendingTransactionsByFilterUser({
  int id,
  int selopt,
  int userId,
  int branchId,
    int optionId,
    String a,
    @required Function(List<TransactionUnblockReqInitModelList> pendingList) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    String service = "getdata";

     String xml = XMLBuilder(tag: "List")
         .addElement(key: "OptionId", value: "${optionId}")
         .addElement(key: "Flag ", value: "ALL")
         .addElement(key: "BranchId", value: "${branchId}")
         .buildElement();
    String axml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value:"${optionId}")
//        .addElement(key: "Flag", value: "ALL")
        .addElement(key: "UserId", value: "${userId}")
        .addElement(key: "BranchId", value: "${branchId}")
        .buildElement();

    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "resultObject",
      xmlStr: selopt==1?xml:axml,
      procName: "NotificationListProc",
      actionFlag: "LIST",
      subActionFlag: "SUMMARY",
    ).callReq();

    String url = "/ap/controller/cmn/getdropdownlist";

    TransactionUnblockReqInitType responseJson;

    print(jssArr);

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = TransactionUnblockReqInitType.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.transactionUnblockReqInitModelList)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage)
            )
        }
    );
  }


///  filter  users
  getUserlistTransactionsFilterusers({
    @required Function(List<UserObject> userObjectlist) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    String service = "getdata";

    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "userObj",
      xmlStr: "",
      procName: "userlistproc",
      actionFlag: "LIST",
      subActionFlag: "",
    ).callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    BranchUserListModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = BranchUserListModel.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.userObjectlist)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage)
            )
        }
    );
  }




  getBranchTransactionsReq({
    @required Function(List<BranchesList> branchObjlist) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int userId = await BasePrefs.getInt(USERID_KEY);
    String service = "getdata";

    String xmlDocApproval = XMLBuilder(tag: "List")
        .addElement(key: "OptionBusinessLevelCode", value: "FA")
        .addElement(key: "ParentBusinessLevelCode", value: "L2")
        .addElement(key: "UserId", value: "$userId")
        .buildElement();

    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "branchObj",
      xmlStr: xmlDocApproval,
      procName: "BusinessSubLevelProc",
      actionFlag: "LIST",
      subActionFlag: "OPT_USER_BUSINESS_LEVEL_FITER",
    ).callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    BranchUserListModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = BranchUserListModel.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.branchesList)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage)
            )
        }
    );
  }



  void saveTransactionUnblockRequest({
    int optionId,
    String actiontaken,
    String blockedreason,
    List<dynamic> selectedActnAgnUsers,
    int notificationid,
    int reftableid,
    int reftabledataid,
    String isblockedyn,
String blockeddate,

    @required Function(bool a) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  })async{
    int userId = await BasePrefs.getInt(USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    int companyId = await BasePrefs.getInt(BaseConstants.COMPANY_ID_KEY);
    int finyearID = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    String dateWithTime=BaseDates(DateTime.now()).dbformatWithTime;
    String dateWithOutTime=BaseDates(DateTime.now()).dbformat;
    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    // DateTime blocDate = DateTime.parse(blockeddate);
    DateFormat d = DateFormat('yyyy-MM-dd hh:mm:ss');
    DateTime blocDate = d.parse(blockeddate);
    String blocDateS = "$blocDate";
    String bDatewTime = BaseDates(blocDate).dbformatWithTime;

    String day = blockeddate.substring(0,2);
    String month = blockeddate.substring(3,5);
    String year = blockeddate.substring(6,10);
    String time = blockeddate.substring(11,19);

    String fullBlockedDate = "$year-$month-$day $time";

    print("BlockedDate: $fullBlockedDate");
    var dtllist = selectedActnAgnUsers.map((element) {
      return {
        "optionid": optionId,
        "personnelid": element.personnelid

      };
    }).toList();


    jsonArr = {
      "actiontaken": actiontaken,
      "amendedfromoptionid": optionId,
      "amendmentdate": dateWithTime,
      "amendmentno": 0,
      // "blockeddate": bDatewTime,
      "blockeddate": fullBlockedDate,
      "blockedreason": blockedreason,
      // "blockedreason": bDatewTime,
      "branchid": branchId,
      "checkListDataObj": [],
      "companyid": companyId,
      "createddate": dateWithTime,
      "createduserid": userId,
      "docAttachReqYN": false,
      "docAttachXml": "",
      "dtlDtoList": dtllist,
      "extensionDataObj": [],
      "finyearid": finyearID,
      "isblockedyn": isblockedyn,
      "notificationid": notificationid,
      "optionid": optionId,
      "recordstatus": "A",
      "reftabledataid": reftabledataid,
      "reftableid": reftableid,
      "requestdate": dateWithTime,
      "screenFieldDataApprovalInfoObj": [],
      "screenNoteDataObj": []

    };
//    jsonArr["dtlDtoList"] = [];
//    jsonArr["checkListDataObj"] = [],
//    jsonArr["extensionDataObj"] = [],
//    jsonArr["screenNoteDataObj"] = [],
//    jsonArr["screenFieldDataApprovalInfoObj"] = [],
    String service = "putdata";
   String url = "/security/controller/trn/tranctonUnblkRqstsave";
    var request = json.encode(jsonArr);

    List jssArr = List();
    jssArr.add(request);
    print(jssArr);
    BaseResponseModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        uuid: 0,
        userid: 0,
        chkflag: "N",
        compressdyn: false,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = BaseResponseModel.fromJson(result),
          if (responseJson.statusMessage.contains("Success") &&
              responseJson.result)
            onRequestSuccess( responseJson.result)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage))
        });
  }



  getActionTakenAgainstwhom(
      {@required int start,
        int sor_Id,
        int eor_Id,
        int totalRecords,
        int value ,
        int FinYearId,
        @required Function(List<ActionTakenAgainstwhom> items) onRequestSuccess,
        @required Function(AppException) onRequestFailure}) async {
    int finyearID = await BasePrefs.getInt(BaseConstants.FIN_YEAR_KEY);
    // String ssnId = await BasePrefs.getString(SSNIDN_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "FinYearId", value: "$finyearID")
        .buildElement();

    String service = "getdata";

    var jsonArr = {
      "flag":"ALL",
      "SOR_Id":sor_Id,
      "EOR_Id":eor_Id,
      "TotalRecords":totalRecords,
      "start":"0",
      "limit":"500",
      "value":"0",
      "colName":"description",
      "params":[],
      "dropDownParams": [
        {
          "list":"ITEM-LOOKUP",
          "key":"resultObject",
          "procName":"PersonnelMstProc",
          "actionFlag":"LIST",
          "subActionFlag":"",
          "xmlStr":xml,

        }
      ]
    };
    if (sor_Id != null) jsonArr["SOR_Id"] = sor_Id;
    if (eor_Id != null) jsonArr["EOR_Id"] = eor_Id;
    if (totalRecords != null) jsonArr["TotalRecords"] = totalRecords;

    String url = "/security/controller/cmn/getdropdownlist";

    ActionTakenAgainstwhomm responseJson;
    performRequest(
        jsonArr: [json.encode(jsonArr)],
        service: service,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = ActionTakenAgainstwhomm.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.actionTakenAgainstwhom)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage))
        });
  }



  getBranchNotificaion_TransactionReqinitList({
    int optionId,int brachId,
    @required Function(List<TransactionUnblockReqInitModelList> pendingList) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")


          //  .addElement(key: "UserId", value: "$userId")
        .addElement(key: "Flag", value: "ALL")
        .addElement(key: "BranchId", value: "${brachId}")
        .buildElement();
    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "resultObject",
      xmlStr: xml,
      procName: "NotificationListProc",
      actionFlag: "LIST",
      subActionFlag: "SUMMARY",
    ).callReq();

    String url = "/ap/controller/cmn/getdropdownlist";

    TransactionUnblockReqInitType responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = TransactionUnblockReqInitType.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.transactionUnblockReqInitModelList)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage)
            )
        }
    );
  }


  getAllBranchFilter({
  int optionId,int userId,bool allbranBYUser,
    @required Function(List<TransactionUnblockReqInitModelList> pendingList) onRequestSuccess,
    @required Function(AppException exception) onRequestFailure,
  }) async {
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value: "${optionId}")
        .addElement(key: "Flag ", value: "ALL")
        .buildElement();
    String axml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value:"${optionId}")
        .addElement(key: "UserId", value: "${userId}")

        .buildElement();

    List jssArr = DropDownParams().addParams(
      list:"EXEC-PROC",
      key: "resultObject",
      xmlStr: allbranBYUser==true?axml:xml,
      procName: "NotificationListProc",
      actionFlag: "LIST",
      subActionFlag: "SUMMARY",
    ).callReq();

    String url = "/ap/controller/cmn/getdropdownlist";

    TransactionUnblockReqInitType responseJson;

    print(jssArr);

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
          responseJson = TransactionUnblockReqInitType.fromJson(result),
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.transactionUnblockReqInitModelList)
          else
            onRequestFailure(
                InvalidInputException(responseJson.statusMessage)
            )
        }
    );
  }













}

