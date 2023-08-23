import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/document_approval/_views/success_dialog.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/_partials/alert_message_dialog.dart';
//import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/temp_transaction_approval_dtl.dart';

import '../../../../utility.dart';

class TransactionUnblockNotificationScreen extends StatefulWidget {
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  final bool onUserClickNotification;
  var clientIdFrmNoti;
  var branchId;
  TransactionUnblockNotificationScreen(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.approveOptionId,
      this.clientIdFrmNoti,
      this.branchId,
      this.onUserClickNotification});

  @override
  _TransactionUnblockNotificationScreenState createState() =>
      _TransactionUnblockNotificationScreenState(
          optionId: optionId,
          transTableId: transTableId,
          transId: transId,
          approveOptionId: approveOptionId,
          clientIdFrmNoti: clientIdFrmNoti,
          branchId: branchId,
          onUserClickNotification: onUserClickNotification);
}

class _TransactionUnblockNotificationScreenState
    extends State<TransactionUnblockNotificationScreen> {
  var transTableId;
  var transId;
  var optionId;
  var branchId;
  var approveOptionId;
  var clientIdFrmNoti;
  bool onUserClickNotification;
  String responseMessage = 'Oops! Something went wrong!';

  String userSelected;

  _TransactionUnblockNotificationScreenState(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.branchId,
      this.approveOptionId,
      this.clientIdFrmNoti,
      this.onUserClickNotification});

  String transTableName;

  DateTime extedndedDate;
  var dtltablereryn;
  String tableName;
  String _remarks;

  String initialValue;
  String clientId;
  String hint = "Enter Remarks";
  String displayTitle = "Remarks";
  Function(String val) validator;
  Function(String val) onSaved;
  bool isPassword = false;
  bool isAfter = false;
  LoginModel login = LoginModel();
  String prefClientId;
  final GlobalKey approvalFormKey = GlobalKey();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BaseView<AppState, TransactionUnblockReqApprlViewModel>(
        // key: _scaffold,
        isShowErrorSnackBar: false,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor:
              ThemeProvider.of(context).primaryColor ?? Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            // padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3,vertical: 12),
            child: Center(
              child: Text('Request for Approval',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: .35,
                    color: Colors.white,
                    fontSize: 16,
                  )),
            ),
          ),
          elevation: 0.5,
        ),
        init: (store, context) async{
          prefClientId = await BasePrefs.getString("notifCompany");
          clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
          isNotificationScreenClosed = false;
          int notificationOptionId =
              store.state?.homeState?.selectedOption?.id ?? 700;
          store.dispatch(fetchActionTypes());
          if (widget?.optionId != null &&
              widget.transTableId != null &&
              widget.transId != null) {
            store.dispatch(
                fetchTransactionUnblockApprovalNotificationClickAction(
              optionId: int?.tryParse(widget?.optionId),
              transId: int?.tryParse(widget?.transId),
              transTableId: int?.tryParse(widget?.transTableId),
            ));
            if (approveOptionId != null &&
                transId != null &&
                transTableId != null &&
                optionId != null)
              store.dispatch(setNotificationAsRead(
                  optionId: num?.parse(approveOptionId),
                  transTableId: num?.parse(transId),
                  transId: num?.parse(transTableId),
                  notificationId: num?.parse(optionId)));
          }
        },
        onDispose: (store) async{
          isNotificationScreenClosed = true;
          final String musicsString = await BasePrefs.getString('CompanyList');
          final List<LoginModel> sharedPrefCompanyList =
          LoginModel.decode(musicsString);
          SignInState signInState = store.state.signInState;
          login.clientId = signInState.clientId;
          login.userName = signInState.userName;
          login.password = signInState.password;
          store.dispatch(
              fetchNotificationCountFromDb(loginModel: sharedPrefCompanyList));
          store.dispatch(getMoreDetails(login));

          String clientId =
              await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
          int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
          store.dispatch(
              fetchNotificationCount(clientid: clientId, userid: userId));
        },
        converter: (store) =>
            TransactionUnblockReqApprlViewModel.fromStore(store),
        onDidChange: (viewModel, context) {
          log(viewModel.isTransReqAppvlNotification.toString());
          if (viewModel.isTransReqAppvlNotification) {
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              // Navigator.popUntil(
              //     context, (Route<dynamic> route) => route.isFirst);
              Navigator.pop(context);
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              //   builder: (BuildContext context) {
              //     return HomePage();
              //   },
              // ), (_) => true);
            });
            viewModel.onTransactionApprlReqClearAction();
          } else if (viewModel.transactionUnblockRequestApprovalFailure ==
              true) {
            log("dialog_executed");

            ///this dialog is given to solve concurrency issue
            showAlertMessageDialog(context, "",
                "${viewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
                    () {
                      // Navigator.popUntil(
                      //     context, (Route<dynamic> route) => route.isFirst);
                      Navigator.pop(context);
                      Navigator.pop(context);
                });
            viewModel.resetTUApprovalFailure();
          }
        },
        builder: (context, viewModel) {
          return clientId != widget.clientIdFrmNoti
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
              : prefClientId == null || prefClientId == ""
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: height * .07,
                            width: width * .3,
                            child: BaseClearButton(
                                      borderRadius: BorderRadius.circular(15),
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
              :viewModel.notificationModel != null &&
                  viewModel.loadingError.isEmpty &&
                          viewModel.notificationModel?.notificationItems !=
                              null &&
                  viewModel?.notificationModel?.notificationItems
                          ?.transactionDtl?.length >
                      0
              ? Column(children: <Widget>[
                  SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: approvalFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                        child:
                                            TransactionUnblockApprovalListViewScreen(
                                              header:viewModel
                                                  .notificationModel
                                                  .notificationItems
                                                  .reportformatDtl
                                                  .first.dtl,
                                      reportHeader: viewModel
                                          .notificationModel
                                          .notificationItems
                                          .reportformatDtl
                                          .first,
                              reportData: viewModel.notificationModel
                                  .notificationItems.transactionDtl,
                              viewModel: viewModel,
                              isNotificationView: false,
                                      onUserClickNotification:
                                          onUserClickNotification,
                            )),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              child: Container(
                                  color: themeData.primaryColor,
                                  child: _datePicker()),
                            ),
                            Flexible(
                              child: Container(
                                        color: ThemeProvider.of(context)
                                            .primaryColor,
                                margin: EdgeInsets.only(top: 5),
                                child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        _remarks = val;
                                      });
                                    },
                                            style:
                                                TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    enabled: true,
                                    obscureText: isPassword,
                                            textInputAction:
                                                TextInputAction.done,
                                    initialValue: initialValue,
                                    //autovalidate: false,
                                    validator: (val) {
                                      if (userSelected == "REJECTED" &&
                                          val.isEmpty) {
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
                                                    borderSide:
                                                        BaseBorderSide()),
                                        labelText: displayTitle,
                                        errorStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintStyle: style.smallHint
                                                    .copyWith(
                                                        color: Colors.white),
                                        //      icon: Icon(Icons.description, size: 18),
                                        contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 1)),
                                    //   onSaved: onSaved
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .perm_contact_calendar_outlined,
                                                    color:
                                                        themeData.accentColor,
                                          ),
                                          SizedBox(
                                            width: 9,
                                          ),
                                                  Text(
                                                      "Action Taken Against Whom")
                                        ],
                                      ),
                                    ),
                                    Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                      child: BaseTextField(
                                        isEnabled: false,
                                        isVector: true,
                                        initialValue: viewModel
                                                ?.notificationModel
                                                ?.notificationItems
                                                ?.transactionDtl
                                                ?.first
                                                ?.actiontakenagainst ??
                                            "",
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.padding,
                                                    color:
                                                        themeData.accentColor,
                                          ),
                                          SizedBox(
                                            width: 9,
                                          ),
                                          Text("Action Taken ")
                                        ],
                                      ),
                                    ),
                                    Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                      child: BaseTextField(
                                        isVector: true,
                                        isEnabled: false,
                                        // displayTitle: "Action Taken",
                                        // vector: AppVectors.addnew,
                                        initialValue: viewModel
                                            ?.notificationModel
                                            ?.notificationItems
                                            ?.transactionDtl
                                            ?.first
                                            ?.actiontaken,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.message_outlined,
                                                    color:
                                                        themeData.accentColor,
                                          ),
                                          SizedBox(
                                            width: 9,
                                          ),
                                          Text("Blocking Reason")
                                        ],
                                      ),
                                    ),
                                    Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                      child: BaseTextField(
                                        isVector: true,
                                        isEnabled: false,
                                        initialValue: viewModel
                                            ?.notificationModel
                                            ?.notificationItems
                                            ?.transactionDtl
                                            ?.first
                                            ?.blockedreason,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(height: 12),
                  //  if (fetchBccIdModel?.resultApprovalTypes != null)
                  Container(
                    // padding:
                    //     EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 6),
                    height: MediaQuery.of(context).size.height * .14,
                    color: ThemeProvider.of(context).primaryColor,
                    child: Row(
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceEvenly,
                        children: viewModel.actionTypes.map((e) {
                      final bool reject = e.code == "REJECTED";
                      return Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: _ApprovalButton(
                          color: reject
                              ? Colors.white
                                      : ThemeProvider.of(context)
                                          .primaryColorDark,
                                  icon: reject
                                      ? Icons.delete_forever
                                      : Icons.check,
                          title: reject
                              ? Text(
                                  'reject'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ThemeProvider.of(context)
                                          .primaryColorDark),
                                )
                              : Text('approve'.toUpperCase() ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                          onPressed: () {
                            setState(() {
                              userSelected = e.code;
                            });
                                    final FormState form =
                                        approvalFormKey.currentState;
                            if (!form.validate()) {
                              print(
                                  'Form is not valid!  Please review and correct.');
                            } else {
                              form.save();
                              viewModel.onSaveFromNotification(
                                DateTime.now(),
                                _remarks,
                                e.code == "REJECTED" ? "R" : "A",
                                e.code == "REJECTED"
                                    ? null
                                    : extedndedDate ?? DateTime.now(),
                                viewModel
                                    .notificationModel
                                    ?.notificationItems
                                    ?.transactionDtl
                                    ?.first
                                    ?.transunblockrequestid,
                                viewModel
                                    ?.notificationModel
                                    ?.notificationItems
                                    ?.transactionDtl
                                    ?.first
                                    ?.unblockrequestreftableid,
                                viewModel
                                    ?.notificationModel
                                    ?.notificationItems
                                    ?.transactionDtl
                                    ?.first
                                    ?.unblockrequestreftabledataid,
                              );
                            }
                          },
                        ),
                      );
                    }).toList()),
                  )
                ])
              : viewModel.notificationModel?.notificationItems != null &&
                      viewModel.notificationModel.notificationItems
                              .transactionDtl.length ==
                          0
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
                                          "This transaction already removed from blockage.",
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
              : viewModel.loadingError.isNotEmpty &&
                                  (!viewModel.loadingError
                                      .contains("Exception: null"))
                  ? AlertDialog(
                      backgroundColor: themeData.primaryColor,
                      title: Center(child: Text("Alert")),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 5),
                      content: Container(
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(25)),
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
                                                        top: 8,
                                                        right: 8,
                                                        left: 8),
                                        child: Text(
                                              "${(viewModel?.loadingError ?? "").toString().replaceFirst("Exception:", "") ?? "Transaction Already Taken"}",
                                                      textAlign:
                                                          TextAlign.center,
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
                                                  backgroundColor: themeData
                                                      .primaryColorDark,
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
                  // showDialog(
                  //             context: context,
                  //             builder: (context) => showAlertMessageDialog(context, "",
                  //                     "${viewModel.loadingError.toString().replaceFirst("ERROR:", "") ??
                  //                     "Transaction Already Taken"}",
                  //                     () {
                  //                   Navigator.pop(context);
                  //                 }))
                  : Center(
                      child: BaseLoadingView(
                        message: "Fetching Notification Data",
                      ),
                    );
        });
  }

  Widget _datePicker() {
    String _format(DateTime date) => "${DateFormat.yMMMd().format(date)}";
    ThemeData themedata = ThemeProvider.of(context);
    return TextFormField(
      validator: (val) {
        if (userSelected == "APPROVED" && extedndedDate == null) {
          return "Please select Extended date";
        } else {
          return null;
        }
      },
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: BaseTheme.of(context).colors.white.withOpacity(0.70))),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: BaseTheme.of(context).colors.white.withOpacity(0.70))),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: BaseTheme.of(context).colors.white.withOpacity(0.70))),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: BaseTheme.of(context).colors.white.withOpacity(0.70))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: BaseTheme.of(context).colors.white.withOpacity(0.70))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: BaseTheme.of(context).colors.white.withOpacity(0.70))),
          errorStyle: BaseTheme.of(context).body2.copyWith(
              fontSize: 14, color: BaseTheme.of(context).colors.white),
          labelText: "Extended Date",
          labelStyle: BaseTheme.of(context).body2.copyWith(
              color: themedata.accentColor, fontWeight: FontWeight.w400),
          icon: Icon(
            Icons.event,
            color: themedata.accentColor,
          ),
          //hintText: "Extended Date",
          hintStyle: BaseTheme.of(context)
              .body2
              .copyWith(color: themedata.accentColor)),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          firstDate:

              // DateTime(2000, 2),

              DateTime.now().subtract(Duration(days: 0)),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: themedata.primaryColor, // header background color
                  onPrimary: Colors.white,
                  // header text color// body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: themedata.primaryColorDark, // button text color
                  ),
                ),
              ),
              child: child,
            );
          },
          // selectableDayPredicate: (day) => day.isBefore(DateTime.now()),
        );
        if (selectedDate != null) {
          setState(() {
            extedndedDate = selectedDate;
            _dateController.text = DateFormat.yMMMd().format(selectedDate);
          });
        }
      },
    );
  }

  Widget _buildDateField(
    String title,
    DateTime initialDate,
    Function(DateTime) onChanged,
    Function(DateTime) onSaved,
  ) {
    return Visibility(
      visible: userSelected == "REJECTED" ? false : true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseDatePicker(
          isVector: true,
          hint: title,
          icon: Icons.calendar_today,
          displayTitle: title,
          initialValue: initialDate,
          disablePreviousDates: true,
          autovalidate: true,
          onChanged: onChanged,
          onSaved: onSaved,
          // validator: (val) {
          //   if (initialDate.isAfter(DateTime.now())) {
          //     return "Invalid Date";
          //   } else {
          //     return null;
          //   }
          // },
        ),
      ),
    );
  }

  Widget textDataField(String title, String initialValue) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          isEnabled: true,
          displayTitle: title,
          icon: Icons.money,
          initialValue: initialValue,
          autovalidate: false,
        ));
  }

  showSuccessDialog1(
    BuildContext context,
  ) async {
    await appShowChildDialog<bool>(
        context: context,
        child: UpdateSuccessDialog(),
        barrierDismissible: true);
    Navigator.pop(context);
  }
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
