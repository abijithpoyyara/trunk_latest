import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_detail_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_detail_viewmodel.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/dataJsonModel.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/data_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/fetch_bccId_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/alert_message_dialog.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';

class DocumentApprovalNotification extends StatefulWidget {
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  var approvalOptionCode;
  var approvalOptnName;
  var subTypeId;
  var clientIdFrmNoti;
  bool onUserClick;
  DocumentApprovalNotification(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.subTypeId,
      this.approveOptionId,
      this.approvalOptionCode,
      this.approvalOptnName,
      this.clientIdFrmNoti,
      this.onUserClick});

  @override
  _DocumentApprovalNotificationState createState() =>
      _DocumentApprovalNotificationState(
          optionId: optionId,
          transTableId: transTableId,
          transId: transId,
          subTypeId: subTypeId,
          approveOptionId: approveOptionId,
          approvalOptionCode: approvalOptionCode,
          approvalOptnName: approvalOptnName,
          clientIdFrmNoti: clientIdFrmNoti,
          onUserClick: onUserClick);
}

class _DocumentApprovalNotificationState
    extends State<DocumentApprovalNotification> {
  var transTableId;
  var transId;
  var subTypeId;
  var clientIdFrmNoti;
  List transactionList;
  List documentList;
  List alertList;
  int lastApproval;
  var optionId;
  var approveOptionId;
  bool onUserClick;
  String responseMessage = 'Oops! Something went wrong!';
  int dataListLength = 0;
  int maxLevel;
  int levelnobccid;
  int lastApprovalTest;
  var approvalOptionCode;
  var approvalOptnName;
  _DocumentApprovalNotificationState(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.subTypeId,
      this.approveOptionId,
      this.approvalOptionCode,
      this.approvalOptnName,
      this.clientIdFrmNoti,
      this.onUserClick});

  String transTableName;
  var dtltablereryn;
  String tableName;
  String _remarks;
  final bool reject = true;
  String emailProvision;
  String smsProvision;
  int refOptionId;
  int refTableId;
  int reftabledataid;
  int leveltypebccid;
  int maxlevelid;
  int minPersonToApprove;
  int clickedBccId;
  int approveBccId;
  int rejectBccId;
  String userName;
  String password;
  String clientId;
  var editcol;
  var editcolval;
  int userId;
  FetchBccIdModel fetchBccIdModel;
  DataModel dataModel;
  String currentDate;
  String currentDateTime;
  String prefClientId;

  String initialValue;
  String hint = "Enter Remarks";
  String displayTitle = "Remarks";
  Function(String val) validator;
  Function(String val) onSaved;
  bool isPassword = false;
  bool isSuccess = false;
  List<DataModel> dataList;
  List<DataModel> dtlList;
  List<List<DataModel>> dtlTransList = [];
  DataJsonModel dataJsonModel;
  Map<String, dynamic> node;
  bool approveyn;
  int dtldataid;
  String dtltablename;

  String procName;
  String actionFlag;
  String subActionFlag;
  var detailTransactionData;
  List<dynamic> isDtl;
  var finalizedOptName;
// onSaved: (data) => _remarks = data;

  List headingList;
  List valueList;
  String dtlstring;
  bool prefLoaded=false;
  List<DataModel> list1 = [];

  @override
  void initState() {
    getPrefs();
    isNotificationScreenClosed = false;
    super.initState();
  }

  getPrefs() async {
    prefClientId = await BasePrefs.getString("notifCompany");
    prefLoaded=true;
    userName = await BasePrefs.getString(BaseConstants.USERNAME_KEY);
    password = await BasePrefs.getString(BaseConstants.PASSWORD_KEY);
    userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    if (clientId == widget.clientIdFrmNoti) {
    if(prefClientId !="" && prefClientId!=null){
    await fetchBccId();
    await fetchItemData();
    }
    } else {
      showAlertMessageDialog(
          context, "Please login or switch the company to approve!", "Alert",
          () {
        Navigator.pop(context);
      });
    }
  }

  showLoaderDialog(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    AlertDialog alert = AlertDialog(
      backgroundColor: themeData.scaffoldBackgroundColor,
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                ThemeProvider.of(context).primaryColor),
          ),
          SizedBox(
            width: 25,
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future fetchItemData() async {
    if (mounted) showLoaderDialog(context);
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');
    var body = {
      'jsonArr': '[{\"dropDownParams\":[{\"list\":\"EXEC-PROC\",\"key\":\"resultObject\",'
          '\"procName\":\"MobileNotificationProc\",\"actionFlag\":\"LIST\",\"subActionFlag\":\"\",'
          '\"xmlStr\":\"<List UserId  = \\\"$userId\\\" OptionId = \\\"$optionId \\\" '
          'TransTableId = \\\"$transTableId\\\" TransId = \\\"$transId\\\" SubTypeId = \\\"$subTypeId\\\" >'
          ' </List>\"}]}]',
      'url': '/security/controller/cmn/getdropdownlist',
      'ssnidn': '$ssnId'
    };
    String url = Connections().generateUri() + 'getdata';
    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };
    log('DATA body: $body');
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (mounted) Navigator.pop(context);
    print('Response status: ${response.statusCode}');
    if (response.body.contains("ERROR")) {
      var jsonResponse = json.decode(response.body);
      node = jsonResponse;
      String statusMsg = node["statusMessage"];

      showAlertMessageDialog(context, "",
          "${statusMsg.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
          () {
        if (mounted) Navigator.pop(context);
        /*Navigator.popUntil(
            context, (Route<dynamic> route) => route.isFirst);*/
      });
    }
    log('Response body DATAS##: ${response.body}');
    if (response.body.contains("No Error")) {
      var jsonResponse = json.decode(response.body);
      node = jsonResponse;
      print("node$node");
      int i = 0;
      detailTransactionData =
          node["resultObject"][0]["transactiondtl"][0]["dtls"];
      var transDtl = node["resultObject"][0]["transactiondtl"][0];
      print(detailTransactionData);
      print(transDtl);
      //  var nodeDtlString = node["resultObject"][0]["reportformatdtl"][0]["dtl"];
      var nodeTransactionString =
          node["resultObject"][0]["transactiondtl"][0]["transactiondtl"][0];
      var nodeDtlString = node["resultObject"][0]["reportformatdtl"][0]["dtl"];
      isDtl = node["resultObject"][0]["reportformatdtl"];
      isDtl.length > 1 ? print("length----1") : print("length0");

      var dtlSection = (isDtl.length > 1)
          ? node["resultObject"][0]["reportformatdtl"][1]["dtl"]
          : null;
      print(dtlSection);
      for (var item in nodeDtlString) {
        if (nodeTransactionString.containsKey(item["dataindex"])) {
          item["value"] = nodeTransactionString[item["dataindex"]];
        }
        if (nodeTransactionString.containsKey(item["align"])) {
          item["align"] = nodeTransactionString[item["dataindex"]];
        }
        if (nodeTransactionString.containsKey(item["isvisibleyn"])) {
          item["isvisibleyn"] = nodeTransactionString[item["dataindex"]];
        }
      }
      if (dtlSection != null)
        for (var data in dtlSection) {
          if (data["isdrilldowncolumnyn"] == "Y") {
            editcol = data["dataindex"];
            print("isdrilldownyn------$editcol");
          }
        }
      if (detailTransactionData != null)
        for (var sec in detailTransactionData) {
          if (sec.containsKey(editcol) == true) {
            editcolval = sec[editcol];
            print("editcol---$editcolval");
          }
        }

      if (dtlSection != null)
        //var dtlData;

        for (var dtlTrans in detailTransactionData) {
          for (var item in dtlSection) {
            if (dtlTrans.containsKey(item["dataindex"])) {
              item["value"] = dtlTrans[item["dataindex"]];
            }
            if (dtlTrans.containsKey(item["align"])) {
              item["align"] = dtlTrans[item["dataindex"]];
            }
            if (dtlTrans.containsKey(item["isvisibleyn"])) {
              item["isvisibleyn"] = dtlTrans[item["dataindex"]];
            }
          }
          var jsResult = jsonEncode(dtlSection);
          log(jsResult);

          if (jsResult != null) {
            Iterable k = json.decode(jsResult);
            dtlList = k != null
                ? List<DataModel>.of(
                    k.map((model) => DataModel.fromJson(model)))
                : null;
            dtlTransList?.add(dtlList);
            print("dtlTranList-----$dtlTransList");
          }
        }
      if (mounted) setState(() {});
      print(nodeDtlString);

      var jsonResult = jsonEncode(nodeDtlString);
      log(jsonResult);
      if (mounted)
        setState(() {
          Iterable l = json.decode(jsonResult);
          dataList =
              List<DataModel>.from(l.map((model) => DataModel.fromJson(model)));
        });

      print(dtlSection);
      var jsResult = jsonEncode(dtlSection);
      log(jsResult);

      if (jsResult != null) {
        if (mounted)
          setState(() {
            Iterable k = json.decode(jsResult);
            dtlList = k != null
                ? List<DataModel>.of(
                    k.map((model) => DataModel.fromJson(model)))
                : null;
            //dtlList.add(dtlList.elementAt(0));
          });
      } else {
        print("No detail part for the transaction");
      }
      print('###########DATA LIST :: $dataList');
      //print('###########DETAIL LIST :: $dtlList');

      currentDateTime = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['translastmoddate'];

      dataListLength = dataList?.length;

      tableName =
          jsonResponse["resultObject"][0]["transactiondtl"][0]["tablename"];
      dtltablereryn = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]["dtltablereqyn"];
      print("dtltablereryn   ----$dtltablereryn");
      transTableName = dtltablereryn == 'N'
          ? null
          : jsonResponse["resultObject"][0]["transactiondtl"][0]
              ["transactiondtltablename"];
      optionId =
          jsonResponse["resultObject"][0]["transactiondtl"][0]["optionid"];
      transactionList = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"];
      documentList = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["documentconfigdtl"];
      procName = jsonResponse["resultObject"][0]["reportformatdtl"][0]
          ["procedurename"];
      actionFlag =
          jsonResponse["resultObject"][0]["reportformatdtl"][0]["actionflg"];
      subActionFlag =
          jsonResponse["resultObject"][0]["reportformatdtl"][0]["subflag"];
      alertList = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["alertconfigdtl"];
      // if (jsonResponse["resultObject"][0]["transactiondtl"][0]["transactiondtl"]
      //         [0]['maxlevel'] ==
      //     jsonResponse["resultObject"][0]["transactiondtl"][0]
      //         ["documentconfigdtl"][0]['levelnobccid']) {
      //   lastApproval = jsonResponse["resultObject"][0]["transactiondtl"][0]
      //       ["documentconfigdtl"][0]['minpersontoapprove'];
      // }

      maxLevel = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['maxlevelid'];
      levelnobccid = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["documentconfigdtl"][0]['levelnobccid'];
      lastApprovalTest = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["documentconfigdtl"][0]['minpersontoapprove'];
      dtldataid = isDtl.length > 1
          ? jsonResponse["resultObject"][0]["transactiondtl"][0]["dtls"][0]
              ["dtldataid"]
          : 0;
      print("dtldataid----${dtldataid}");
      dtltablename = isDtl.length > 1
          ? jsonResponse["resultObject"][0]["transactiondtl"][0]["dtls"][0]
              ["table"]
          : null;
      print("dtltablename----${dtltablename}");

      refOptionId = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['optionid'];
      refTableId = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['reftableid'];
      reftabledataid = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['reftabledataid'];
      leveltypebccid = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['leveltypebccid'];
      maxlevelid = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["transactiondtl"][0]['maxlevelid'];

      minPersonToApprove = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["documentconfigdtl"][0]['minpersontoapprove'];

      emailProvision = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["alertconfigdtl"][0]['emailprovisionrequireyn'];
      smsProvision = jsonResponse["resultObject"][0]["transactiondtl"][0]
          ["alertconfigdtl"][0]['smsprovisionrequireyn'];

      var maxLv =
          node["resultObject"][0]["transactiondtl"][0]["transactiondtl"][0];
      var LevelBc = node["resultObject"][0]["reportformatdtl"][0]["dtl"];
      for (var item in LevelBc) {
        if (nodeTransactionString.containsKey(item["dataindex"])) {
          item["value"] = nodeTransactionString[item["dataindex"]];
        }
      }

      print('LAST APPROVAL :::: $maxLevel,$levelnobccid,$lastApprovalTest');

      // for(int i=0;i<documentList.length;i++){
      //   if(node["resultObject"][0]["transactiondtl"][0]["transactiondtl"]
      //   [0]['maxlevelid'] == node["resultObject"][0]["transactiondtl"][0]
      //   ["documentconfigdtl"][i]["levelnobccid"]) {
      //     lastApproval =node["resultObject"][0]["transactiondtl"][0]
      //     ["documentconfigdtl"][i]["minpersontoapprove"];
      //   }
      // }

      // if(maxLevel == levelnobccid){
      //   //lastApproval = lastApprovalTest;
      //   lastApproval = jsonResponse["resultObject"][0]["transactiondtl"][0]
      //   ["documentconfigdtl"][0]['minpersontoapprove'];
      //   print(lastApproval);
      //   print('##########lastApproval  not null');
      //
      // } else {
      //   print('##########lastApproval is null');
      // }
      print('##########lastApproval# :: $lastApproval');
    }
    // else {
    //   final snackBar = SnackBar(
    //       backgroundColor: ThemeProvider.of(context).primaryColor,
    //       content: Text(
    //         '$responseMessage',
    //         style: TextStyle(color: ThemeProvider.of(context).accentColor),
    //       ));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  Future fetchUpdateCountCall() async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');

    var body = {
      'jsonArr':
          '[{\"dropDownParams\":[{\"list\":\"EXEC-PROC\",\"key\":\"resultObject\",\"procName\":\"MobileNotificationProc\",\"actionFlag\":\"COUNT_UPDATE\",\"subActionFlag\":\"\",\"xmlStr\":\"<List UserId = \\\"$userId\\\" OptionId = \\\"$optionId\\\" TransTableId = \\\"$transTableId\\\" TransId = \\\"$transId\\\" ClientId = \\\"$clientId\\\" NotificationOptionId = \\\"$approveOptionId\\\" RequestFrom = \\\"Mobile\\\"> </List>\"}]}]',
      'url': '/security/controller/cmn/getdropdownlist',
      'ssnidn': '$ssnId',
    };
    String url = Connections().generateUri() + 'getdata';

    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.body.contains("No Error")) {
      print('Success');
    }
  }

  Future<String> fetchBccId() async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');

    var body = {
      'jsonArr':
          '[{\"dropDownParams\":[{\"list\":\"BAYACONTROLCODES-DROPDOWN\",\"key\":\"resultApprovalTypes\",\"procName\":\"bayacontrolcodelistproc\",\"actionFlag\":\"LIST\",\"subActionFlag\":\"\",\"xmlStr\":\"<List TableCode = \\\"DOC_APPRVL_STATUS\\\" CompanyId = \\\"2\\\" RequestFrom = \\\"Mobile\\\"> </List>\"},{\"list\":\"EXEC-PROC\",\"key\":\"resultTransactionTypes\",\"procName\":\"DocumentApprovalPendingListProc\",\"actionFlag\":\"LIST\",\"subActionFlag\":\"\",\"xmlStr\":\"<List UserId = \\\"1\\\" SuperUserYN = \\\"N\\\" RequestFrom = \\\"Mobile\\\"> </List>\"}]}]',
      'url': '/security/controller/cmn/getdropdownlist',
      'ssnidn': '$ssnId',
    };
    String url = Connections().generateUri() + 'getdata';

    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.body.contains("No Error")) {
      var convertPost = json.decode(response.body);
      fetchBccIdModel = FetchBccIdModel.fromJson(convertPost);

      approveBccId = fetchBccIdModel.resultApprovalTypes[0].id;
      rejectBccId = fetchBccIdModel.resultApprovalTypes[1].id;

      print('IDDDD: $approveBccId,$rejectBccId,$clickedBccId');
    }
  }

  var data;
  var dtlapprovalArry;

  Future<String> postDocumentApprove(
      int clickedId, String date, String dateTime) async {
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');

    Map<String, dynamic> jsnAry;
    var jsonDtlList = {
      "dtlDtoList": [
        {
          "Id": 0,
          if (data != null) "dtlapprovalary": data,
          "optionid": optionId,
          "reftableid": refTableId,
          "refoptionid": refOptionId,
          "reftabledataid": reftabledataid,
          "levelno": leveltypebccid,
          "leveltypebccid": leveltypebccid,
          "userid": userId,
          "subtypeId": subTypeId,
          "username": "$userName",
          "iscancelledyn": "N",
          "password": "$password",
          "useractionbccid": clickedId,
          "userrejectionbccid": rejectBccId,
          "userapprovalbccid": approveBccId,
          "minimumpersonstoapproveorreject": minPersonToApprove,
          "lastapprovallevelbccid": maxlevelid,
          "lastapprovallevelminipersontoapprove": lastApproval,
          "tablename": tableName,
          "recordsatus": "A",
          "statusdate": "$date",
          "userremarks": _remarks ?? "",
          "translastmoddate": dateTime,
          "dtltablename": transTableName,
          "mobile": true,
          "emailonapprovalreqyn": emailProvision,
          "smsonapprovalreqyn": smsProvision
        }
      ],
      "docAttachReqYN": false,
      "docAttachXml": "",
      "extensionDataObj": [],
      "screenNoteDataObj": [],
      "screenFieldDataApprovalInfoObj": [],
      "checkListDataObj": []
    };

    jsonDtlList.removeWhere((key, value) => value == null);

    if (isDtl.length > 1) {
      detailTransactionData.toString();
      print("dtldata---${detailTransactionData.toString()}");
      dtlapprovalArry = detailTransactionData.map((e) {
        return {
          "appyn": approveyn.toString(),
          //approveyn,
          "dtldataid": (e["dtldataid"]).toString(),
          //e["dtldataid"],
          "editcol": editcol ?? "",
          if (editcol != null) "editcolval": (e[editcol]),
          "table": (e["table"]).toString(),
        };
      }).toList();
//if(dtlapprovalArry!=null)
      data = dtlapprovalArry != null ? jsonEncode(dtlapprovalArry) : [];
      print(data);
      //  dtlapprovalArry='[{"appyn": $approveyn,"dtldataid": $dtldataid,"editcol": "","table":"$dtltablename"}]';}
    } else {
      dtlapprovalArry = [];
    }

    var body = {
      'uuid': 0.toString(),
      'userid': 0.toString(),
      'chkflag': "N",
      // 'compressdyn': false,
      'jsonArr':
          //  '[${jsonEncode(jsonDtlList)}]',
          '[{"dtlDtoList":[{ "dtlapprovalary":${data ?? []},"Id":0, "subtypeId": $subTypeId,"optionid":${approveOptionId ?? 441},"reftableid":$refTableId,"refoptionid":$refOptionId,"reftabledataid":$reftabledataid,"levelno":$leveltypebccid,"leveltypebccid":$leveltypebccid,"userid":$userId,"username":"$userName","iscancelledyn":"N","password":"$password","useractionbccid":$clickedId,"userrejectionbccid":$rejectBccId,"userapprovalbccid":$approveBccId,"minimumpersonstoapproveorreject":$minPersonToApprove,"lastapprovallevelbccid":$maxlevelid,"lastapprovallevelminipersontoapprove":$lastApproval,"tablename":"$tableName","recordsatus":"A","statusdate":"$date","userremarks":"${_remarks ?? ""}","translastmoddate":"$dateTime","dtltablename":${transTableName},"mobile":true,"emailonapprovalreqyn":"$emailProvision","smsonapprovalreqyn":"$smsProvision"}],"extensionDataObj":[],"screenNoteDataObj":[],"screenFieldDataApprovalInfoObj":[],"checkListDataObj":[]}]',
      'url': '/security/controller/trn/savedocumentapprovalhistoryinfo',
      'ssnidn': '$ssnId',
    };

    // if(isDtl.length>1)
    //  var dtlapprovalArry=[{"appyn": approveyn,"dtldataid": dtldataid,"editcol": "","table":tableName}];
    // "dtlapprovalary": [{"appyn": ${approveyn},"dtldataid": $dtldataid,"editcol": "","table":$tableName}],
    String url = Connections().generateUri() + 'putdata';

    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };

    log('APPROVE BODY ::::: $body');
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    log('Response body APPROVE##: ${response.body}');
    var jsonResponse = jsonDecode(response.body);
    setState(() {
      responseMessage = jsonResponse['statusMessage'];
    });
    isSuccess = false;
    if (responseMessage == "Success") {
      isSuccess = !isSuccess;
      print("success");
      // showSuccessDialog(context);
      showSuccessDialog(context, "Saved successfully", "Success", () {
        print("clear");
        // Navigator.popUntil(
        //     context, (Route<dynamic> route) => route.isFirst);
        Navigator.pop(context);
        Navigator.pop(context);
      });
      // Navigator.pop(context);
    } else if (isSuccess == false) {
      ///this dialog is given to solve concurrency issue
      showAlertMessageDialog(context, "",
          "${responseMessage.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
          () {
            print("clear");
        Navigator.pop(context);
        Navigator.pop(context);
      });
      isSuccess = !isSuccess;
      print("ConCurrentUpdate");
    } else {
      print('ERROR!');
      //  WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
          backgroundColor: ThemeProvider.of(context).primaryColor,
          content: Text(
            '$responseMessage',
            style: TextStyle(color: ThemeProvider.of(context).accentColor),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      //  });
    }
  }

  final GlobalKey docApprovalFormKey = GlobalKey();
  LoginModel loginmodel = LoginModel();

  @override
  Widget build(BuildContext context) {
    finalizedOptName = ((approvalOptnName).toString()).replaceAll("_", " ");
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    return BaseView<AppState, DocumentApprDetailViewModel>(
      init: (store, context) async{
        prefClientId = await BasePrefs.getString("notifCompany");

        if (widget.approveOptionId != null &&
            widget.transId != null &&
            widget.transTableId != null &&
            widget.optionId != null)
          store.dispatch(setNotificationAsRead(
              optionId: widget.approveOptionId,
              transTableId: widget.transId,
              transId: widget.transTableId,
              subtypeId: widget.subTypeId,
              notificationId: widget?.optionId ??
                  store.state.homeState.user.moduleList.first.optionId));
      },
      converter: (store) => DocumentApprDetailViewModel.fromStore(store),
      builder: (context, viemodel) {
        return Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor:
                  ThemeProvider.of(context).primaryColor ?? Colors.white,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title:
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 8),
              //       child: Text(
              //           dataList == null ? '- -' : '${dataList[1].value}',
              //           style: TextStyle(
              //               letterSpacing: .35,
              //               color: Colors.white,
              //               fontSize: 16)),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 8),
              Center(
                    child: Text(
                        dataList == null ? '- -' : '${finalizedOptName}',
                        style: TextStyle(
                            letterSpacing: .35,
                            color: Colors.white,
                            fontSize: 16)),
                  ),
              //   ],
              // ),
              elevation: 0.5,
              // centerTitle: false,
              // actions: actions,
              //  bottom: bottom,
            ),
            body: prefLoaded && prefClientId == null || prefClientId == ""
                ? AlertDialog(
                backgroundColor: themeData.primaryColor,
                title: Center(child: Text("Alert")),
                contentPadding:
                EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                content: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25)),
                    height: height * .3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.announcement,
                                  size: 30,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, right: 8, left: 8),
                                  child: Text(
                                        "${("Please Login First")}",
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: height * .07,
                                  width: width * .3,
                                  child: BaseClearButton(
                                    borderRadius: BorderRadius.circular(15),
                                    backgroundColor: themeData.primaryColorDark,
                                    color: Colors.white,
                                    child: const Text("OK"),
                                    onPressed: () {
                                      // viewModel.saveGradingCosting();
                                      Navigator.pop(context);
                                      // Navigator.popUntil(
                                      //     context, (Route<dynamic> route) => route.isFirst);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        )))
                        : (dataList?.isNotEmpty ?? false) &&
                    (dataList != null) &&
                    (dataList?.length ?? 0) > 0
                ? Form(
                    key: docApprovalFormKey,
                    child: Column(children: <Widget>[
                      SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                    color:
                                        ThemeProvider.of(context).primaryColor,
                                child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                            color: ThemeProvider.of(context)
                                            .primaryColor,
                                        child: Padding(
                                                      padding:
                                                  const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                                  itemCount: dataListLength,
                                              itemBuilder:
                                                      (BuildContext context,
                                                      int index) {
                                                            print(
                                                        dataList[index].header);
                                                return Visibility(
                                                      visible: dataList[index]
                                                                          .align ==
                                                              'right'
                                                          ? true
                                                          : false,
                                                  child: Visibility(
                                                        visible: dataList[index]
                                                                    .isvisibleyn ==
                                                            'Y'
                                                        ? true
                                                        : false,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                              MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                              dataList[index]
                                                                          .header ==
                                                                  null
                                                              ? '- -'
                                                              : '${dataList[index].header}',
                                                                      style: style
                                                                          .display1
                                                              .copyWith(
                                                                      fontSize:
                                                                          13),
                                                              maxLines: 1,
                                                          textAlign:
                                                                          TextAlign
                                                                              .start,
                                                              softWrap: true,
                                                        ),
                                                            SizedBox(height: 6),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //               .only(
                                                        //           right: 4.0),
                                                        //   child: Text(
                                                        //     dataList[index]
                                                        //                 .value ==
                                                        //             null
                                                        //         ? '- -'
                                                        //         : '${dataList[index].value}',
                                                        //     maxLines: 2,
                                                        //     softWrap: true,
                                                        //     textAlign:
                                                        //         TextAlign.left,
                                                        //     overflow:
                                                        //         TextOverflow
                                                        //             .clip,
                                                        //     style: style
                                                        //         .display1Semi
                                                        //         .copyWith(
                                                        //             fontSize:
                                                        //                 14),
                                                        //     // style: !model.isDescription
                                                        //     //     ? style.bodyBold.copyWith(
                                                        //     //     fontSize: 14,color: Colors.white
                                                        //     // )
                                                        //     //     : style.body
                                                        //   ),
                                                        // ),
                                                                    SizedBox(
                                                                height: 18.0),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                            color: ThemeProvider.of(context)
                                            .primaryColor,
                                        child: Padding(
                                                      padding:
                                                  const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                                  itemCount: dataListLength,
                                              itemBuilder:
                                                      (BuildContext context,
                                                      int index) {
                                                return Visibility(
                                                      visible: dataList[index]
                                                                          .align ==
                                                              'right'
                                                          ? true
                                                          : false,
                                                  child: Visibility(
                                                        visible: dataList[index]
                                                                    .isvisibleyn ==
                                                            'Y'
                                                        ? true
                                                        : false,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                              MainAxisSize.min,
                                                      children: [
                                                        // Text(
                                                        //   dataList[index]
                                                        //               .header ==
                                                        //           null
                                                        //       ? '- -'
                                                        //       : '${dataList[index].header}',
                                                        //   style: style.display1
                                                        //       .copyWith(
                                                        //           fontSize: 13),
                                                        //   maxLines: 1,
                                                        //   textAlign:
                                                        //       TextAlign.start,
                                                        //   softWrap: true,
                                                        // ),
                                                            SizedBox(height: 4),
                                                        Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4.0),
                                                              child: Text(
                                                                dataList[index]
                                                                            .formatnumberyn ==
                                                                    "Y"
                                                                    ? BaseNumberFormat(
                                                                            number: num.parse(
                                                                                '${dataList[index].value}'))
                                                                        .formatCurrency()
                                                                    : dataList[index].value ==
                                                                            null
                                                                    ? '- -'
                                                                    : '${dataList[index].value}',
                                                                maxLines: 2,
                                                                softWrap: true,
                                                            textAlign:
                                                                    TextAlign
                                                                        .left,
                                                            overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                            style: style
                                                                .display1Semi
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14),
                                                            // style: !model.isDescription
                                                            //     ? style.bodyBold.copyWith(
                                                            //     fontSize: 14,color: Colors.white
                                                            // )
                                                            //     : style.body
                                                          ),
                                                        ),
                                                                    SizedBox(
                                                                height: 18.0),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                                  if (dtlList != null && dtlTransList != null)
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            detailTransactionData?.length,
                                    itemBuilder:
                                            (BuildContext context, int pos) {
                                      return Column(
                                        children: [
                                          Container(
                                                color: ThemeProvider.of(context)
                                                .primaryColor,
                                            child: Row(
                                              crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: ThemeProvider.of(
                                                            context)
                                                        .primaryColor,
                                                    child: Padding(
                                                      padding:
                                                                      const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              ListView.builder(
                                                                          shrinkWrap:
                                                                              true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount: dtlTransList
                                                                  ?.elementAt(
                                                                      pos)
                                                                  ?.length,
                                                          itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    print(dtlTransList
                                                                        ?.elementAt(
                                                                            pos)[index]
                                                                        ?.header);
                                                            return Visibility(
                                                                      visible: dtlTransList?.elementAt(pos)[index]?.align ==
                                                                              'right'
                                                                          ? true
                                                                          : false,
                                                                      child:
                                                                          Visibility(
                                                                        visible: dtlTransList?.elementAt(pos)[index]?.isvisibleyn ==
                                                                                'Y'
                                                                            ? true
                                                                            : false,
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                  children: [
                                                                    Expanded(
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(top: 2, bottom: 5, left: 2, right: 2),
                                                                                        child: Text(
                                                                                          dtlTransList?.elementAt(pos)[index]?.header == null ? '- -' : '${dtlTransList?.elementAt(pos)[index]?.header}',
                                                                                          style: style.body2,
                                                                                          maxLines: 1,
                                                                                          textAlign: TextAlign.start,
                                                                                          softWrap: true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // SizedBox(height: 4),
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets.only(right: 4.0),
                                                                    //   child:
                                                                    Expanded(
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.only(top: 2, bottom: 5, left: 2, right: 2),
                                                                        child: Text(
                                                                            dtlTransList?.elementAt(pos)[index].formatnumberyn == "Y"
                                                                                ? BaseNumberFormat(number: num.parse('${dtlTransList?.elementAt(pos)[index]?.value}')).formatCurrency()
                                                                                : dtlTransList?.elementAt(pos)[index]?.value == null
                                                                                    ? '- -'
                                                                                    : '${dtlTransList?.elementAt(pos)[index]?.value}',
                                                                            maxLines: 2,
                                                                            softWrap: true,
                                                                            textAlign: TextAlign.end,
                                                                            overflow: TextOverflow.clip,
                                                                            style: style.bodySemi
                                                                            // style: !model.isDescription
                                                                            //     ? style.bodyBold.copyWith(
                                                                            //     fontSize: 14,color: Colors.white
                                                                            // )
                                                                            //     : style.body
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    //   SizedBox(height: 18.0),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ),

                                                // Expanded(
                                                //   child: Container(
                                                //     color: ThemeProvider.of(context).primaryColor,
                                                //     child: Padding(
                                                //       padding: const EdgeInsets.all(8.0),
                                                //       child: ListView.builder(
                                                //           shrinkWrap: true,
                                                //           physics: NeverScrollableScrollPhysics(),
                                                //           itemCount: dtlTransList?.elementAt(pos)?.length,
                                                //           itemBuilder: (BuildContext context, int index) {
                                                //             return Visibility(
                                                //               visible: dtlTransList?.elementAt(pos)[index]?.align == 'right'?true:false,
                                                //               child: Visibility(
                                                //                 visible: dtlTransList?.elementAt(pos)[index]?.isvisibleyn == 'Y'?true:false,
                                                //                 child: Column(
                                                //                   crossAxisAlignment: CrossAxisAlignment.start,
                                                //                   mainAxisAlignment: MainAxisAlignment.start,
                                                //                   mainAxisSize: MainAxisSize.min,
                                                //                   children: [
                                                //                     Text(
                                                //                       dtlTransList?.elementAt(pos)[index]?.header == null
                                                //                           ? '- -'
                                                //                           : '${dtlTransList?.elementAt(pos)[index]?.header}',
                                                //                       style: style.display1.copyWith(fontSize: 16),
                                                //                       maxLines: 1,
                                                //                       textAlign: TextAlign.start,
                                                //                       softWrap: true,
                                                //                     ),
                                                //                     SizedBox(height: 4),
                                                //                     Padding(
                                                //                       padding: const EdgeInsets.only(right: 4.0),
                                                //                       child: Text(
                                                //                         dtlTransList?.elementAt(pos)[index]?.value == null
                                                //                             ? '- -'
                                                //                             : '${dtlTransList?.elementAt(pos)[index]?.value}',
                                                //                         maxLines: 2,
                                                //                         softWrap: true,
                                                //                         textAlign: TextAlign.left,
                                                //                         overflow: TextOverflow.clip,
                                                //                         style: style.display1Semi.copyWith(fontSize: 15),
                                                //                         // style: !model.isDescription
                                                //                         //     ? style.bodyBold.copyWith(
                                                //                         //     fontSize: 14,color: Colors.white
                                                //                         // )
                                                //                         //     : style.body
                                                //                       ),
                                                //                     ),
                                                //                     SizedBox(height: 18.0),
                                                //
                                                //                   ],
                                                //                 ),
                                                //               ),
                                                //             );
                                                //           }),
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                            color: ThemeProvider.of(context).primaryColor,
                        margin: EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {
                                _remarks = val;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            enabled: true,
                            obscureText: isPassword,
                            textInputAction: TextInputAction.done,
                            initialValue: initialValue,
                            autovalidate: false,
                            validator: (val) {
                                  if (clickedBccId == 568 && val.isEmpty) {
                                return "Please Enter remarks";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                            minLines: isPassword ? 1 : 2,
                            maxLines: isPassword ? 1 : 5,
                            showCursor: true,
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                hintText: hint,
                                border: OutlineInputBorder(
                                    borderSide: BaseBorderSide()),
                                labelText: displayTitle,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintStyle: style.smallHint
                                    .copyWith(color: Colors.white),
                                //      icon: Icon(Icons.description, size: 18),
                                contentPadding:
                                        EdgeInsets.symmetric(vertical: 1)),
                            //   onSaved: onSaved
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                          // padding:
                          //     EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 6),
                              height: MediaQuery.of(context).size.height * .14,
                              color: ThemeProvider.of(context).primaryColor,
                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(6),
                                child: _ApprovalButton(
                                    color: ThemeProvider.of(context)
                                        .primaryColorDark,
                                    icon: Icons.check,
                                    title: Text(
                                      'APPROVE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                              color: ThemeProvider.of(context)
                                              .accentColor),
                                    ),
                                    onPressed: () {
                                      // showSuccessDialog(context);
                                      showLoaderDialog(context);
                                      setState(() {
                                        clickedBccId = approveBccId;
                                            approveyn = clickedBccId == 567
                                                            ? true
                                                            : false;
                                        print(approveyn);
                                      });
                                      final FormState form =
                                              docApprovalFormKey.currentState;
                                      if (!form.validate()) {
                                        print(
                                            'Form is not valid!  Please review and correct.');
                                      } else {
                                        form.save();
                                        setState(() {
                                              clickedBccId = approveBccId;
                                              approveyn = clickedBccId == 567
                                              ? true
                                              : false;
                                          print(approveyn);
                                        });

                                        //  currentDateTime = DateTime.now().toString();
                                            DateTime now = DateTime.now();
                                            currentDate =
                                                BaseDates(DateTime.now())
                                            .formatDate;
                                        // currentDate = (now.day.toString() +
                                        //     "-" +
                                        //     now.month.toString() +
                                        //     "-" +
                                        //     now.year.toString());
                                        print(currentDate);

                                        //  getPrefs();
                                        for (int i = 0;
                                            i < documentList.length;
                                            i++) {
                                              if (node["resultObject"][0]
                                                              ["transactiondtl"]
                                                          [0]["transactiondtl"]
                                                      [0]['maxlevelid'] ==
                                                  node["resultObject"][0]
                                                              ["transactiondtl"]
                                                          [
                                                          0]["documentconfigdtl"]
                                                      [i]["levelnobccid"]) {
                                                if (node["resultObject"][0][
                                                            "transactiondtl"][0]
                                                                    [
                                                                    "documentconfigdtl"][i]
                                                    [
                                                    "approvalrejectionbccid"] ==
                                                clickedBccId) {
                                              lastApproval = node[
                                                              "resultObject"][0]
                                                              ["transactiondtl"]
                                                                      [
                                                          0]["documentconfigdtl"]
                                                      [i]["minpersontoapprove"];
                                              print(
                                                  '**************************LAST APPROVAL:$lastApproval');
                                            }
                                          }
                                        }
                                            postDocumentApprove(clickedBccId,
                                                currentDate, currentDateTime);
                                      }
                                      // if (performValidation(
                                      //     widget.transactionDtl.maxLevelId)) {
                                      //   widget.onSaved(e, _remarks);
                                      // } else {
                                      //   AppSnackBar.of(context)
                                      //       .show("Please enter remarks" ?? "");
                                      // }
                                    }),
                              )),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(6),
                                child: _ApprovalButton(
                                                color: ThemeProvider.of(context)
                                                    .accentColor,
                                    icon: Icons.delete_forever,
                                    title: Text(
                                      'REJECT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                              color: ThemeProvider.of(context)
                                              .primaryColorDark),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        clickedBccId = rejectBccId;
                                            approveyn = clickedBccId == 567
                                                            ? true
                                                            : false;
                                        print(approveyn);
                                      });
                                      final FormState form =
                                              docApprovalFormKey.currentState;
                                      if (!form.validate()) {
                                        print(
                                            'Form is not valid!  Please review and correct.');
                                      } else {
                                        showLoaderDialog(context);
                                        form.save();
                                        // setState(() {
                                        //   clickedBccId = rejectBccId;
                                        //   approveyn = clickedBccId == 567 ? true : false;
                                        //   print(approveyn);
                                        // });

                                        //  currentDateTime = DateTime.now().toString();
                                                    print(
                                                        'CURRENT DATE: $currentDateTime');
                                            DateTime now = DateTime.now();
                                            currentDate =
                                                BaseDates(DateTime.now())
                                            .formatDate;
                                        // currentDate = (now.day.toString() +
                                        //     "-" +
                                        //     now.month.toString() +
                                        //     "-" +
                                        //     now.year.toString());
                                        print(currentDate);

                                        for (int i = 0;
                                            i < documentList.length;
                                            i++) {
                                              if (node["resultObject"][0]
                                                              ["transactiondtl"]
                                                          [0]["transactiondtl"]
                                                      [0]['maxlevelid'] ==
                                                  node["resultObject"][0]
                                                              ["transactiondtl"]
                                                          [
                                                          0]["documentconfigdtl"]
                                                      [i]["levelnobccid"]) {
                                                if (node["resultObject"][0][
                                                            "transactiondtl"][0]
                                                                    [
                                                                    "documentconfigdtl"][i]
                                                    [
                                                    "approvalrejectionbccid"] ==
                                                clickedBccId) {
                                              lastApproval = node[
                                                              "resultObject"][0]
                                                              ["transactiondtl"]
                                                                      [
                                                          0]["documentconfigdtl"]
                                                      [i]["minpersontoapprove"];
                                              print(
                                                  '**************************LAST APPROVAL:$lastApproval');
                                            }
                                          }
                                        }

                                            postDocumentApprove(clickedBccId,
                                                currentDate, currentDateTime);
                                      }

                                      // showSuccessDialog(context);
                                      // if (performValidation(
                                      //     widget.transactionDtl.maxLevelId)) {
                                      //   widget.onSaved(e, _remarks);
                                      // } else {
                                      //   AppSnackBar.of(context)
                                      //       .show("Please enter remarks" ?? "");
                                      // }
                                    }),
                              )),
                            ],
                          ))
                    ]),
                  )
                : Center(
                    child: BaseLoadingView(
                      message: "Loading .. please wait",
                    ),
                  ));
      },

      ///additionally added to solve concurrency
      // onDidChange:
      //     (DocumentApprDetailViewModel viewModel, BuildContext context) {
      //   if (viewModel.isMultiTransactionSubmitted) {
      //     showSuccessDialog(context, "Saved Successfully", "Success", () {
      //       Navigator.pop(context);
      //     });
      //     viewModel.clearState();
      //   }else if(viewModel.documentApprovalFailure == true){
      //     ///this dialog is given to solve concurrency issue
      //     showAlertMessageDialog(context, "",
      //         "${viewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
      //             () {
      //           Navigator.of(context).pop();
      //           viewModel.resetDocumentApprovalFailure();
      //         });
      //   }
      // },
      onDispose: (store) async {
        isNotificationScreenClosed = true;
        final String musicsString = await BasePrefs.getString('CompanyList');
        final List<LoginModel> sharedPrefCompanyList =
        LoginModel.decode(musicsString);
        store.dispatch(
            fetchNotificationCountFromDb(loginModel: sharedPrefCompanyList));
        String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
        int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
        store.dispatch(
            fetchNotificationCount(clientid: clientId, userid: userId));

        SignInState signInState = store.state.signInState;
        loginmodel.clientId = signInState.clientId;
        loginmodel.userName = signInState.userName;
        loginmodel.password = signInState.password;
        store.dispatch(getMoreDetails(loginmodel));
      },
    );
  }

  // showSuccessDialog(BuildContext context) async {
  //   await appShowChildDialog<bool>(
  //       context: context,
  //       child: UpdateSuccessDialog(),
  //       barrierDismissible: false);
  //
  //   Navigator.pop(context);
  // }
}

class _ApprovalButton extends StatelessWidget {
  final Widget title;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;
  final TextStyle style;

  const _ApprovalButton(
      {Key key, this.title, this.color, this.icon, this.onPressed, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: color,
        ),
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(icon, color: color),
                  title
                ]),
            onPressed: onPressed,
            padding: EdgeInsets.all(14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BaseBorderSide(color: color)),
            splashColor: color.withOpacity(.4)));
  }
}

class _TextInputField extends StatelessWidget {
  final String initialValue;
  final String hint;
  final String displayTitle;
  final IconData icon;
  final Function(String val) validator;
  final Function(String val) onSaved;
  final bool isPassword;

  _TextInputField(
      {this.initialValue,
      this.hint,
      this.displayTitle,
      this.icon,
      this.isPassword = false,
      this.validator,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    BaseTheme _theme = BaseTheme.of(context);
    return TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        enabled: true,
        obscureText: isPassword,
        textInputAction: TextInputAction.done,
        initialValue: initialValue,
        // autovalidate: false,
        validator: validator,
        keyboardType: TextInputType.text,
        minLines: isPassword ? 1 : 2,
        maxLines: isPassword ? 1 : 5,
        showCursor: true,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            hintText: hint,
            border: OutlineInputBorder(borderSide: BaseBorderSide()),
            labelText: displayTitle,
            labelStyle: _theme.textfieldLabel.copyWith(color: Colors.white),
            hintStyle: _theme.smallHint.copyWith(color: Colors.white),
//            icon: Icon(icon, color: kHintColor, size: 18),
            contentPadding: EdgeInsets.symmetric(vertical: 1)),
        onSaved: onSaved);
  }
}
