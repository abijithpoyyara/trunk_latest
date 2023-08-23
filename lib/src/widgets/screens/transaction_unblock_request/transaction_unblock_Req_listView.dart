import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request/transaction_unblock_request_viewmodel.dart';
//import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval_action/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request/tran_req_edit_dcreen.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/approval_notification_dtl.dart';

import '../../../../utility.dart';

class TransactionReqViewList extends StatefulWidget {
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  var reportFormtId;
  var id;
  var start;
  var st;
  var branchId;
  String reqTitle;
  int flag;
  final bool isUserRightToApprove;

  TransactionReqViewList(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.approveOptionId,
      this.id,
      this.branchId,
      this.reportFormtId,
      this.start,
        this.reqTitle,
      this.flag,
      this.isUserRightToApprove,
      this.st});

  @override
  _TransactionViewListState createState() => _TransactionViewListState(
      optionId: optionId,
      transTableId: transTableId,
      transId: transId,
      approveOptionId: approveOptionId);
}

class _TransactionViewListState extends State<TransactionReqViewList> {
  var transTableId;
  var transId;
  List transactionList;
  List documentList;

  var optionId;
  var approveOptionId;

  _TransactionViewListState(
      {this.optionId, this.transTableId, this.transId, this.approveOptionId});

  String userName;
  String password;

  int userId;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    userName = await BasePrefs.getString(BaseConstants.USERNAME_KEY);
    password = await BasePrefs.getString(BaseConstants.PASSWORD_KEY);
    userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                ThemeProvider.of(context).primaryColor),
          ),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    setState(() {});
    BaseTheme style = BaseTheme.of(context);
    var newMapEntry;
    return BaseView<AppState, TranUnblockReqViewmodel>(
        converter: (store) => TranUnblockReqViewmodel.fromStore(store),
        builder: (context, viewModel) {
          return viewModel.pendingTransactionDetailList.isNotEmpty &&
                  viewModel.pendingTransactionDetailList != null
          ? Scaffold(
              appBar: BaseAppBar(
                title: Text(widget.reqTitle),
              ),
              body: Column(children: <Widget>[
                SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                            Visibility(
                              visible: widget.flag==1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.green,
                                        )),
                                    SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      .025,
                                    ),
                                    Text(
                                        "Pending Transaction Unblock Approval Request") //RD2111-22
                                  ],
                                ),
                              ),
                            ),
                        // if (dtlList != null && dtlTransList != null)
                        Flexible(
                          fit: FlexFit.loose,
                          child: viewModel.pendingTransactionDetailList
                              .isNotEmpty &&
                              viewModel.pendingTransactionDetailList !=
                                  null
                              ? ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                                itemCount: viewModel
                                    .pendingTransactionDetailList.length,
                            itemBuilder:
                                (BuildContext context, int pos) {
                                  newMapEntry = viewModel
                                  .pendingTransactionDetailList[pos]
                                  .data
                                      .remove("maxextendeddate");

                                  return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                                print(widget
                                                    .isUserRightToApprove);
                                      viewModel
                                          .pendingTransactionDetailList[
                                      pos]
                                          .transreqyn ==
                                                            "Y" &&
                                                        widget.isUserRightToApprove ==
                                                            true
                                          ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransUnblockReqApprovalEdit(
                                                    viewModel2:
                                                    viewModel,
                                                    id: widget.id,
                                                    pos: pos,
                                                    fromBlocked:
                                                    true,
                                                  ))).then((value) =>
                                          viewModel.getDtl(
                                              widget
                                                  .reportFormtId,
                                              widget.id,
                                              widget.st,
                                              widget.branchId,
                                              viewModel.optionId))
                                          : print("no");
                                    },
                                    child: Container(
                                    padding: EdgeInsets.all(9),
                                    margin: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 10),
                                    decoration: BoxDecoration(
                                            color: widget.flag == 1
                                                ? (viewModel
                                                            .pendingTransactionDetailList[
                                                                pos]
                                                            .transreqyn ==
                                                        "Y"
                                                    ? Colors.green
                                              : themeData
                                              .primaryColor)
                                              : themeData
                                              .primaryColor,
                                            borderRadius:
                                          BorderRadius.circular(
                                              8)),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: viewModel
                                              .transactionReqHeadingList
                                              .transactionReqHeadingList
                                              .first
                                              .dtl
                                              ?.map<Widget>((mode) {
                                                return Column(
                                                  children: [
                                                  Row(children: [
                                                          Expanded(
                                                            child: Text(
                                                                  (mode?.header ==
                                                                              null ||
                                                                        mode?.header ==
                                                                            "Trans. Unblock <BR> Request <BR>Extended Date"
                                                                  ? ''
                                                            : '${mode?.header} '.replaceAll(
                                                                            "<BR>",
                                                                  "")),
                                                                      maxLines: 2,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                        mode?.formatnumberyn ==
                                                            "Y"
                                                              ? BaseNumberFormat(
                                                                              number: num.parse('${viewModel.pendingTransactionDetailList[pos]?.data[mode?.dataindex] ?? 0}'))
                                                              .formatCurrency()
                                                              : '${viewModel.pendingTransactionDetailList[pos]?.data[mode?.dataindex] ?? ""}',
                                                        maxLines: 2,
                                                        style:
                                                        TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                      height: 6,
                                                  ),
                                                      ],
                                                    );
                                          })?.toList(),
                                        ),
                                          GestureDetector(
                                            onTap: () {
                                              //TransUnblockReqlEdit();
                                              // BaseNavigate(context,TransUnblockReqlEdit());w
                                              widget.flag != 1
                                                            ? BaseNavigate(
                                                                context,
                                                                TransUnblockReqlEdit(
                                                                  viewmodel:
                                                                      viewModel,
                                                id: widget.id,
                                                                  pos: pos,
                                                                ))
                                                  : print(
                                                  "blocked notification");
                                            },
                                            child: Visibility(
                                                        visible:
                                                            widget.flag != 1,
                                              child: Container(
                                                child: Center(
                                                            child: Text(
                                                                "Request unblock"),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: themeData
                                                        .primaryColorDark,
                                                    borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                        8)),
                                                          width: MediaQuery.of(
                                                                  context)
                                                    .size
                                                    .width,
                                                height: 40,
                                              ),
                                            ),
                                          )
                                      ],
                                      ),
                                    ),
                                  ),
                                      if (widget.flag == 1)
                                        Positioned(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .02,
                                            child: CircleAvatar(
                                              backgroundColor: viewModel
                                                          .pendingTransactionDetailList[
                                                              pos]
                                                          .blockedyn ==
                                                      "Y"
                                                  ? Colors.red
                                                  : Colors.yellow,
                                              radius: 10,
                                              child: viewModel
                                                          .pendingTransactionDetailList[
                                                              pos]
                                                          .blockedyn ==
                                                      "Y"
                                                  ? Icon(
                                                      Icons.block,
                                                      color: Colors.white,
                                                      size: 12,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .warning_amber_rounded,
                                                      color: Colors.black,
                                                      size: 12,
                                                    ),
                                            )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                              )
                                  : Center(
                                child: BaseLoadingView(
                                  message: "loading List",
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                  ]))
              : Scaffold(
            body: Center(
              child: BaseLoadingView(
                message: "loading List",
              ),
            ),
          );
        });
  }

  showDialog(int id, int pos, TranUnblockReqViewmodel viewmodel) {
    appShowChildDialog(
        context: context,
        child: TransUnblockReqApprovalEdit(
          viewModel2: viewmodel,
          id: id,
          pos: pos,
          fromBlocked: true,
        ));
  }
}

//(mode?.header ==
//null||mode?.header=="Trans. Unblock <BR> Request <BR>Extended Date"
//? ''
//: '${mode
//    ?.header} :'
//.replaceAll(
//"<BR>",
//"")),
//maxLines: 2,
