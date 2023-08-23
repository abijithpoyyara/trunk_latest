import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/actions/back_dated_entry_permission/back_dated_entry_permission_action.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/unconfirmed_transaction_details/unconfirmed_transaction_details_viewmodel.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/_partials/alert_message_dialog.dart';

import '../../../../utility.dart';
import 'model/unconfirmed_filter.dart';

class UnconfirmedInnerScreen extends StatefulWidget {
  final UnConfirmedTransactionDetailList unConfirmedTransactionDetailList;
  final BCCModel selectedOption;
  final UnConfirmedTransactionDetailViewModel unconfirmedViewModel;
  final transid;
  final optionid;
  final transtableid;
  final notificationid;
  final int index;

  const UnconfirmedInnerScreen(
      {Key key,
      this.unConfirmedTransactionDetailList,
      this.selectedOption,
      this.unconfirmedViewModel,
      this.optionid,
      this.notificationid,
      this.transid,
      this.index,
      this.transtableid})
      : super(key: key);
  @override
  _UnconfirmedInnerScreenState createState() => _UnconfirmedInnerScreenState();
}

class _UnconfirmedInnerScreenState extends State<UnconfirmedInnerScreen> {
  // @override
  // void initState() {
  //   widget.unconfirmedViewModel.setNotificationAsReadFunction(
  //       transId: widget.unConfirmedTransactionDetailList.unconfirmedid,
  //       transTableId:
  //           widget.unConfirmedTransactionDetailList.unconfirmedtableid,
  //       optionId: widget.unConfirmedTransactionDetailList.refoptionid,
  //       notificationId: widget.unconfirmedViewModel.optionId);
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  // @override
  // void didUpdateWidget(covariant UnconfirmedInnerScreen oldWidget) {
  //   if (unconfirmedViewModel.unConfirmedTransactionDetailSave) {
  //     showSuccessDialog(context, "Saved Successfully", "Success", () {
  //       unconfirmedViewModel.onUnconfirmedClearAction();
  //       unconfirmedViewModel.onCalledAfterSave();
  //       unconfirmedViewModel.onUserSelect(UnConfirmedFilterModel(
  //           fromDate: unconfirmedViewModel.unConfirmedFilterModel.fromDate,
  //           toDate: DateTime.now(),
  //           optionCode: widget.selectedOption));
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void dispose() {
  //   widget.unconfirmedViewModel.onCallBackData(widget.selectedOption,
  //       widget.unConfirmedTransactionDetailList.refoptionid);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);

    return BaseView<AppState, UnConfirmedTransactionDetailViewModel>(
        init: (store, context) {
          store.dispatch(setNotificationAsRead(
              transId: widget.unConfirmedTransactionDetailList.unconfirmedid,
              transTableId:
                  widget.unConfirmedTransactionDetailList.unconfirmedtableid,
              optionId: widget.unConfirmedTransactionDetailList.refoptionid,
              notificationId: widget.unconfirmedViewModel.optionId));
        },
        appBar: BaseAppBar(
          title: Text(widget.unConfirmedTransactionDetailList.transno),
        ),
        onDispose: (store) {
          // store.dispatch(OnClearFunction());
          store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
          store.dispatch(fetchUnconfirmedTransactionListAction(
              filterModel: UnConfirmedFilterModel(
            optionCode: widget.selectedOption,
            fromDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
            toDate: DateTime.now(),
          )));
          store.dispatch(fetchUnreadUnconfirmedNotificationList(
              optionId: widget.unConfirmedTransactionDetailList.refoptionid,
              notificationId: store.state?.homeState?.selectedOption?.id));
        },
        onDidChange: (unconfirmedViewModel, context) {
          if (unconfirmedViewModel.unConfirmedTransactionDetailSave) {
            showSuccessDialog(context, "Saved Successfully", "Success", () {

              // Navigator.pop(context);
              Navigator.pop(context);
              // unconfirmedViewModel.onCalledAfterSave();
              // unconfirmedViewModel.onUserSelect(UnConfirmedFilterModel(
              //     fromDate:
              //         unconfirmedViewModel.unConfirmedFilterModel.fromDate,
              //     toDate: DateTime.now(),
              //     optionCode: widget.selectedOption));
            });
            unconfirmedViewModel.onUnconfirmedClearAction();
          }else if(unconfirmedViewModel.unconfirmedTransactionApprovalFailure == true){
            ///this dialog is given to solve concurrency issue
            showAlertMessageDialog(context, "",
                "${unconfirmedViewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
                    () {
                  // Navigator.pop(context);
                  Navigator.pop(context);
                });
            unconfirmedViewModel.resetUTApprovalFailure();
          }
        },
        converter: (store) =>
            UnConfirmedTransactionDetailViewModel.fromStore(store),
        builder: (context, viewmodel) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      // Container(
                      //   padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                      //   margin: EdgeInsets.only(right: 8, left: 8),
                      //   decoration: BoxDecoration(
                      //     color: themeData.primaryColor,
                      //     borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(12),
                      //         topRight: Radius.circular(12)),
                      // ),
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         // Text("Trans. No."),
                      //         Text(
                      //           viewmodel
                      //               .unConfirmedTransactionDetailListData[
                      //                   widget.index]
                      //               .transno,
                      //           style:
                      //               theme.bodyBold.copyWith(letterSpacing: .2),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         // CheckBoxW(
                      //         //   viewModel: unconfirmedViewModel,
                      //         //   transaction: unconfirmedViewModel
                      //         //       .unConfirmedTransactionDetailListData[index],
                      //         // ),
                      //       ]),
                      //   //themeData.scaffoldBackgroundColor,
                      //   height: height * .07,
                      //   width: width,
                      // ),
                      Container(
                        height:
                            widget?.selectedOption?.code == "GENERAL_VOUCHER"
                                ? height * .23
                                : height * .33,
                        margin: EdgeInsets.only(right: 8, left: 8),
                        padding: EdgeInsets.only(bottom: 12, right: 8, left: 8),
                        decoration: BoxDecoration(
                          color: themeData.primaryColor.withOpacity(.7),
                          borderRadius: (widget?.selectedOption?.code ??
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
                                  buildText("Trans.Date"),
                                  Text(
                                    widget.unConfirmedTransactionDetailList
                                            ?.transdate ??
                                        "",
                                    textAlign: TextAlign.end,
                                    style: theme.bodyBold
                                        .copyWith(letterSpacing: .2),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildText("TotalAmount"),
                                  Text(
                                    (BaseNumberFormat(
                                                number: widget
                                                    .unConfirmedTransactionDetailList
                                                    .totalvalue)
                                            .formatCurrency())
                                        .toString(),
                                    style: theme.bodyBold
                                        .copyWith(letterSpacing: .2),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget?.selectedOption?.code ==
                                      "GENERAL_VOUCHER")
                                    Visibility(
                                      visible: widget?.selectedOption?.code ==
                                          "GENERAL_VOUCHER",
                                      child: Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            buildText("Reason"),
                                            Text(
                                              widget.unConfirmedTransactionDetailList
                                                      ?.reason ??
                                                  "",
                                              textAlign: TextAlign.end,
                                              style: theme.bodyBold
                                                  .copyWith(letterSpacing: .2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (widget?.selectedOption?.code ==
                                      "PAYMENT_ENTRY")
                                    Visibility(
                                        visible: widget?.selectedOption?.code ==
                                                "PAYMENT_ENTRY"
                                            ? true
                                            : false,
                                        child: buildText("Paid From")),
                                  Visibility(
                                    visible: widget?.selectedOption?.code ==
                                        "PAYMENT_ENTRY",
                                    child: Text(
                                      widget.unConfirmedTransactionDetailList
                                              ?.paidfrom ??
                                          "",
                                      textAlign: TextAlign.end,
                                      style: theme.bodyBold
                                          .copyWith(letterSpacing: .2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                      visible: (widget?.selectedOption?.code ??
                                              "SALES_INVOICE") ==
                                          "SALES_INVOICE",
                                      child: buildText("Party")),
                                  Visibility(
                                    visible: (widget?.selectedOption?.code ??
                                            "SALES_INVOICE") ==
                                        "SALES_INVOICE",
                                    child: Text(
                                      widget.unConfirmedTransactionDetailList
                                              ?.partyname ??
                                          "",
                                      textAlign: TextAlign.end,
                                      style: theme.bodyBold
                                          .copyWith(letterSpacing: .2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget?.selectedOption?.code == "PAYMENT_ENTRY")
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                        visible: widget?.selectedOption?.code ==
                                            "PAYMENT_ENTRY",
                                        child: buildText("Paid To")),
                                    Visibility(
                                      visible: widget?.selectedOption?.code ==
                                          "PAYMENT_ENTRY",
                                      child: Expanded(
                                        child: Text(
                                          widget.unConfirmedTransactionDetailList
                                                  ?.paidto ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: theme.bodyBold
                                              .copyWith(letterSpacing: .2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if ((widget?.selectedOption?.code ??
                                    "SALES_INVOICE") ==
                                "SALES_INVOICE")
                              Visibility(
                                visible: widget?.selectedOption?.code ==
                                    "PAYMENT_ENTRY",
                                child: Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildText("Settlement Type"),
                                      Text(
                                        widget.unConfirmedTransactionDetailList
                                                ?.settlementtype ??
                                            "",
                                        style: theme.bodyBold
                                            .copyWith(letterSpacing: .2),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Visibility(
                              visible: (widget?.selectedOption?.code ??
                                      "SALES_INVOICE") ==
                                  "SALES_INVOICE",
                              child: Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildText("Reason"),
                                    Text(
                                      widget.unConfirmedTransactionDetailList
                                              ?.reason ??
                                          "",
                                      textAlign: TextAlign.end,
                                      style: theme.bodyBold
                                          .copyWith(letterSpacing: .2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget?.selectedOption?.code ==
                                  "PAYMENT_ENTRY",
                              child: Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildText("Settlement Date"),
                                    Text(
                                      widget.unConfirmedTransactionDetailList
                                              ?.settlementdue ??
                                          "",
                                      style: theme.bodyBold
                                          .copyWith(letterSpacing: .2),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                                visible: widget?.selectedOption?.code ==
                                    "PAYMENT_ENTRY",
                                child: Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildText("Settlement Days"),
                                      Text(
                                        (widget.unConfirmedTransactionDetailList
                                                    ?.settlementduedays ??
                                                0)
                                            .toString(),
                                        style: theme.bodyBold
                                            .copyWith(letterSpacing: .2),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8, left: 8, bottom: 4),
                        decoration: BoxDecoration(
                          color: themeData.primaryColor.withOpacity(.7),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                        ),
                        //  color: themeData.primaryColor,
                        child: Visibility(
                          visible:
                              widget?.selectedOption?.code == "PAYMENT_ENTRY",
                          child: ExpansionTile(
                              tilePadding: EdgeInsets.only(left: 8, right: 8),
                              childrenPadding:
                                  EdgeInsets.only(right: 12, left: 12),
                              title: Text(
                                "Remarks",
                                style: TextStyle(fontSize: 14),
                              ),
                              children: [
                                BaseTextField(
                                  displayTitle: "",
                                  vector: AppVectors.remarks,
                                  initialValue: widget
                                          .unConfirmedTransactionDetailList
                                          ?.paymentremarks ??
                                      "",
                                  isEnabled: false,
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if ((widget?.selectedOption?.code ?? "SALES_INVOICE") ==
                  "SALES_INVOICE")
                Container(
                  // padding:
                  //     EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 6),
                  height: MediaQuery.of(context).size.height * .14,
                  color: ThemeProvider.of(context).primaryColor,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children:
                          widget.unconfirmedViewModel.statusTypes.map((e) {
                        final bool reject = e.code == "REJECTED";

                        return Expanded(
                            child: Container(
                          margin: EdgeInsets.all(6),
                          child: _ApprovalButton(
                              color: reject
                                  ? Colors.white
                                  : ThemeProvider.of(context).primaryColorDark,
                              icon: reject ? Icons.delete_forever : Icons.check,
                              title: reject
                                  ? Visibility(
                                      visible: true,
                                      // unconfirmedViewModel
                                      //         .unConfirmedFilterModel.optionCode !=
                                      //     "PAYMENT_ENTRY",
                                      child: Text(
                                        (e.description.replaceAll("ed", ""))
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ThemeProvider.of(context)
                                                .primaryColorDark),
                                      ),
                                    )
                                  : Visibility(
                                      visible: true,
                                      child: Text(
                                          (e.description.replaceAll("d", ""))
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))),
                              onPressed: () {
                                widget.unconfirmedViewModel
                                    .onAddUnconfirmedData(widget
                                        .unConfirmedTransactionDetailList);
                                if (widget.unconfirmedViewModel
                                        .addedUnconfirmedItems.length >
                                    0) {
                                  widget.unconfirmedViewModel
                                      .onSaveUnConfirmedTransaction(
                                          e.code == "APPROVED" ? "A" : "R",
                                          "SALES_INVOICE");
                                } else {
                                  AppSnackBar.of(context)
                                      .show("Please select one transaction");
                                }
                              }),
                        ));
                      }).toList()),
                ),
              if (widget?.selectedOption?.code == "PAYMENT_ENTRY")
                Container(
                  width: width,
                  // padding: EdgeInsets.only(
                  //     top: 10, left: 10, bottom: 10, right: 6),
                  height: MediaQuery.of(context).size.height * .09,
                  color: ThemeProvider.of(context).primaryColorDark,
                  child: RaisedButton(
                      onPressed: () {
                        widget.unconfirmedViewModel?.onAddUnconfirmedData(
                            widget.unConfirmedTransactionDetailList);
                        if (widget.unconfirmedViewModel.addedUnconfirmedItems
                                .length >
                            0) {
                          widget.unconfirmedViewModel
                              .onSaveUnConfirmedTransaction(
                                  "A", "PAYMENT_ENTRY");
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
              if (widget?.selectedOption?.code == "GENERAL_VOUCHER")
                Container(
                  width: width,
                  // padding: EdgeInsets.only(
                  //     top: 10, left: 10, bottom: 10, right: 6),
                  height: MediaQuery.of(context).size.height * .09,
                  color: ThemeProvider.of(context).primaryColorDark,
                  child: RaisedButton(
                      onPressed: () {
                        widget.unconfirmedViewModel?.onAddUnconfirmedData(
                            widget.unConfirmedTransactionDetailList);
                        if (widget.unconfirmedViewModel.addedUnconfirmedItems
                                .length >
                            0) {
                          widget.unconfirmedViewModel
                              .onSaveUnConfirmedTransaction(
                                  "A", "GENERAL_VOUCHER");
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
          );
        });
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
