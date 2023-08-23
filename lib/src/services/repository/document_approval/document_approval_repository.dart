import 'dart:convert';
import 'dart:developer';

import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_detail_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/document_attachments.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_history.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_status.dart';
import 'package:redstars/src/utils/app_dates.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/document_approval_model.dart';

class DocumentApprovalRepository extends BaseRepository {
  static final DocumentApprovalRepository _instance =
      DocumentApprovalRepository._();

  DocumentApprovalRepository._();

  factory DocumentApprovalRepository() => _instance;

  getTransactionList(
      {int selectedBranchId,
      @required
          Function(TransactionTypeModel pendingList, int statusCode)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    int userId = await BasePrefs.getInt(USERID_KEY);
    String service = "getdata";
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    log("BranchId at  repos level is $selectedBranchId");
    String xmlDocApproval = XMLBuilder(tag: "List")
        .addElement(key: "TableCode", value: "DOC_APPRVL_STATUS")
        .addElement(key: "CompanyId", value: "$companyId")
        .buildElement();
    bool isSuperUser = await BasePrefs.getBool(BaseConstants.SUPER_USER_KEY);

    XMLBuilder xmlTransactionItems =
        XMLBuilder(tag: "List").addElement(key: "UserId", value: "$userId");
    if (selectedBranchId != 0) {
      xmlTransactionItems.addElement(
          key: "BranchId", value: "$selectedBranchId");
    }
    xmlTransactionItems.addElement(
        key: "SuperUserYN", value: isSuperUser ? "Y" : "N");

    List jssArr = DropDownParams()
        .addParams(
            list: "BAYACONTROLCODES-DROPDOWN",
            key: "resultApprovalTypes",
            xmlStr: xmlDocApproval,
            procName: "bayacontrolcodelistproc",
            actionFlag: "LIST",
            subActionFlag: "")
        .addParams(
            list: "EXEC-PROC",
            key: "resultTransactionTypes",
            xmlStr: xmlTransactionItems.buildElement(),
            procName: "DocumentApprovalPendingListProc",
            actionFlag: "LIST",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    TransactionTypeModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = TransactionTypeModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson, responseJson.statusCode)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  setNotificationAsRead(
      {var optionId,
      var transTableId,
      var transId,
      var notificationId,
      var subtypeId,
        int selectedBranchId,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    String xmlList = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$notificationId")
        .addElement(key: "SubTypeId", value: "$subtypeId")
        .addElement(key: "TransTableId", value: "$transId")
        .addElement(key: "TransId", value: "$transTableId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "${branchId}")
        .addElement(
          key: "NotificationOptionId",
          value: "$optionId",
        )
        .buildElement(appendFlag: false);

    xmlList = xml.replaceAll("> </List>", "/>");

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "COUNT_UPDATE",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          var responseJson = NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess();
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  callWhenApproved(
      {@required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String xmlList = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(
          key: "FilterFlag",
          value: "APPROVE",
        )
        .buildElement(appendFlag: false);

    xmlList = xml.replaceAll("> </List>", "/>");

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "COUNT_UPDATE",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;
    String service = "getdata";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          var responseJson = NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess();
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getUnreadList(
      {int optionId,
      int notificationId,
      int selectedBranchId,
      int subtypeId,
      @required Function(List<UnreadNotificationListModel>) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    ///discussed with backend dev 'BranchId' is set to login branchid as always
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

    String xmlList = "";
    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$notificationId")
        .addElement(key: "SubTypeId", value: "$subtypeId")
        .addElement(key: "ClientId", value: "$clientId")
        .addElement(key: "BranchId", value: "${branchId}")
        .addElement(key: "NotificationOptionId", value: "$optionId")
        .buildElement(appendFlag: false);

    xmlList = xml.replaceAll("> </List>", "/>");

    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "TRANS_READSTATUS",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    String service = "getdata";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          UnreadNotificationList responseJson =
              UnreadNotificationList.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.notificationUnread);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getNotificationCount(
      {@required
          int userId,
      int selectedBranchId,
      int optionID,
      @required
          String clientId,
      @required
          Function(List<NotificationCountDetails> notificationDtls)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String clientId1 = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId1 = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    log("BranchId at  repos level is $selectedBranchId");
    String service = "getdata";
    String xmlList = "";
    String xmlremovedLasttag1 = "";
    String xml1 = XMLBuilder(tag: "List")
        .addElement(key: "Flag", value: "TRANS_OPTION_WISE")
        .addElement(key: "NotificationOptionId ", value: "${optionID ?? 1}")
        .buildElement(appendFlag: false);

    String xml2;

    if(selectedBranchId !=0 ){
      xml2 = XMLBuilder(tag: "User")
        .addElement(key: "Clientid ", value: "$clientId1")
        .addElement(key: "UserId ", value: "${userId1 ?? 1}")
        .addElement(key: "BranchId ", value: "${branchId}")
        .addElement(key: "FilteredBranchId ", value: "${selectedBranchId}")
        .buildElement(appendFlag: false);

    }else{
      xml2 = XMLBuilder(tag: "User")
          .addElement(key: "Clientid ", value: "$clientId1")
          .addElement(key: "UserId ", value: "${userId1 ?? 1}")
          .addElement(key: "BranchId ", value: "${branchId}")

          .buildElement(appendFlag: false);

    }

    xmlList = xml2.replaceAll("> </User>", "/>");
    xmlremovedLasttag1 = xml1.replaceAll("> </List>", "/>");
    List jssArr = DropDownParams()
        .addParams(
            list: "EXEC-PROC",
            key: "resultObject",
            xmlStr: xmlremovedLasttag1 + xmlList,
            procName: "MobileNotificationProc",
            actionFlag: "NOTIFICATION_COUNT",
            subActionFlag: "")
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    Map<String, dynamic> logParams = Map();
    logParams["jsonArr"] = jssArr;
    logParams["url"] = url;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          NotificationCountDetailsModel responseJson =
              NotificationCountDetailsModel.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.notificationCount);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });

    // try {
    //   HttpRequestHelper httpRequest = HttpRequestHelper(
    //       service: service,
    //       requestParams: logParams,
    //       onRequestFailure: onRequestFailure,
    //       onRequestSuccess: (result) {
    //         NotificationCountDetailsModel responseJson =
    //         NotificationCountDetailsModel.fromJson(result);
    //         if (responseJson.statusCode == 1)
    //           onRequestSuccess(responseJson.notificationCount);
    //         else
    //           onRequestFailure(
    //               InvalidInputException(responseJson.statusMessage));
    //       }
    //       );
    //
    //   PostServiceHelper(httpRequest: httpRequest).postRequest();
    // } catch (e) {
    //   {
    //     onRequestFailure(InvalidInputException(e.toString()));
    //     print(e.toString());
    //   }
    // }
  }

  getBranchList(
      {@required Function(BranchListModel branchList) onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    String service = "getdata";
    List jssArr = DropDownParams()
        .addParams(
            list: "BRANCH",
            key: "branchDetails",
            xmlStr: "",
            procName: "",
            actionFlag: "",
            subActionFlag: "")
        .callReq();
    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          BranchListModel responseJson = BranchListModel.fromJson(result);
          responseJson.branchList.add(BranchList(name: "All Branches",id: 0,code: "ALL"));
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getPendingItemList(
      {@required
          int optionId,
      @required
          int subtypeId,
      int branchId,
      @required
          Function(PendingItems pendingItemList, int statusCode)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure,
      BranchList branch}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    String service = "getdata";
    bool isSuperUser = await BasePrefs.getBool(BaseConstants.SUPER_USER_KEY);
    // int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    log("Pending list branchid "+branchId.toString());
    log("Pending list optionId "+optionId.toString());
    int userId = await BasePrefs.getInt(USERID_KEY);

    XMLBuilder builder = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "SubTypeId", value: "$subtypeId");
    if (branchId != 0) {
      builder.addElement(key: "BranchId", value: "${branchId}");
    }
    // else {
    // builder.addElement(key: "BranchId", value: "$branchId");
    // }
    builder.addElement(key: "SuperUserYN", value: isSuperUser ? "Y" : "N");

    String xml = builder.buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "DocumentApprovalProc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    print(jssArr);
    PendingApprovals responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PendingApprovals.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.itemList, responseJson.statusCode)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getAttachments(
      {int optionId,
      int transactionId,
      int tableId,
      Function(List<Attachments>) onRequestSuccess,
      Function(AppException) onRequestFailure}) async {
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "TableId", value: "$tableId")
        .addElement(key: "DataId", value: "$transactionId")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "DocumentApprovalProc",
          actionFlag: "DOCUMENTS",
          subActionFlag: "",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) {
          DocumentAttachments responseJson =
              DocumentAttachments.fromJson(result);
          if (responseJson.statusCode == 1)
            onRequestSuccess(responseJson.attachments);
          else
            onRequestFailure(InvalidInputException(responseJson.statusMessage));
        });
  }

  getTransactionDetails(
      {@required
          int optionId,
      @required
          int transactionId,
      @required
          String procName,
      @required
          String actionFlag,
      @required
          String subActionFlag,
      @required
          Function(List<TransactionDtlApproval> pendingItemDtlList)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    int companyId = await BasePrefs.getInt(COMPANY_ID_KEY);
    String service = "getdata";

    int userId = await BasePrefs.getInt(USERID_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "TransId", value: "$transactionId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "$procName",
          actionFlag: "$actionFlag",
          subActionFlag: "$subActionFlag",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";
    print(jssArr);
    PendingTransactionDtlModel responseJson;
    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = PendingTransactionDtlModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.dtlList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getReportFormat(
      {int optionId,
      TransactionTypes transaction,
      Function(ReportModel transactionStatus) onRequestSuccess,
      Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();

    String summaryXml = xml +
        XMLBuilder(tag: "ReporFormat")
            .addElement(
                key: "FormatCode", value: "${transaction.optionCode}_SMY")
            .buildElement();
    String detailXml = xml +
        XMLBuilder(tag: "ReporFormat")
            .addElement(
                key: "FormatCode", value: "${transaction.optionCode}_DTL")
            .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "getreportengineformatsproc",
          actionFlag: "LIST",
          subActionFlag: "DYNAMICGRID",
          xmlStr: summaryXml,
          key: "resultSummaryFormat",
        )
        .addParams(
          list: "EXEC-PROC",
          procName: "getreportengineformatsproc",
          actionFlag: "LIST",
          subActionFlag: "DYNAMICGRID",
          xmlStr: detailXml,
          key: "resultDetailFormat",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    ReportModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = ReportModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getTransactionStatus(
      {int optionId,
      int transactionId,
      Function(List<TransactionStatus> transactionStatus) onRequestSuccess,
      Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "Transaction")
        .addElement(key: "Id", value: "$transactionId")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "TransactionStatusReportProc",
          actionFlag: "REPORT",
          subActionFlag: "STATUS",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    TransactionStatusModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = TransactionStatusModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.transactionStatusList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  saveDocuments(
      {DocumentApprovalModel approvalModel,
      List<DocumentApprovalModel> mutisaveModel,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "putdata";
    String url = "/security/controller/trn/savedocumentapprovalhistoryinfo";

    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    String userName = await BasePrefs.getString(USERNAME_KEY);
    String password = await BasePrefs.getString(PASSWORD_KEY);
    int userID = await BasePrefs.getInt(USERID_KEY);

    approvalModel.userId = userID;
    approvalModel.username = userName;
    approvalModel.password = password;

    List<Map<String, dynamic>> data = [];
    data.add(approvalModel.toMap());
    var dtlDto = (approvalModel.toMap());
    print(dtlDto.toString());
    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";
    jsonArr["dtlDtoList"] = [dtlDto];
    jsonArr["extensionDataObj"] = List();
    jsonArr["screenNoteDataObj"] = List();
    jsonArr["screenFieldDataApprovalInfoObj"] = List();
    jsonArr["checkListDataObj"] = List();
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
              if (responseJson.statusMessage.contains("Success"))
                onRequestSuccess()
              else
                onRequestFailure(UnnamedException(responseJson.statusMessage))
            });
  }

  multiSaveDocuments(
      {DocumentApprovalModel approvalModel,
      List<DocumentApprovalModel> multiSaveModel,
      List<TransactionDetails> transList,
      List<TransactionDtlApproval> selectionReportData,
      DocumentConfigDtl configDtl,
      ReportFormatDtlModel rptmodel,
      DocumentApprDetailViewModel viewModel,
      int approvalStsId,
      int userApprSts,
      int subTypeId,
      ApprovalsTypes approvalsTypes,
      List<ApprovalsTypes> approvalsTypesList,
      TransactionTypes selectedOption,
      @required Function() onRequestSuccess,
      @required Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "putdata";
    String url = "/security/controller/trn/savedocumentapprovalhistoryinfo";

    Map<String, dynamic> jsonArr = Map<String, dynamic>();
    String userName = await BasePrefs.getString(USERNAME_KEY);
    String password = await BasePrefs.getString(PASSWORD_KEY);
    int userID = await BasePrefs.getInt(USERID_KEY);

    // multiSaveModel[i].userId = userID;
    // multiSaveModel[i].username = userName;
    // multiSaveModel[i].password = password;

    ApprovalsTypes getApprovalType(int id) {
      ApprovalsTypes type;
      approvalsTypesList.forEach((element) {
        if (element.id == id) {
          type = element;
          return;
        }
      });
      return type;
    }

    ApprovalsTypes approvalRec = null;
    ApprovalsTypes rejectionRec = null;

    approvalsTypesList.forEach((element) {
      if (element.code == "APPROVED") {
        approvalRec = element;
      } else if (element.code == "REJECTED") rejectionRec = element;
    });

    int userapprovalbccid = approvalRec != null ? approvalRec.id : null;
    int userrejectionbccid = rejectionRec != null ? rejectionRec.id : null;

    ApprovalsTypes userApprovalStatus = getApprovalType(approvalStsId);
    // ApprovalsTypes userApprovalStatus = viewModel.getApprovalType(approvalStsId);
    // viewModel.getDocConfigByType(
    //     bccId: transList.first.maxLevelId,
    //     approveorrejectid: userApprovalStatus.id,
    // );
    print("ko--$userApprovalStatus");
    // List<Map<String, dynamic>> data = [];
    // data.add(multiSaveModel[i].toMap());
    // var dtlDto = (multiSaveModel[i].toMap());
    // print(dtlDto.toString());

    // viewModel.transactionApprDTL.forEach((element) {
    var dtlapprovalary = [];
    // if(selectionReportData != null){
    //   dtlapprovalary = [
    //     {
    //     "table" : element.table,
    //     "dtldataid" : element.dtlDataId,
    //     "appyn" : element.selected,
    //     "editcol" : rptmodel?.dataIndex ?? "",
    //   }
    //   ];
    // }
    approvalsTypesList.forEach((element) {
      jsonArr["dtlDtoList"] = transList
          .map((dtlDtoList) => {
                "dtltablename": null,

                // viewModel.transactionDtlTableName,
                "emailonapprovalreqyn": "N",
                "Id": 0,
                "iscancelledyn": "N",
                "lastapprovallevelbccid": dtlDtoList.maxLevelId,
                "lastapprovallevelminipersontoapprove": dtlDtoList.maxLevelId ==
                        viewModel?.documentConfigDtl?.first?.levelNoBccid
                    ? viewModel?.documentConfigDtl?.first?.minPersonToApprove
                    : null,
                "levelno": dtlDtoList.levelTypeBccId,
                "leveltypebccid": dtlDtoList.levelTypeBccId,
                "minimumpersonstoapproveorreject": dtlDtoList.maxLevelId ==
                            viewModel?.documentConfigDtl?.first?.levelNoBccid ??
                        0
                    ? viewModel?.documentConfigDtl?.first?.minPersonToApprove
                    : 0,
                "optionid": viewModel.optionId,
                "subtypeId": subTypeId,
                "password": password.toString(),
                "recordsatus": "A",
                "mobile": true,
                "refoptionid": viewModel?.refOptionId,
                "reftabledataid": dtlDtoList.refTableDataId,
                "reftableid": dtlDtoList.refTableId,
                "smsonapprovalreqyn": approvalModel?.smsOnApproval ?? "N",
                "statusdate":
                    AppDates(DateTime.now()).customFormat(format: "dd-mm-yyyy"),
                "tablename": viewModel.tableName,
                "translastmoddate": dtlDtoList.transLastModDate,
                "useractionbccid": viewModel.useractionid,
                "userapprovalbccid": userapprovalbccid,
                "userid": userID,
                "username": userName,
                "userrejectionbccid": userrejectionbccid,
                "userremarks": "",
                "dtlapprovalary": dtlapprovalary,
              })
          .toList();
    });
    // });

    jsonArr["docAttachReqYN"] = false;
    jsonArr["docAttachXml"] = "";
    jsonArr["extensionDataObj"] = List();
    jsonArr["screenNoteDataObj"] = List();
    jsonArr["screenFieldDataApprovalInfoObj"] = List();
    jsonArr["checkListDataObj"] = List();
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
              if (responseJson.statusMessage.contains("Success"))
                onRequestSuccess()
              else
                onRequestFailure(UnnamedException(responseJson.statusMessage))
            });
  }

  getTransactionTracking(
      {int optionId,
      int dataId,
      @required
          Function(List<TransactionHistoryList> transactionStatus)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DataId", value: "$dataId")
        .addElement(key: "OptionId", value: "$optionId")
        .buildElement();
    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "transactiontrackinglistproc",
          actionFlag: "LIST",
          subActionFlag: "Tracking_Dtl",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    TransactionHistoryModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = TransactionHistoryModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.transactionHistList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getTransactionsApprovals(
      {int optionId,
      int dataId,
      int tableId,
      @required
          Function(List<TransactionApprovalList> transactionStatus)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";

    int userId = await BasePrefs.getInt(USERID_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "DataId", value: "$dataId")
        .addElement(key: "OptionId", value: "$optionId")
        .addElement(key: "UserId", value: "$userId")
        .addElement(key: "TableId", value: "$tableId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "DocumentApprovalProc",
          actionFlag: "APPROVAL_HISTORY",
          subActionFlag: "",
          xmlStr: xml,
          key: "resultObject",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    TransactionHistoryModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = TransactionHistoryModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.transactionApprList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }

  getTransactionCheck(
      {int optionId,
      int dataId,
      int tableId,
      int transId,
      @required
          Function(List<TransactionApprovalList> transactionStatus)
              onRequestSuccess,
      @required
          Function(AppException exception) onRequestFailure}) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String service = "getdata";

    int userId = await BasePrefs.getInt(USERID_KEY);

    String xml = XMLBuilder(tag: "List")
        .addElement(key: "TransId", value: "$transId")
        .addElement(key: "OptionId", value: "$optionId")
        // .addElement(key: "UserId", value: "$userId")
        // .addElement(key: "TableId", value: "$tableId")
        .buildElement();

    List jssArr = DropDownParams()
        .addParams(
          list: "EXEC-PROC",
          procName: "DocumentApprovalTransactionWiseDtlProc",
          actionFlag: "LIST",
          subActionFlag: "",
          xmlStr: xml,
          key: "dtls",
        )
        .callReq();

    String url = "/security/controller/cmn/getdropdownlist";

    TransactionHistoryModel responseJson;

    performRequest(
        service: service,
        jsonArr: jssArr,
        url: url,
        onRequestFailure: onRequestFailure,
        onRequestSuccess: (result) => {
              responseJson = TransactionHistoryModel.fromJson(result),
              if (responseJson.statusCode == 1)
                onRequestSuccess(responseJson.transactionApprList)
              else
                onRequestFailure(
                    InvalidInputException(responseJson.statusMessage))
            });
  }
}
