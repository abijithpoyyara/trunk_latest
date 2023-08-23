import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/unconfirmed_transaction_details/unconfirmed_transaction_details_viewmodel.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';
import 'package:redstars/utility.dart';

class UnConfirmedTransactionNotificationScreen extends StatefulWidget {
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  var refOptnName;
  final bool isFromNotificationClick;


  UnConfirmedTransactionNotificationScreen({Key key, this.optionId,this.approveOptionId,this.isFromNotificationClick,this.refOptnName,this.transId,this.transTableId, }) : super(key: key);
  @override
  _UnConfirmedTransactionNotificationScreenState createState() =>
      _UnConfirmedTransactionNotificationScreenState();
}

class _UnConfirmedTransactionNotificationScreenState
    extends State<UnConfirmedTransactionNotificationScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);

    showSuccessDialog(BuildContext context) async {
      await appShowChildDialog<bool>(
          context: context,
          child: UpdateSuccessDialog2(),
          barrierDismissible: true);
      Navigator.pop(context);
    }

    return BaseView<AppState, UnConfirmedTransactionDetailViewModel>(
      init: (store, context) {
        final filter = store.state.unConfirmedTransactionDetailState;
        store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());

        store.dispatch(fetchUnconfirmedTransactionListAction(
            filterModel: UnConfirmedFilterModel(
                optionCode:
                BCCModel(description: widget.refOptnName == "PAYMENT_ENTRY"
                    ? "Payment Voucher" : "Sales Invoice",code: widget.refOptnName)
            )));
        if (widget?.optionId != null &&
            widget.transTableId != null &&
            widget.transId != null) {
          store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
          store.dispatch(
              fetchUnconfirmedNotificationClickAction(
                optionId: int?.tryParse(widget?.optionId),
                transId: int?.tryParse(widget?.transId),
                transTableId: int?.tryParse(widget?.transTableId),
              ));
        };
        store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
      },
      onDidChange: (unconfirmedViewModel, context) {
        if (unconfirmedViewModel.unConfirmedTransactionDetailSave) {

          showSuccessDialog(context);

          unconfirmedViewModel.onUnconfirmedClearAction();
          unconfirmedViewModel.onCalledAfterSave();
          unconfirmedViewModel.onUserSelect(UnConfirmedFilterModel(
              fromDate: unconfirmedViewModel.unConfirmedFilterModel.fromDate,
              toDate: DateTime.now(),
              optionCode: null));
        }
      },
      onDispose: (store) {
        store.dispatch(OnClearAction())  ;
        store.dispatch(UnconfirmedTransactionDetailClearAction(unConfirmedTransactionDetailSave: false));
      },
      converter: (store) =>
          UnConfirmedTransactionDetailViewModel.fromStore(store),
      builder: (context, unconfirmedViewModel) {
        unconfirmedViewModel.onChangeUnconfirmedFilter(UnConfirmedFilterModel(
            optionCode: BCCModel(description: widget.refOptnName == "PAYMENT_ENTRY"
            ? "Payment Voucher" : "Sales Invoice" , code: widget.refOptnName,
        )));

        unconfirmedViewModel.unConfirmedFilterModel.optionCode =
            BCCModel(description: widget.refOptnName == "PAYMENT_ENTRY"
            ? "Payment Voucher" : "Sales Invoice" , code: widget.refOptnName,
        );
        return Scaffold(
          appBar: BaseAppBar(
            title: Text("Unconfirmed Transaction - ${widget.refOptnName
                == "PAYMENT_ENTRY" ? "Payment Voucher" : "Sales Invoice"}"),
          ),

          body: unconfirmedViewModel?.unconfirmedNotificationModel!=null &&
              unconfirmedViewModel?.unconfirmedNotificationModel?.notificationItems != null /*&&
              (unconfirmedViewModel?.unconfirmedNotificationModel?.notificationItems?.transactionDtl?.isNotEmpty??false)*/
              ? Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
              ),
              Expanded(
                child: unconfirmedViewModel?.unconfirmedNotificationModel!=null?
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: unconfirmedViewModel?.unconfirmedNotificationModel?.notificationItems?.transactionDtl?.length??0,
                    itemBuilder: (context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 8, right: 8, left: 8),
                            margin: EdgeInsets.only(right: 8, left: 8),
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    unconfirmedViewModel
                                        .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                    index].transno,
                                    style: theme.bodyBold
                                        .copyWith(letterSpacing: .2),
                                    textAlign: TextAlign.center,
                                  ),
                                ]),
                            height: height * .07,
                            width: width,
                          ),
                          Container(
                            height: height * .33,
                            margin: EdgeInsets.only(right: 8, left: 8),
                            padding: EdgeInsets.only(
                                bottom: 12, right: 8, left: 8),
                            decoration: BoxDecoration(
                              color:
                              themeData.primaryColor.withOpacity(.7),
                              borderRadius: (widget.refOptnName ??
                                  "SALES_INVOICE") ==
                                  "SALES_INVOICE"
                                  ? BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12))
                                  : BorderRadius.only(),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (widget.refOptnName ==
                                          "PAYMENT_ENTRY")
                                        Visibility(
                                            visible: widget.refOptnName ==
                                                "PAYMENT_ENTRY"
                                                ? true
                                                : false,
                                            child:
                                            buildText("Paid From")),
                                      Visibility(
                                        visible: widget.refOptnName ==
                                            "PAYMENT_ENTRY",
                                        child: Text(
                                          unconfirmedViewModel
                                              .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                          index]
                                              ?.approval_result["paidfrom"] ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: theme.bodyBold.copyWith(
                                              letterSpacing: .2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.refOptnName ==
                                    "PAYMENT_ENTRY")
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                            visible: widget.refOptnName ==
                                                "PAYMENT_ENTRY",
                                            child: buildText("Paid To")),
                                        Visibility(
                                          visible: widget.refOptnName ==
                                              "PAYMENT_ENTRY",
                                          child: Expanded(
                                            child: Text(
                                              unconfirmedViewModel
                                                  .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                                    index]?.approval_result["paidto"] ??
                                                  "",
                                              textAlign: TextAlign.end,
                                              style: theme.bodyBold
                                                  .copyWith(
                                                  letterSpacing: .2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if ((widget.refOptnName ??
                                    "SALES_INVOICE") ==
                                    "SALES_INVOICE")
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                            visible: (widget.refOptnName ??
                                                "SALES_INVOICE") ==
                                                "SALES_INVOICE",
                                            child: buildText("Party")),
                                        Visibility(
                                          visible: (widget.refOptnName ??
                                              "SALES_INVOICE") ==
                                              "SALES_INVOICE",
                                          child: Text(
                                            unconfirmedViewModel
                                                .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                            index]
                                                ?.approval_result["partyname"] ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: theme.bodyBold
                                                .copyWith(
                                                letterSpacing: .2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildText("Trans.Date"),
                                      Text(
                                        unconfirmedViewModel
                                            .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                        index].transdate ??
                                            "",
                                        textAlign: TextAlign.end,
                                        style: theme.bodyBold
                                            .copyWith(letterSpacing: .2),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.refOptnName ==
                                      "PAYMENT_ENTRY",
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildText("Settlement Type"),
                                        Text(
                                          unconfirmedViewModel
                                              .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                          index]
                                              ?.approval_result["settlementtype"] ??
                                              "",
                                          style: theme.bodyBold.copyWith(
                                              letterSpacing: .2),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (widget.refOptnName ??
                                      "SALES_INVOICE") ==
                                      "SALES_INVOICE",
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildText("Reason"),
                                        Text(
                                          unconfirmedViewModel
                                              .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                          index]
                                              ?.approval_result["reason"] ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: theme.bodyBold.copyWith(
                                              letterSpacing: .2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildText("TotalAmount"),
                                      Text(
                                        (BaseNumberFormat(
                                            number: unconfirmedViewModel
                                                .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                            index]
                                                ?.approval_result["totalvalue"])
                                            .formatCurrency())
                                            .toString(),
                                        style: theme.bodyBold
                                            .copyWith(letterSpacing: .2),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.refOptnName ==
                                      "PAYMENT_ENTRY",
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildText("Settlement Date"),
                                        Text(
                                          unconfirmedViewModel
                                              .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                          index]
                                              ?.approval_result["settlementdue"] ??
                                              "",
                                          style: theme.bodyBold.copyWith(
                                              letterSpacing: .2),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: widget.refOptnName ==
                                        "PAYMENT_ENTRY",
                                    child: Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          buildText("Settlement Days"),
                                          Text(
                                            (unconfirmedViewModel
                                                .unconfirmedNotificationModel.notificationItems.transactionDtl[
                                            index]
                                                ?.approval_result["settlementduedays"] ??
                                                0)
                                                .toString(),
                                            style: theme.bodyBold
                                                .copyWith(
                                                letterSpacing: .2),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: 8, left: 8, bottom: 4),
                            decoration: BoxDecoration(
                              color:
                              themeData.primaryColor.withOpacity(.7),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                            ),
                            child: Visibility(
                              visible: widget.refOptnName ==
                                  "PAYMENT_ENTRY",
                              child: ExpansionTile(
                                  tilePadding:
                                  EdgeInsets.only(left: 8, right: 8),
                                  childrenPadding: EdgeInsets.only(
                                      right: 12, left: 12),
                                  title: Text(
                                    "Remarks",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  children: [
                                    BaseTextField(
                                      displayTitle: "",
                                      vector: AppVectors.remarks,
                                      initialValue: unconfirmedViewModel
                                          .unconfirmedNotificationModel.notificationItems?.transactionDtl[
                                      index]
                                          ?.approval_result["paymentremarks"] ??
                                          "",
                                      isEnabled: false,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      );
                    }):Container(child: Text("No Data"),)
              ),
              // widget.refOptnName /*?? "SALES_INVOICE"*/ == "SALES_INVOICE"
              //     ? Container(
              //   height: MediaQuery.of(context).size.height * .14,
              //   color: ThemeProvider.of(context).primaryColor,
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       mainAxisSize: MainAxisSize.max,
              //       children: unconfirmedViewModel.statusTypes.map((e) {
              //         final bool reject = e.code == "REJECTED";
              //
              //         return Expanded(
              //             child: Container(
              //               margin: EdgeInsets.all(6),
              //               child: _ApprovalButton(
              //                   color: reject
              //                       ? Colors.white
              //                       : ThemeProvider.of(context)
              //                       .primaryColorDark,
              //                   icon: reject
              //                       ? Icons.delete_forever
              //                       : Icons.check,
              //                   title: reject
              //                       ? Visibility(
              //                     visible: true,
              //                     child: Text(
              //                       (e?.description??"neenued"
              //                           .replaceAll("ed", ""))
              //                           .toUpperCase(),
              //                       textAlign: TextAlign.center,
              //                       style: TextStyle(
              //                           color:
              //                           ThemeProvider.of(context)
              //                               .primaryColorDark),
              //                     ),
              //                   )
              //                       : Visibility(
              //                       visible: true,
              //                       child: Text(
              //                           (e.description
              //                               .replaceAll("d", ""))
              //                               .toUpperCase(),
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                           ))),
              //                   onPressed: () {
              //                     UnConfirmedTransactionDetailList dataFromNotif;
              //                     dataFromNotif = UnConfirmedTransactionDetailList(
              //                         transno: unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["transno"]?? "",
              //                         transdate : unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["transdate"]??'',
              //                         id: unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["id"]??"",
              //                         unconfirmedid: unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["unconfirmedid"]??"",
              //                         tableid: unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["tableid"]??"",
              //                         refoptionid: unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["refoptionid"]??"",
              //                         lastmoddate: unconfirmedViewModel
              //                             .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                             .approval_result["lastmoddate"]??""
              //                     );
              //
              //                     unconfirmedViewModel.onAddUnconfirmedData(dataFromNotif);
              //                     if (unconfirmedViewModel
              //                         .addedUnconfirmedItems.length >
              //                         0) {
              //                       unconfirmedViewModel
              //                           .onSaveUnConfirmedTransaction(
              //                           e.code == "APPROVED"
              //                               ? "A"
              //                               : "R");
              //                     } else {
              //                       AppSnackBar.of(context).show(
              //                           "Please select one transaction");
              //                     }
              //                   }),
              //             ));
              //       }).toList()),
              // ) : Container(
              //   width: width,
              //   height: MediaQuery.of(context).size.height * .09,
              //   color: ThemeProvider.of(context).primaryColorDark,
              //   child: RaisedButton(
              //       onPressed: () {
              //         UnConfirmedTransactionDetailList dataFromNotif;
              //         dataFromNotif = UnConfirmedTransactionDetailList(
              //             transno: unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["transno"]?? "",
              //             transdate : unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["transdate"]??'',
              //             id: unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["id"]??"",
              //             unconfirmedid: unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["unconfirmedid"]??"",
              //             tableid: unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["tableid"]??"",
              //             refoptionid: unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["refoptionid"]??"",
              //             lastmoddate: unconfirmedViewModel
              //                 .unconfirmedNotificationModel.notificationItems.transactionDtl.first
              //                 .approval_result["lastmoddate"]??""
              //         );
              //
              //         unconfirmedViewModel.onAddUnconfirmedData(dataFromNotif);
              //         if (unconfirmedViewModel
              //             .addedUnconfirmedItems.length >
              //             0) {
              //           unconfirmedViewModel
              //               .onSaveUnConfirmedTransaction("A");
              //         } else {
              //           AppSnackBar.of(context)
              //               .show("Please select one transaction");
              //         }
              //       },
              //       child: Text(
              //         "APPROVE",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             color: ThemeProvider.of(context).accentColor),
              //       )),
              // ),
              if ((widget.refOptnName ??
                  "SALES_INVOICE") ==
                  "SALES_INVOICE") Container(
                  height: MediaQuery.of(context).size.height * .14,
                  color: ThemeProvider.of(context).primaryColor,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                      // final bool reject = e.code == "REJECTED";
        //               Expanded(
        // child: Container(
        // margin: EdgeInsets.all(6),
        // child: _ApprovalButton(
        // color: reject
        // ? Colors.white
        //     : ThemeProvider.of(context)
        //     .primaryColorDark,
        // icon: reject
        // ? Icons.delete_forever
        //     : Icons.check,
        // title: reject
        // ? Visibility(
        // visible: true,
        // child: Text(
        // (e?.description??"neenued"
        //     .replaceAll("ed", ""))
        //     .toUpperCase(),
        // textAlign: TextAlign.center,
        // style: TextStyle(
        // color:
        // ThemeProvider.of(context)
        //     .primaryColorDark),
        // ),
        // )
        //     : Visibility(
        // visible: true,
        // child: Text(
        // (e.description
        //     .replaceAll("d", ""))
        //     .toUpperCase(),
        // style: TextStyle(
        // color: Colors.white,
        // ))),
        // onPressed: () {
        // UnConfirmedTransactionDetailList dataFromNotif;
        // dataFromNotif = UnConfirmedTransactionDetailList(
        // transno: unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["transno"]?? "",
        // transdate : unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["transdate"]??'',
        // id: unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["id"]??"",
        // unconfirmedid: unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["unconfirmedid"]??"",
        // tableid: unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["tableid"]??"",
        // refoptionid: unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["refoptionid"]??"",
        // lastmoddate: unconfirmedViewModel
        //     .unconfirmedNotificationModel.notificationItems.transactionDtl.first
        //     .approval_result["lastmoddate"]??""
        // );
        //
        // unconfirmedViewModel.onAddUnconfirmedData(dataFromNotif);
        // if (unconfirmedViewModel
        //     .addedUnconfirmedItems.length >
        // 0) {
        // unconfirmedViewModel
        //     .onSaveUnConfirmedTransaction(
        // e.code == "APPROVED"
        // ? "A"
        //     : "R");
        // } else {
        // AppSnackBar.of(context).show(
        // "Please select one transaction");
        // }
        // }),
        // )),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.all(6),
                              child: _ApprovalButton(
                                  color: ThemeProvider.of(context).primaryColorDark,
                                  icon: Icons.check,
                                  title: Text(
                                    'APPROVE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeProvider.of(context).accentColor),
                                  ),
                                  onPressed: () {
                            UnConfirmedTransactionDetailList dataFromNotif;
                            dataFromNotif = UnConfirmedTransactionDetailList(
        transno: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["transno"]?? "",
        transdate : unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["transdate"]??'',
        id: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["id"]??"",
        unconfirmedid: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["unconfirmedid"]??"",
        tableid: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["tableid"]??"",
        refoptionid: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["refoptionid"]??"",
        lastmoddate: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["lastmoddate"]??""
        );
        unconfirmedViewModel.onAddUnconfirmedData(dataFromNotif);
        if (unconfirmedViewModel
            .addedUnconfirmedItems.length >0) {
          unconfirmedViewModel
            .onSaveUnConfirmedTransaction("A","SALES_INVOICE");
        }
        else {
        AppSnackBar.of(context).show(
        "Please select one transaction");
        }
                                    }
                                    ),
                                  ),
                            ),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.all(6),
                              child: _ApprovalButton(
                                  color: ThemeProvider.of(context).accentColor,
                                  icon: Icons.delete_forever,
                                  title: Text(
                                    'REJECT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                        ThemeProvider.of(context).primaryColorDark),
                                  ),
                                  onPressed: () {
        UnConfirmedTransactionDetailList dataFromNotif;
        dataFromNotif = UnConfirmedTransactionDetailList(
        transno: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["transno"]?? "",
        transdate : unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["transdate"]??'',
        id: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["id"]??"",
        unconfirmedid: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["unconfirmedid"]??"",
        tableid: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["tableid"]??"",
        refoptionid: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["refoptionid"]??"",
        lastmoddate: unconfirmedViewModel
            .unconfirmedNotificationModel.notificationItems.transactionDtl.first
            .approval_result["lastmoddate"]??""
        );
        unconfirmedViewModel.onAddUnconfirmedData(dataFromNotif);
        if (unconfirmedViewModel
            .addedUnconfirmedItems.length >0) {
        unconfirmedViewModel
            .onSaveUnConfirmedTransaction("R","SALES_INVOICE");
        }
        else {
        AppSnackBar.of(context).show(
        "Please select one transaction");
        }
                                  }),
                            )),
                      ]
        // final bool reject = e.code == "REJECTED";


                  ),
                ),
              if (widget.refOptnName ==
                  "PAYMENT_ENTRY") Container(
                  width: width,
                  height: MediaQuery.of(context).size.height * .09,
                  color: ThemeProvider.of(context).primaryColorDark,
                  child: RaisedButton(
                      onPressed: () {
                        UnConfirmedTransactionDetailList dataFromNotif;
                        dataFromNotif = UnConfirmedTransactionDetailList(
                            transno: unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["transno"]?? "",
                            transdate : unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["transdate"]??'',
                            id: unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["id"]??"",
                            unconfirmedid: unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["unconfirmedid"]??"",
                            tableid: unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["tableid"]??"",
                            refoptionid: unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["refoptionid"]??"",
                            lastmoddate: unconfirmedViewModel
                                .unconfirmedNotificationModel.notificationItems.transactionDtl.first
                                .approval_result["lastmoddate"]??""
                        );

                        unconfirmedViewModel.onAddUnconfirmedData(dataFromNotif);
                        if (unconfirmedViewModel
                            .addedUnconfirmedItems.length >
                            0) {
                          unconfirmedViewModel
                              .onSaveUnConfirmedTransaction("A","PAYMENT_ENTRY");
                        } else {
                          AppSnackBar.of(context)
                              .show("Please select one transaction");
                        }
                      },
                      child: Text(
                        "APPROVE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ThemeProvider.of(context).accentColor),
                      )),
                ),
            ],
          )
              : Center(child: BaseLoadingView(
            message: "Loading",
          ),
          ),
        );
      },
    );
  }

  Text buildText(String title) => Text(
    title,
    textAlign: TextAlign.start,
  );
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
                padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*.09),
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
                    color:  ThemeProvider.of(context).primaryColorDark,
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

