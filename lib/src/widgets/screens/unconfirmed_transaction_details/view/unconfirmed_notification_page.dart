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
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/unconfirmed_transaction_details/unconfirmed_transaction_details_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/dataJsonModel.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/data_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/fetch_bccId_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/alert_message_dialog.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';
import 'package:redstars/utility.dart';

class UnconfirmedNotificationPage extends StatefulWidget {
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  var approvalOptionCode;
  var approvalOptnName;
  var clientIdFrmNoti;

  bool onUserClick;
  var refoptionid;
  UnconfirmedNotificationPage(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.approveOptionId,
      this.approvalOptionCode,
      this.approvalOptnName,
      this.refoptionid,
      this.clientIdFrmNoti,
      this.onUserClick});

  @override
  _UnconfirmedNotificationPageState createState() =>
      _UnconfirmedNotificationPageState(
          optionId: optionId,
          transTableId: transTableId,
          transId: transId,
          refOptionId: refoptionid,
          approveOptionId: approveOptionId,
          approvalOptionCode: approvalOptionCode,
          approvalOptnName: approvalOptnName,
          clientIdFrmNoti: clientIdFrmNoti,
          onUserClick: onUserClick);
}

class _UnconfirmedNotificationPageState
    extends State<UnconfirmedNotificationPage> {
  var transTableId;
  var transId;
  List transactionList;
  List documentList;
  List alertList;
  int lastApproval;
  var optionId;
  var approveOptionId;
  var clientIdFrmNoti;
  bool onUserClick;
  String responseMessage = 'Oops! Something went wrong!';
  int dataListLength = 0;
  int maxLevel;
  int levelnobccid;
  int lastApprovalTest;
  var approvalOptionCode;
  var approvalOptnName;
  _UnconfirmedNotificationPageState(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.approveOptionId,
      this.approvalOptionCode,
      this.approvalOptnName,
      this.refOptionId,
      this.clientIdFrmNoti,
      this.onUserClick});

  String transTableName;
  var dtltablereryn;
  String tableName;
  String _remarks;
  final bool reject = true;
  String emailProvision;
  String smsProvision;
  var refOptionId;
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
  String transno;
  var editcol;
  var editcolval;
  int userId;
  FetchBccIdModel fetchBccIdModel;
  DataModel dataModel;
  String currentDate;
  String currentDateTime;

  String initialValue;
  String hint = "Enter Remarks";
  String displayTitle = "Remarks";
  Function(String val) validator;
  Function(String val) onSaved;
  bool isPassword = false;
  List<DataModel> dataList;
  List<DataModel> dtlList;
  List<List<DataModel>> dtlTransList = [];
  DataJsonModel dataJsonModel;
  Map<String, dynamic> node;
  bool approveyn;
  int dtldataid;
  String dtltablename;
  String prefClientId;

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

  List<DataModel> list1 = [];
  List<UncTransactionDetails> transactionDtlList = [];

  @override
  void initState() {
    getPrefs();
    isNotificationScreenClosed = false;
    super.initState();
  }

  getPrefs() async {
    prefClientId = await BasePrefs.getString("notifCompany");
    prefLoaded=true;
    setState(() {});
    userName = await BasePrefs.getString(BaseConstants.USERNAME_KEY);
    password = await BasePrefs.getString(BaseConstants.PASSWORD_KEY);
    userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    if (clientId == widget.clientIdFrmNoti) {
    if(prefClientId != null && prefClientId !=""){
    await fetchBccId();
    await fetchItemData();
    }
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

  Future fetchUpdateCountCall() async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');
    int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    var body = {
      'jsonArr':
          '[{\"dropDownParams\":[{\"list\":\"EXEC-PROC\",\"key\":\"resultObject\",\"procName\":\"MobileNotificationProc\",\"actionFlag\":\"COUNT_UPDATE\",\"subActionFlag\":\"\",\"xmlStr\":\"<List UserId = \\\"$userId\\\" OptionId = \\\"$refOptionId\\\" TransTableId = \\\"$transTableId\\\" TransId = \\\"$transId\\\" ClientId = \\\"$clientId\\\" BranchId = \\\"$branchId\\\" NotificationOptionId = \\\"$approveOptionId\\\" RequestFrom = \\\"Mobile\\\"> </List>\"}]}]',
      'url': '/security/controller/cmn/getdropdownlist',
      'ssnidn': '$ssnId',
    };
    String url = Connections().generateUri() + 'getdata';

    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };

    log("body + "+body.toString());
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print('Response status2: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.body.contains("No Error")) {
      print('Success');
    }
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
          'TransTableId = \\\"$transTableId\\\" TransId = \\\"$transId\\\" >'
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
    print('Response status 111: ${response.statusCode}');
    if (response.body.contains("ERROR")) {
      var jsonResponse = json.decode(response.body);
      node = jsonResponse;
      String statusMsg = node["statusMessage"];

      showAlertMessageDialog(context, "",
          "${statusMsg.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
          () {
        if (mounted) Navigator.pop(context);
      });
    }
    log('Response body DATAS##: ${response.body}');
    if (response.body.contains("No Error")) {
      print("Count call");
      fetchUpdateCountCall();
      var jsonResponse = json.decode(response.body);
      node = jsonResponse;
      print("node$node");
      int i = 0;
      detailTransactionData = node["resultObject"][0]["transactiondtl"];
      var transDtl = node["resultObject"][0]["transactiondtl"];
      print(detailTransactionData);
      print(transDtl);

      node = jsonResponse;

      var result = node['resultObject'][0]["transactiondtl"];
      var jsResult = jsonEncode(result);
      log(jsResult);
      Iterable k = json.decode(jsResult);
      transactionDtlList = k != null
          ? List<UncTransactionDetails>.of(
              k.map((model) => UncTransactionDetails.fromJson(
                    model,
                  )))
          : null;
      print(transactionDtlList.length);
      if (mounted) setState(() {});

      print('##########lastApproval# :: $lastApproval');
    } else {
      final snackBar = SnackBar(
          backgroundColor: ThemeProvider.of(context).primaryColor,
          content: Text(
            '$responseMessage',
            style: TextStyle(color: ThemeProvider.of(context).accentColor),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  final GlobalKey docApprovalFormKey = GlobalKey();
  LoginModel loginmodel = LoginModel();
  bool prefLoaded=false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);

    return BaseView<AppState, UnConfirmedTransactionDetailViewModel>(
       init: (store, context) async{
         prefClientId = await BasePrefs.getString("notifCompany");
       },
      onDidChange: (unconfirmedViewModel, context) {
        if (unconfirmedViewModel.unConfirmedTransactionDetailSave) {
          showSuccessDialog(context, "Saved successfully", "Success", () {
            // unconfirmedViewModel.onUnconfirmedClearAction();
            // unconfirmedViewModel.onCalledAfterSave();
            // print("${viewModel.cartItems.first}");

            print("clear");
            Navigator.pop(context);
          });
          unconfirmedViewModel.onUnconfirmedClearAction();

          // showSuccessDialog(context);

          // unconfirmedViewModel.onUserSelect(UnConfirmedFilterModel(
          //     fromDate: unconfirmedViewModel.unConfirmedFilterModel.fromDate,
          //     toDate: DateTime.now(),
          //     optionCode: null));
        } else if (unconfirmedViewModel.unconfirmedTransactionApprovalFailure ==
            true) {
          ///this dialog is given to solve concurrency issue
          showAlertMessageDialog(context, "",
              "${unconfirmedViewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
                  () {
                Navigator.of(context).pop();
              });
          unconfirmedViewModel.resetUTApprovalFailure();
        }

        print("clear");
      },
      converter: (store) =>
          UnConfirmedTransactionDetailViewModel.fromStore(store),
      builder: (context, unconfirmedViewModel) {
        return Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor:
                  ThemeProvider.of(context).primaryColor ?? Colors.white,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              // leading:
              // BaseBackButton(color: Colors.white,onPop: (){
              //   //Navigator.pop(context);
              // },),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Unconfirmed Transaction",
                        style: TextStyle(
                            letterSpacing: .35,
                            color: Colors.white,
                            fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                        widget.approvalOptnName == "PAYMENT_ENTRY"
                            ? 'Payment Voucher'
                            : widget.approvalOptnName == "GENERAL_VOUCHER"
                                ? 'General Voucher'
                                : 'Sales Invoice',
                        style: TextStyle(
                            letterSpacing: .35,
                            color: Colors.white,
                            fontSize: 16)),
                  ),
                ],
              ),
              elevation: 0.5,
              // centerTitle: false,
              // actions: actions,
              //  bottom: bottom,
            ),
            body: clientId != widget.clientIdFrmNoti
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
                                        "${("Please login or switch the company to approve!")}",
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
                : prefLoaded
                    ? prefClientId == null || prefClientId == ""
                        ? AlertDialog(
                            backgroundColor: themeData.primaryColor,
                            title: Center(child: Text("Alert")),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            content: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25)),
                                height: height * .3,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: height * .07,
                              width: width * .3,
                              child: BaseClearButton(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                backgroundColor:
                                themeData.primaryColorDark,
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
                        : Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                              transactionDtlList != null &&
                                      transactionDtlList.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                                          itemCount:
                                              transactionDtlList?.length ?? 0,
                            itemBuilder: (context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                                      top: 8,
                                                      right: 8,
                                                      left: 8),
                                                  margin: EdgeInsets.only(
                                                      right: 8, left: 8),
                                    decoration: BoxDecoration(
                                                    color:
                                                        themeData.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(12),
                                                            topRight:
                                                                Radius.circular(
                                                                    12)),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                        children: [
                                          Text(
                                                          transactionDtlList[
                                                                      index]
                                                    ?.transNo ??
                                                "",
                                            style: theme.bodyBold
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      .2),
                                                          textAlign:
                                                              TextAlign.center,
                                          ),
                                        ]),
                                    height: height * .07,
                                    width: width,
                                  ),
                                  Container(
                                    height: height * .33,
                                                  margin: EdgeInsets.only(
                                                      right: 8, left: 8),
                                    padding: EdgeInsets.only(
                                                      bottom: 12,
                                                      right: 8,
                                                      left: 8),
                                    decoration: BoxDecoration(
                                                    color: themeData
                                                        .primaryColor
                                          .withOpacity(.7),
                                                    borderRadius: (widget
                                                                    .approvalOptnName ??
                                                  "SALES_INVOICE") ==
                                              "SALES_INVOICE"
                                          ? BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12))
                                          : BorderRadius.only(),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                            mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                            children: [
                                                            if (widget
                                                                    ?.approvalOptnName ==
                                                  "GENERAL_VOUCHER")
                                                Visibility(
                                                  visible: widget
                                                          ?.approvalOptnName ==
                                                      "GENERAL_VOUCHER",
                                                  child: Expanded(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                                      buildText(
                                                                          "Reason"),
                                                        Text(
                                                                        transactionDtlList[index]?.reason ??
                                                              "",
                                                          textAlign:
                                                              TextAlign.end,
                                                                        style: theme
                                                                            .bodyBold
                                                                            .copyWith(letterSpacing: .2),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                            children: [
                                              if (widget.approvalOptnName ==
                                                  "PAYMENT_ENTRY")
                                                Visibility(
                                                                  visible: widget
                                                                              .approvalOptnName ==
                                                                "PAYMENT_ENTRY"
                                                            ? true
                                                            : false,
                                                                  child: buildText(
                                                                      "Paid From")),
                                              Visibility(
                                                              visible: widget
                                                                      .approvalOptnName ==
                                                        "PAYMENT_ENTRY",
                                                child: Text(
                                                                transactionDtlList[
                                                                            index]
                                                          .paidfrom ??
                                                      "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: theme
                                                                    .bodyBold
                                                      .copyWith(
                                                                        letterSpacing:
                                                                            .2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                                      if (widget
                                                              .approvalOptnName ==
                                            "PAYMENT_ENTRY")
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Visibility(
                                                    visible: widget
                                                            .approvalOptnName ==
                                                        "PAYMENT_ENTRY",
                                                                  child: buildText(
                                                                      "Paid To")),
                                                Visibility(
                                                                visible: widget
                                                                        .approvalOptnName ==
                                                          "PAYMENT_ENTRY",
                                                  child: Expanded(
                                                    child: Text(
                                                      transactionDtlList[index]
                                                              .paidto ??
                                                          "",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: theme
                                                                        .bodyBold
                                                          .copyWith(
                                                              letterSpacing:
                                                                  .2),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if ((widget.approvalOptnName ??
                                                "SALES_INVOICE") ==
                                            "SALES_INVOICE")
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Visibility(
                                                    visible: (widget
                                                                .approvalOptnName ??
                                                            "SALES_INVOICE") ==
                                                        "SALES_INVOICE",
                                                                  child: buildText(
                                                                      "Party")),
                                                Visibility(
                                                                visible: (widget
                                                                            .approvalOptnName ??
                                                              "SALES_INVOICE") ==
                                                          "SALES_INVOICE",
                                                  child: Text(
                                                                  transactionDtlList[
                                                                              index]
                                                            .partyname ??
                                                        "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: theme
                                                                      .bodyBold
                                                        .copyWith(
                                                                          letterSpacing:
                                                                              .2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                            children: [
                                                            buildText(
                                                                "Trans.Date"),
                                              Text(
                                                              transactionDtlList[
                                                                          index]
                                                        .transDate ??
                                                    "",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: theme
                                                                  .bodyBold
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          .2),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                                        visible: widget
                                                                .approvalOptnName ==
                                              "PAYMENT_ENTRY",
                                          child: Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                              buildText(
                                                                  "Settlement Type"),
                                                Text(
                                                                transactionDtlList[
                                                                            index]
                                                          .settlementtype ??
                                                      "",
                                                                style: theme
                                                                    .bodyBold
                                                      .copyWith(
                                                                        letterSpacing:
                                                                            .2),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                                        visible: (widget
                                                                    .approvalOptnName ??
                                                  "SALES_INVOICE") ==
                                              "SALES_INVOICE",
                                          child: Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                              buildText(
                                                                  "Reason"),
                                                Text(
                                                                transactionDtlList[
                                                                            index]
                                                          .reason ??
                                                      "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: theme
                                                                    .bodyBold
                                                      .copyWith(
                                                                        letterSpacing:
                                                                            .2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                            children: [
                                                            buildText(
                                                                "TotalAmount"),
                                              Text(
                                                (BaseNumberFormat(
                                                            number:
                                                                              transactionDtlList[index].totalValue)
                                                        .formatCurrency())
                                                    .toString(),
                                                              style: theme
                                                                  .bodyBold
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          .2),
                                                              textAlign:
                                                                  TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                                        visible: widget
                                                                .approvalOptnName ==
                                              "PAYMENT_ENTRY",
                                          child: Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                              buildText(
                                                                  "Settlement Date"),
                                                Text(
                                                                transactionDtlList[
                                                                            index]
                                                          .settlementdue ??
                                                      "",
                                                                style: theme
                                                                    .bodyBold
                                                      .copyWith(
                                                                        letterSpacing:
                                                                            .2),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                                          visible: widget
                                                                  .approvalOptnName ==
                                                "PAYMENT_ENTRY",
                                            child: Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                                buildText(
                                                                    "Settlement Days"),
                                                  Text(
                                                    (transactionDtlList[index]
                                                                .settlementduedays ??
                                                            0)
                                                        .toString(),
                                                                  style: theme
                                                                      .bodyBold
                                                        .copyWith(
                                                                          letterSpacing:
                                                                              .2),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                                      right: 8,
                                                      left: 8,
                                                      bottom: 4),
                                    decoration: BoxDecoration(
                                                    color: themeData
                                                        .primaryColor
                                          .withOpacity(.7),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12)),
                                    ),
                                    child: Visibility(
                                                    visible: widget
                                                            .approvalOptnName ==
                                          "PAYMENT_ENTRY",
                                      child: ExpansionTile(
                                                        tilePadding:
                                                            EdgeInsets.only(
                                                                left: 8,
                                                                right: 8),
                                                        childrenPadding:
                                                            EdgeInsets.only(
                                                                right: 12,
                                                                left: 12),
                                          title: Text(
                                            "Remarks",
                                                          style: TextStyle(
                                                              fontSize: 14),
                                          ),
                                          children: [
                                            BaseTextField(
                                              displayTitle: "",
                                                            vector: AppVectors
                                                                .remarks,
                                              initialValue:
                                                                transactionDtlList[
                                                                            index]
                                                          .paymentremarks ??
                                                      "",
                                              isEnabled: false,
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              );
                            }))
                    : Center(
                        child: BaseLoadingView(
                          message: "Loading..\nPlease wait",
                        ),
                      ),
                              if ((widget.approvalOptnName ??
                                          "SALES_INVOICE") ==
                        "SALES_INVOICE" &&
                    transactionDtlList != null &&
                    (transactionDtlList?.isNotEmpty ?? false))
                  Container(
                                  height:
                                      MediaQuery.of(context).size.height * .14,
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
                                                      color: ThemeProvider.of(
                                                              context)
                                            .accentColor),
                                  ),
                                  onPressed: () {
                                    UnConfirmedTransactionDetailList
                                        dataFromNotif;
                                                  dataFromNotif = UnConfirmedTransactionDetailList(
                                            transno: transactionDtlList
                                                              ?.first
                                                              ?.transNo ??
                                                "",
                                                      transdate:
                                                          transactionDtlList
                                                                  ?.first
                                                                  ?.transDate ??
                                                '',
                                                      id: transactionDtlList
                                                              ?.first?.id ??
                                                0,
                                            unconfirmedid:
                                                          transactionDtlList
                                                                  ?.first
                                                        ?.unconfirmedid ??
                                                    0,
                                                      tableid: transactionDtlList
                                                              ?.first
                                                              ?.tableid ??
                                                    0,
                                                      refoptionid:
                                                          transactionDtlList
                                                                  ?.first
                                                                  ?.reoptionId ??
                                                0,
                                                      lastmoddate:
                                                          transactionDtlList
                                                                  ?.first
                                                                  ?.lastmoddate ??
                                                "");
                                    unconfirmedViewModel
                                                      .onAddUnconfirmedData(
                                                          dataFromNotif);
                                    if (unconfirmedViewModel
                                                          .addedUnconfirmedItems
                                                          .length >
                                        0) {
                                      unconfirmedViewModel
                                          .onSaveUnConfirmedTransaction(
                                                            "A",
                                                            "SALES_INVOICE");
                                    } else {
                                      AppSnackBar.of(context).show(
                                          "Please select one transaction");
                                    }
                                  }),
                            ),
                          ),
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
                                                    color: ThemeProvider.of(
                                                            context)
                                          .primaryColorDark),
                                ),
                                onPressed: () {
                                  UnConfirmedTransactionDetailList
                                      dataFromNotif;
                                  dataFromNotif = UnConfirmedTransactionDetailList(
                                                    transno: transactionDtlList
                                                            ?.first?.transNo ??
                                              "",
                                      transdate: transactionDtlList
                                                            ?.first
                                                            ?.transDate ??
                                          '',
                                                    id: transactionDtlList
                                                            ?.first?.id ??
                                          0,
                                                    unconfirmedid:
                                                        transactionDtlList
                                                                ?.first
                                                                ?.unconfirmedid ??
                                              0,
                                                    tableid: transactionDtlList
                                                            ?.first?.tableid ??
                                          0,
                                                    refoptionid:
                                                        transactionDtlList
                                                                ?.first
                                                                ?.reoptionId ??
                                                            0,
                                                    lastmoddate:
                                                        transactionDtlList
                                                                ?.first
                                                                ?.lastmoddate ??
                                          "");
                                  unconfirmedViewModel
                                                    .onAddUnconfirmedData(
                                                        dataFromNotif);
                                  if (unconfirmedViewModel
                                                        .addedUnconfirmedItems
                                                        .length >
                                      0) {
                                    unconfirmedViewModel
                                        .onSaveUnConfirmedTransaction(
                                            "R", "SALES_INVOICE");
                                  } else {
                                                  AppSnackBar.of(context).show(
                                                      "Please select one transaction");
                                  }
                                }),
                          )),
                        ]
                        // final bool reject = e.code == "REJECTED";

                        ),
                  ),
                if (widget.approvalOptnName == "PAYMENT_ENTRY" &&
                    transactionDtlList != null &&
                    (transactionDtlList?.isNotEmpty ?? false))
                  Container(
                    width: width,
                                  height:
                                      MediaQuery.of(context).size.height * .09,
                                  color: ThemeProvider.of(context)
                                      .primaryColorDark,
                    child: RaisedButton(
                        onPressed: () {
                                        UnConfirmedTransactionDetailList
                                            dataFromNotif;
                          dataFromNotif = UnConfirmedTransactionDetailList(
                                            transno: transactionDtlList
                                                    ?.first?.transNo ??
                                                "",
                                            transdate: transactionDtlList
                                                    ?.first?.transDate ??
                                                '',
                                            id: transactionDtlList?.first?.id ??
                                                0,
                                            unconfirmedid: transactionDtlList
                                                    ?.first?.unconfirmedid ??
                                                0,
                                            tableid: transactionDtlList
                                                    ?.first?.tableid ??
                                                0,
                                            refoptionid: transactionDtlList
                                                    ?.first?.reoptionId ??
                                                13,
                                            lastmoddate: transactionDtlList
                                                    ?.first?.lastmoddate ??
                                                "");

                          unconfirmedViewModel
                                            .onAddUnconfirmedData(
                                                dataFromNotif);
                          if (unconfirmedViewModel
                                  .addedUnconfirmedItems.length >
                              0) {
                                          unconfirmedViewModel
                                              .onSaveUnConfirmedTransaction(
                                "A", "PAYMENT_ENTRY");
                          } else {
                                          AppSnackBar.of(context).show(
                                              "Please select one transaction");
                          }
                        },
                        child: Text(
                          "APPROVE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                                            color: ThemeProvider.of(context)
                                                .accentColor),
                        )),
                  ),
                              if (widget.approvalOptnName ==
                                      "GENERAL_VOUCHER" &&
                    transactionDtlList != null &&
                    (transactionDtlList?.isNotEmpty ?? false))
                  Container(
                    width: width,
                                  height:
                                      MediaQuery.of(context).size.height * .09,
                                  color: ThemeProvider.of(context)
                                      .primaryColorDark,
                    child: RaisedButton(
                        onPressed: () {
                                        UnConfirmedTransactionDetailList
                                            dataFromNotif;
                          dataFromNotif = UnConfirmedTransactionDetailList(
                                            transno: transactionDtlList
                                                    ?.first?.transNo ??
                                                "",
                                            transdate: transactionDtlList
                                                    ?.first?.transDate ??
                                                '',
                                            id: transactionDtlList?.first?.id ??
                                                0,
                                            unconfirmedid: transactionDtlList
                                                    ?.first?.unconfirmedid ??
                                                0,
                                            tableid: transactionDtlList
                                                    ?.first?.tableid ??
                                                0,
                                            refoptionid: transactionDtlList
                                                    ?.first?.reoptionId ??
                                                13,
                                            lastmoddate: transactionDtlList
                                                    ?.first?.lastmoddate ??
                                                "");

                          unconfirmedViewModel
                                            .onAddUnconfirmedData(
                                                dataFromNotif);
                          if (unconfirmedViewModel
                                  .addedUnconfirmedItems.length >
                              0) {
                                          unconfirmedViewModel
                                              .onSaveUnConfirmedTransaction(
                                "A", "GENERAL_VOUCHER");
                          } else {
                                          AppSnackBar.of(context).show(
                                              "Please select one transaction");
                          }
                        },
                        child: Text(
                          "APPROVE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                                            color: ThemeProvider.of(context)
                                                .accentColor),
                        )),
                  ),
              ],
                          )
                    : Center(
              child: BaseLoadingView(
                message: "Loading .. please wait",
              ),
            ));
      },
      onDispose: (store) async {
        isNotificationScreenClosed = true;
        final String musicsString = await BasePrefs.getString('CompanyList');
        final List<LoginModel> sharedPrefCompanyList =
        LoginModel.decode(musicsString);
        store.dispatch(
            fetchNotificationCountFromDb(loginModel: sharedPrefCompanyList));
        SignInState signInState = store.state.signInState;
        loginmodel.clientId = signInState.clientId;
        loginmodel.userName = signInState.userName;
        loginmodel.password = signInState.password;
        await store.dispatch(UnconfirmedTransactionDetailClearAction(
            unConfirmedTransactionDetailSave: false));
        String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
        int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
        store.dispatch(fetchNotificationCountFromDb());
        store.dispatch(
            fetchNotificationCount(clientid: clientId, userid: userId));

        store.dispatch(getMoreDetails(loginmodel));
      },
    );
  }

  Text buildText(String title) => Text(
        title,
        textAlign: TextAlign.start,
      );
  // showSuccessDialog(BuildContext context,) async {
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

class CheckBoxW extends StatefulWidget {
  const CheckBoxW({
    Key key,
    this.viewModel,
    this.transaction,
  }) : super(key: key);
  final UnConfirmedTransactionDetailViewModel viewModel;
  final UnConfirmedTransactionDetailList transaction;

  @override
  State<CheckBoxW> createState() => _CheckBoxWState();
}

class _CheckBoxWState extends State<CheckBoxW> {
  bool isChecked = false;

  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    BaseColors colors = BaseColors.of(context);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return themeData.dialogBackgroundColor;
      }
      return themeData.dialogBackgroundColor;
    }

    return Checkbox(
      checkColor: themeData.primaryColorDark,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool value) {
        setState(() {
          isChecked = value;
          if (value) {
            widget.viewModel.onAddUnconfirmedData(widget.transaction);
          } else {
            widget.viewModel.onRemoveUnconfirmedData(widget.transaction);
          }
        });
        print("ylo${widget.viewModel.addedUnconfirmedItems.length}");
      },
    );
  }
}

class UpdateSuccessDialog2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTitleTheme = BaseTheme.of(context).subhead1Bold;

    final String statusMessage = "${'Record updated successfully'}";

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          color: ThemeProvider.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 22.0),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * .09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 22.0),
                    SvgPicture.asset(BaseVectors.success),
                  ],
                ),
              ),
              const SizedBox(height: 13.0),
              Text(
                'Success ',
                style: textTitleTheme.copyWith(
                    color: Colors.white,
                    fontWeight: BaseTextStyle.semibold,
                    fontSize: 18,
                    letterSpacing: 1.5),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15.0),
              Text(
                '$statusMessage   ',
              ),
              const SizedBox(height: 15.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    color: ThemeProvider.of(context).primaryColorDark,
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'OK',
                    ),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
              const SizedBox(height: 22.0),
            ],
          ),
        ),
      ),
    );
  }
}
