import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request/transaction_unblock_request_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/data_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/_partials/alert_message_dialog.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/transaction_history.dart';

import '../../../../utility.dart';
import 'model/transaction_save_model.dart';

class TransUnblockReqApprovalEdit extends StatefulWidget {
  final int index;
  final List<TransactionUnblockListView> data;
  final TransactionUnblockReqApprlViewModel viewModel;
  final TranUnblockReqViewmodel viewModel2;
  final int id;
  final int pos;
  final int reportFormatId;
  final int optionIdFromBranchBlock;
  final int branchid;
  final bool fromBlocked;
  DataModel requestedHeader;
  var requestedValue;
  final bool isComingNotification;
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  int unblockBranchId;
  final bool allBranchYN;
  final bool onUserClickNotification;


  TransUnblockReqApprovalEdit(
      {Key key,
      this.index,
      this.optionIdFromBranchBlock,
      this.branchid,
      this.viewModel2,
      this.pos,
      this.id,
      this.reportFormatId,
      this.fromBlocked = false,
      this.data,
      this.viewModel,
      this.requestedHeader,
      this.requestedValue,
      this.transTableId,
      this.transId,
      this.approveOptionId,
      this.optionId,
      this.isComingNotification = false,
      this.unblockBranchId,
      this.allBranchYN,
      this.onUserClickNotification})
      : super(key: key);

  @override
  _TransUnblockReqApprovalEditState createState() =>
      _TransUnblockReqApprovalEditState(
//      model
          );
}

class _TransUnblockReqApprovalEditState
    extends State<TransUnblockReqApprovalEdit> {
  ApprovalSaveModel model = ApprovalSaveModel();
  var dataListLength;
  int _value;
  String _currentSelectedValue;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // @override
  // void initState() {
  //   model = ApprovalSaveModel();
  //   super.initState();
  // }

  DataModel unblockReqstNo;
  DataModel unblockTransNo;
  DataModel reqstNo;
  String approveOrRejectCode;
  String userSelected;
  bool isAfter = false;
  DateTime now = DateTime.now();
  DateTime initialDate = DateTime(
  DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    BaseTheme theme = BaseTheme.of(context);
    int optionId3;
    return BaseView<AppState, TransactionUnblockReqApprlViewModel>(
        init: (store, context) {
          store.dispatch(fetchActionTypes());
          log("is all branch selected"+widget.allBranchYN.toString());
        },
        converter: (store) =>
            TransactionUnblockReqApprlViewModel.fromStore(store),
        onDidChange: (viewModel, context) {
          if (viewModel.isTransReqAppvl) {
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              // Navigator.popUntil(
              //     context, (Route<dynamic> route) => route.isFirst);
              if(widget.onUserClickNotification) {
              Navigator.pop(context);
              Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            });
            viewModel.onTransactionApprlReqClearAction();
            viewModel.onRefreshCountData();
          } else if (viewModel.transactionUnblockRequestApprovalFailure ==
              true) {
            ///this dialog is given to solve concurrency issue
            showAlertMessageDialog(context, "",
                "${viewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
                    () {
              // Navigator.popUntil(
              //     context, (Route<dynamic> route) => route.isFirst);
                      if(widget.onUserClickNotification) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                });
            viewModel.resetTUApprovalFailure();
          }
        },
        onDispose: (store) async {
          if(!widget.onUserClickNotification) {
          // int branchId= await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
         int finalTransReqOptionId = widget.data[widget.index].requestoptionid;
          final optionId = store.state.homeState.selectedOption.optionId;
          int notificationOptionId = store.state.homeState.selectedOption.id;
          final notificationId = store.state.homeState.selectedOption.id;
          final optionId2 = store.state.homeState.menuItems.indexWhere(
                  (element) =>
              element.title == "Transaction Unblock Request Approval");
          if (optionId2 != null && optionId2 > 0) {
             optionId3 =
                store.state.homeState.menuItems[optionId2].module.optionId;
          }
          store.dispatch(fetchTransactionApprovalHeading(
              rptFormatId: widget.reportFormatId));
            store.dispatch(fetchTransactionApprovalReqList(
            branchId: widget.viewModel.isAllBranchSelected == true
                ? null
                : widget.branchid,
              transReqOptionId: finalTransReqOptionId,
              unblockBranchId: widget.unblockBranchId,
              // flg: flg,
            allBranchYN: widget.viewModel.isAllBranchSelected,
              id: widget.id,
              notificationOptionId: notificationId,
              notificationId: widget.id,
              optionId: optionId3 ?? widget.optionIdFromBranchBlock,
            ));
          store.dispatch(fetchUnreadCount(
              allBranchYN: widget.viewModel.isAllBranchSelected,
              branchId2: widget.branchid));
          }
        },
        appBar: BaseAppBar(
          title: Text(widget.fromBlocked == true
              ? widget.viewModel2.pendingTransactionDetailList[widget.pos]
                      .unblockrequestno ??
                  "Request Unblock Approval"
              : widget.data[widget.index].unblockrequestno ??
                  "Request Unblock Approval"),
          actions: [
            IconButton(
                onPressed: () {
                  BaseNavigate(
                      context,
                      TransactionHistoryPage(
                        tableDataId: widget.fromBlocked == true
                            ? widget
                                ?.viewModel2
                                ?.pendingTransactionDetailList[widget?.pos]
                                ?.unblockrequestreftabledataid
                            : widget?.data[widget?.index]
                                ?.unblockrequestreftabledataid,
                        tableId: widget.fromBlocked == true
                            ? widget
                                ?.viewModel2
                                ?.pendingTransactionDetailList[widget?.pos]
                                ?.unblockrequestreftableid
                            : widget
                                ?.data[widget?.index]?.unblockrequestreftableid,
                      ));
                },
                icon: Icon(Icons.access_time)),
          ],
        ),
        builder: (context, viewModel) {
          String dt2;
          DateTime dt =
              DateTime.parse(DateTime.now().toString().substring(0, 10) ?? "");
          dt2 = DateFormat("dd-MM-yyyy").format(dt);
          bool visibleAmount = false;
          if (widget.fromBlocked == true) {
            widget.viewModel2.pendingTransactionDetailList[widget.pos]
                        .requestedamount !=
                    null
                ? visibleAmount = true
                : visibleAmount = false;
          } else if (widget.data[widget.index] != null) {
            widget.data[widget.index].requestedamount != null
                ? visibleAmount = true
                : visibleAmount = false;
          }
          return Center(
            child: Material(
                color: themedata.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Divider(
                          thickness: 5,
                          color: themedata.scaffoldBackgroundColor,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 9, right: 9, bottom: 9),
                          height: height * .29,
                          width: width,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text("Blockage Date ",
                                              style: theme.smallHint),
                                        ),
                                        Flexible(
                                          child: Text(
                                              widget.fromBlocked == true
                                                  ? widget
                                                          .viewModel2
                                                          .pendingTransactionDetailList[
                                                              widget.pos]
                                                          .blockagedate ??
                                                      ""
                                                  : widget.data[widget.index]
                                                  .blockeddate,
                                              style: TextStyle(fontSize: 15)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text("Requested Person",
                                              style: theme.smallHint),
                                        ),
                                        Flexible(
                                          child: Text(
                                              widget.fromBlocked == true
                                                  ? widget
                                                          .viewModel2
                                                          .pendingTransactionDetailList[
                                                              widget.pos]
                                                          .requestedperson ??
                                                      ""
                                                  : widget.data[widget.index]
                                                  .unblockrequestedperson,
                                              style: TextStyle(fontSize: 15)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text("Requested Date & Time ",
                                              style: theme.smallHint),
                                        ),
                                        Flexible(
                                          child: Text(
                                              widget.fromBlocked == true
                                                  ? widget
                                                          .viewModel2
                                                          .pendingTransactionDetailList[
                                                              widget.pos]
                                                          .requesteddatetime ??
                                                      ""
                                                  : widget.data[widget.index]
                                                  .unblockrequesteddatetime,
                                              style: TextStyle(fontSize: 15)),
                                        )
                                      ],
                                    ),
                                    Visibility(
                                      visible: visibleAmount,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: Text("Amount ",
                                                style: theme.smallHint),
                                          ),
                                          Flexible(
                                            child: Text(
                                                widget.fromBlocked == true
                                                    ? BaseNumberFormat(
                                                        number: widget
                                                                .viewModel2
                                                                .pendingTransactionDetailList[
                                                                    widget.pos]
                                                                .requestedamount)
                                                        .formatCurrency()
                                                        .toString()
                                                    : BaseNumberFormat(
                                                            number: widget
                                                                .data[widget
                                                                    .index]
                                                                .requestedamount)
                                                        .formatCurrency()
                                                    .toString(),
                                                style: TextStyle(fontSize: 15)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                    Visibility(
                                      visible: widget.fromBlocked == true
                                          ? true
                                          : unblockTransNo != null
                                              ? true
                                              : false,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                                unblockTransNo?.header ?? "",
                                                style: theme.smallHint),
                                          ),
                                          Flexible(
                                            child: Text(
                                                unblockTransNo?.value ?? "",
                                                style: TextStyle(fontSize: 15)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text("Action Date",
                                                    style: theme.smallHint),
                                              ),
                                              Flexible(
                                                child: Text(
                                                    // widget.fromBlocked == true
                                                    //     ? widget
                                                    //             .viewModel2
                                                    //             .pendingTransactionDetailList[
                                                    //                 widget.pos]
                                                    //             .reconciledate ??
                                                    //         ""
                                                    //     : widget
                                                    //         .data[widget.index]
                                                    //         .unblockrequestdate,
                                                    dt2,
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 5,
                          color: themedata.scaffoldBackgroundColor,
                        ),
                        Flexible(
                          flex: 15,
                          child: ListView(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: _datePicker()),
                              _approvalRemark(
                                "Remarks",
                              ),
                              SizedBox(
                                height: 8,
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
                                              color: themedata.accentColor,
                                            ),
                                            SizedBox(
                                              width: 9,
                                            ),
                                            Text("Action Taken Against Whom")
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: BaseTextField(
                                          isEnabled: false,
                                          isVector: true,
                                          initialValue: widget.fromBlocked ==
                                                  true
                                              ? widget
                                                      .viewModel2
                                                      .pendingTransactionDetailList[
                                                          widget.pos]
                                                      .actiontakenagainst ??
                                                  ""
                                              : widget.data[widget.index]
                                                      .actiontakenagainst ??
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
                                              Icons
                                                  .perm_contact_calendar_outlined,
                                              color: themedata.accentColor,
                                            ),
                                            SizedBox(
                                              width: 9,
                                            ),
                                            Text("Action Taken")
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: BaseTextField(
                                            isEnabled: false,
                                            isVector: true,
                                            initialValue: widget.fromBlocked ==
                                                    true
                                                ? widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                                        .actiontaken ??
                                                    ""
                                                : widget.data[widget.index]
                                                        .actiontaken ??
                                                    ""),
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
                                              Icons
                                                  .perm_contact_calendar_outlined,
                                              color: themedata.accentColor,
                                            ),
                                            SizedBox(
                                              width: 9,
                                            ),
                                            Text("Blocking Reason")
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: BaseTextField(
                                          isEnabled: false,
                                          isVector: true,
                                          initialValue: widget.fromBlocked ==
                                                  true
                                              ? widget
                                                      .viewModel2
                                                      .pendingTransactionDetailList[
                                                          widget.pos]
                                                      .blockedreason ??
                                                  ""
                                              : widget.data[widget.index]
                                                  .blockedreason,
                                        ),
                                      ),
                                    ],
                                  )),
                              // Container(
                              //     //                            color: Colors.deepPurpleAccent,
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 10, vertical: 5),
                              //     //                          child:  Padding(
                              //     //                            padding: EdgeInsets.all(0),
                              //     child: BaseTextField(
                              //       displayTitle: "Action Taken Against whom",
                              //       initialValue: widget
                              //           .data[widget.index].actiontakenagainst,
                              //
                              //       // maxLines: widget?.data[widget?.index]
                              //       //                 ?.actiontakenagainst !=
                              //       //             null &&
                              //       //         widget
                              //       //             .data[widget.index]
                              //       //             .actiontakenagainst
                              //       //             .isNotEmpty &&
                              //       //         widget.data[widget.index]
                              //       //                 .actiontakenagainst.length >
                              //       //             42
                              //       //     ? 5
                              //       //     : 3,
                              //     )
                              //     //      Column(
                              //     //              crossAxisAlignment:
                              //     //                  CrossAxisAlignment.start,
                              //     //              children: [
                              //     //                Padding(
                              //     //                  padding: EdgeInsets.only(
                              //     //                      left: 0, bottom: 4),
                              //     //                  child: Row(
                              //     //                    children: [   Icon(
                              //     //                      Icons.ac_unit_sharp,
                              //     //                      color: Colors.white,
                              //     //                    ),
                              //     //                      SizedBox(
                              //     //                        width: 6,
                              //     //                      ),
                              //     //                      Text(
                              //     //                          "Action Taken Against Whom",style: theme.body2Hint,),
                              //     //                    ],
                              //     //                  ),
                              //     //                ),
                              //     //                Row(
                              //     //                  children: [
                              //     //
                              //     //                    SizedBox(
                              //     //                      width: 6,
                              //     //                    ),
                              //     //                    Flexible(
                              //     //                      child: Container(
                              //     //                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.06),
                              //     //                        child: TextFormField(
                              //     // maxLines:  widget
                              //     //     ?.data[widget
                              //     //     ?.index]
                              //     //     ?.actiontakenagainst!=null &&  widget
                              //     //     .data[widget
                              //     //     .index]
                              //     //     .actiontakenagainst.isNotEmpty && widget
                              //     //     .data[widget
                              //     //     .index]
                              //     //     .actiontakenagainst.length>42?5:3 ,
                              //     //                          enabled: false,
                              //     //                          initialValue: widget
                              //     //                              .data[widget
                              //     //                                  .index]
                              //     //                              .actiontakenagainst,
                              //     //                          decoration:
                              //     //                              InputDecoration(
                              //     //                                disabledBorder: UnderlineInputBorder(
                              //     //                              borderSide:
                              //     //                              BorderSide(color: theme.colors.white.withOpacity(0.70))),
                              //     //                                  enabledBorder: UnderlineInputBorder(
                              //     //                                      borderSide:
                              //     //                                      BorderSide(color: theme.colors.white.withOpacity(0.70))),
                              //     //                                  labelStyle:
                              //     //                                      TextStyle(
                              //     //                                          color:
                              //     //                                              Colors.white)),
                              //     //                        ),
                              //     //                      ),
                              //     //                    ),
                              //     //                  ],
                              //     //                ),
                              //     //              ],
                              //     //            ),
                              //     ),
                              // _actionTaken("Action Taken"),
                              // _ActualBlkReason("Blocking Reason"),

                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                        Row(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceEvenly,
                            children: widget.viewModel == null
                                ? viewModel.actionTypes.map((e) {
                          final bool reject = e.code == "REJECTED";
                          return Container(
                            width: width / 2,
                            child: _TransApprovalButton(
                                color: reject
                                    ? Colors.white
                                    : themedata.primaryColorDark,
                                          icon: reject
                                              ? Icons.delete_forever
                                              : Icons.check,
                                title: reject
                                    ? Text(
                                                  'reject'.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                                      color: themedata
                                                          .primaryColorDark),
                                      )
                                              : Text(
                                                  'approve'?.toUpperCase() ??
                                                      "",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                onPressed: () {
                                  //   bool isApprExtendedDate = false;
                                  setState(() {
                                    userSelected = e.code;
                                  });

                                            final FormState form =
                                                _formKey.currentState;
                                  if (!form.validate()) {
                                    print(
                                        'Form is not valid!  Please review and correct.');
                                  } else {
                                              form.save();
                                              viewModel.onSave(
                                                DateTime.now(),
                                                model?.remarks ?? "",
                                                e.code == "REJECTED"
                                                    ? "R"
                                                    : "A",
                                                e.code == "REJECTED"
                                                    ? null
                                                    : model?.extendedDate ??
                                                        DateTime.now(),
                                                widget.fromBlocked != true
                                                    ? widget
                                                        ?.data[widget?.index]
                                                        ?.transunblockrequestid
                                                    : widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                                        .transunblockrequestid,
                                                widget.fromBlocked != true
                                                    ? widget
                                                        ?.data[widget?.index]
                                                        ?.unblockrequestreftableid
                                                    : widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                                        .unblockrequestreftableid,
                                                widget.fromBlocked != true
                                                    ? widget
                                                        ?.data[widget?.index]
                                                        ?.unblockrequestreftabledataid
                                                    : widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                                        .unblockrequestreftabledataid,
                                              );
                                            }
                                    // }
                                            viewModel.onApprvalModelSave(model);
                                            print(model);
                                          }),
                                    );
                                  }).toList()
                                : widget.viewModel.actionTypes.map((e) {
                                    final bool reject = e.code == "REJECTED";
                                    return Container(
                                      width: width / 2,
                                      child: _TransApprovalButton(
                                          color: reject
                                              ? Colors.white
                                              : themedata.primaryColorDark,
                                          icon: reject
                                              ? Icons.delete_forever
                                              : Icons.check,
                                          title: reject
                                              ? Text(
                                                  'reject'.toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: themedata
                                                          .primaryColorDark),
                                                )
                                              : Text(
                                                  'approve'?.toUpperCase() ??
                                                      "",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                          onPressed: () {
                                            //   bool isApprExtendedDate = false;
                                            setState(() {
                                              userSelected = e.code;
                                            });

                                            final FormState form =
                                                _formKey.currentState;
                                            if (!form.validate()) {
                                              print(
                                                  'Form is not valid!  Please review and correct.');
                                            } else {
                                    form.save();
                                    viewModel.onSave(
                                      DateTime.now(),
                                      model?.remarks ?? "",
                                                e.code == "REJECTED"
                                                    ? "R"
                                                    : "A",
                                      e.code == "REJECTED"
                                          ? null
                                          : model?.extendedDate ??
                                              DateTime.now(),
                                                widget.fromBlocked != true
                                                    ? widget.data[widget.index]
                                                        .transunblockrequestid
                                                    : widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                          .transunblockrequestid,
                                                widget.fromBlocked != true
                                                    ? widget.data[widget.index]
                                                        .unblockrequestreftableid
                                                    : widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                          .unblockrequestreftableid,
                                                widget.fromBlocked != true
                                                    ? widget.data[widget.index]
                                                        .unblockrequestreftabledataid
                                                    : widget
                                                        .viewModel2
                                                        .pendingTransactionDetailList[
                                                            widget.pos]
                                          .unblockrequestreftabledataid,
                                    );
                                  }
                                  //}
                                  viewModel.onApprvalModelSave(model);
                                  print(model);
                                }),
                          );
                        }).toList()),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ))),
          );
        });
  }

  Widget _buildDateField(
    String title,
    DateTime initialDate,
    Function(DateTime) onChanged,
    Function(DateTime) onSaved,
    //  Function(DateTime) validator,
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
          // validator: validator,
          // validator: (val) {
          //   if (isAfter) {
          //     return "Invalid Date";
          //   } else {
          //     return null;
          //   }
          // },
        ),
      ),
    );
  }

  Widget _ActualBlkReason(String title) {
    return Container(
//      color: Colors.deepPurpleAccent,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          isEnabled: false,
          displayTitle: title,
          // maxLines: widget.data[widget.index].blockedreason.isNotEmpty &&
          //         widget.data[widget.index].blockedreason.length > 20
          //     ? 5
          //     : 2,
          initialValue: widget.data[widget.index].blockedreason,
          // onChanged: (val) => model?.reqNo = val,
          // onSaved: (val) => model?.reqNo = val,
          autovalidate: false,
        ));
  }

  Widget _approvalRemark(String title) {
    return Container(
//      color: Colors.deepPurpleAccent,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          displayTitle: title,
          maxLength: 250,
          initialValue: "",
          vector: AppVectors.remarks,
          // inputFormatters: [
          //   new LengthLimitingTextInputFormatter(4),
          // ],
          onChanged: (val) => model?.remarks = val,
          onSaved: (val) => model?.remarks = val,
          validator: (val) {
            if (userSelected == "REJECTED" && val.isEmpty) {
              return "Please Enter remarks";
            } else {
              return null;
            }
          },
          autovalidate: false,
        ));
  }

  Widget _datePicker() {
    String _format(DateTime date) => "${DateFormat.yMMMd().format(date)}";
    ThemeData themedata = ThemeProvider.of(context);
    return TextFormField(
      validator: (val) {
        if (userSelected == "APPROVED" && model?.extendedDate == null) {
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
            model.extendedDate = selectedDate;
            _dateController.text = DateFormat.yMMMd().format(selectedDate);
          });
        }
      },
    );
  }

  String validationNeed() {
    return userSelected;
  }

  Widget _actionTaken(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          isEnabled: false,
          displayTitle: title,
          icon: Icons.money,
          // maxLines: widget.data[widget.index].actiontaken.isNotEmpty &&
          //          widget.data[widget.index].actiontaken.length > 20
          //      ? 5
          //      : 2,
          initialValue: (widget.data[widget.index].actiontaken ?? ""),
          //  onChanged: (val) => model?.transNo = val,
          //  onSaved: (val) => model?.transNo = val,
          autovalidate: false,
        ));
  }

  Widget _buildFilterButton(TransactionUnblockReqApprlViewModel viewModel) {
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {
          _submitForm(viewModel);
        },
        child: Text(
          'Save',
          style: BaseTheme.of(context).bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        color: themedata.primaryColorDark,
      ),
    );
  }

  void _submitForm(TransactionUnblockReqApprlViewModel viewModel) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      viewModel.onSave(
        DateTime.now(),
        model?.remarks ?? "",
        model?.approvalStatus?.code == "APPROVED" ? "A" : "R",
        model?.extendedDate,
        widget.fromBlocked != true
            ? widget.data[widget.index].transunblockrequestid
            : widget.viewModel2.pendingTransactionDetailList[widget.pos]
                .transunblockrequestid,
        widget.fromBlocked != true
            ? widget.data[widget.index].unblockrequestreftableid
            : widget.viewModel2.pendingTransactionDetailList[widget.pos]
                .unblockrequestreftableid,
        widget.fromBlocked != true
            ? widget.data[widget.index].unblockrequestreftabledataid
            : widget.viewModel2.pendingTransactionDetailList[widget.pos]
                .unblockrequestreftabledataid,
      );
      viewModel.onApprvalModelSave(model);

      print(model);
    }
  }
}

class _TransApprovalButton extends StatelessWidget {
  final Widget title;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;
  final TextStyle style;

  const _TransApprovalButton(
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
