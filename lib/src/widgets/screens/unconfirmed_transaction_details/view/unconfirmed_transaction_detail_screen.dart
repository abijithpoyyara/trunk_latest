import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/unconfirmed_transaction_details/unconfirmed_transaction_details_viewmodel.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/_partials/alert_message_dialog.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/unconfirmed_inner_screen.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/view/unconfirmed_transaction_detail_filter_screen.dart';
import 'package:redstars/utility.dart';

class UnConfirmedTransactionScreen extends StatefulWidget {
  final BCCModel selectedOption;
  final UnConfirmedTransactionDetailViewModel unconfirmedViewModel;

  const UnConfirmedTransactionScreen({Key key, this.selectedOption,this.unconfirmedViewModel})
      : super(key: key);
  @override
  _UnConfirmedTransactionScreenState createState() =>
      _UnConfirmedTransactionScreenState();
}

class _UnConfirmedTransactionScreenState
    extends State<UnConfirmedTransactionScreen> {
  bool _isExpanded = false;
  Color color;


  String isDocInit;
  String doc_key;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ThemeData themeData = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    return BaseView<AppState, UnConfirmedTransactionDetailViewModel>(
      init: (store, context) async {
        final filter = store.state.unConfirmedTransactionDetailState;

        store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());

        store.dispatch(fetchUnconfirmedTransactionListAction(
            filterModel: UnConfirmedFilterModel(
          optionCode: widget.selectedOption,
          fromDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
          toDate: DateTime.now(),
        )));
        store.dispatch(fetchUnreadUnconfirmedNotificationList(
            optionId: int.parse(widget.selectedOption.extra),
            notificationId: store.state?.homeState?.selectedOption?.id));


        await BasePrefs.setString(
            BaseConstants.SCREEN_STATE_KEY, "MOB_UNCFIRMD_TRNSCTION_DETAIL");

        void checkAndAddMessageListener() async {
          print("Unconfirmed Detail Screen Listener Function.");
          doc_key =
              await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";
          isDocInit = await BasePrefs.getString('isUnconfirmedDetailInit') ?? "";

          if (isDocInit == "") {
            await BasePrefs.setString("isUnconfirmedDetailInit", "true");

            print("Unconfirmed Detail Screen Listener Initilised");
            FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
              doc_key =
                  await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ??
                      "";

              print(doc_key);

              if (doc_key == "MOB_UNCFIRMD_TRNSCTION_DETAIL") {
                print("Unconfirmed Detail Screen Listener Calling.");
                store.dispatch(
                    fetchInitialConfigUnConfirmedTransactionDetails(
                        optionId: store.state.homeState.selectedOption.id,
                        isFromNotify: true));

                store.dispatch(fetchUnconfirmedTransactionListAction(
                    filterModel: filter.unConfirmedFilterModel,
                    isFromNotify: true));

                store.dispatch(fetchUnreadUnconfirmedNotificationList(
                    optionId: int.parse(widget.selectedOption.extra),
                    notificationId: store.state?.homeState?.selectedOption?.id));

              }
            });
          }
        }

        checkAndAddMessageListener();




      },
      onDispose: (store) async {
        store.dispatch(OnClearAction());
        final filter = store.state.unConfirmedTransactionDetailState;

        store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails(
            optionId: store.state.homeState.selectedOption.id));

        store.dispatch(fetchUnconfirmedTransactionListAction(
          filterModel: filter.unConfirmedFilterModel,
        ));
        await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "MOB_UNCFIRMD_TRNSCTION");
      },
      onDidChange: (unconfirmedViewModel, context) {

        if (unconfirmedViewModel.unConfirmedTransactionDetailSave) {
          showSuccessDialog(context, "Saved Successfully", "Success", () {

            unconfirmedViewModel.onCalledAfterSave();
            unconfirmedViewModel.onUserSelect(UnConfirmedFilterModel(
                fromDate: unconfirmedViewModel.unConfirmedFilterModel.fromDate,
                toDate: DateTime.now(),
                optionCode: widget.selectedOption));
            Navigator.pop(context);
          });
          unconfirmedViewModel.onUnconfirmedClearAction();
        }else if(unconfirmedViewModel.unconfirmedTransactionApprovalFailure == true){
          ///this dialog is given to solve concurrency issue
          showAlertMessageDialog(context, "",
              "${unconfirmedViewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
                  () {
                Navigator.of(context).pop();
              });
          unconfirmedViewModel.resetUTApprovalFailure();
        }

        ///update
      },
      // onDispose: (store) =>
      //     store.dispatch(UnconfirmedTransactionDetailClearAction()),
      converter: (store) =>
          UnConfirmedTransactionDetailViewModel.fromStore(store),
      builder: (context, unconfirmedViewModel) {
        return Scaffold(
          appBar: BaseAppBar(
            title: Text("Unconfirmed Transaction"),
          ),
//          floatingActionButton: FloatingActionButton(
//            onPressed: () async {
//              UnConfirmedFilterModel result =
//                  await appShowChildDialog<UnConfirmedFilterModel>(
//                      context: context,
//                      child: UnconfirmedTransactionFilter(
//                          viewModel: unconfirmedViewModel,
//                          model: UnConfirmedFilterModel(
                  //   optionCode: widget.selectedOption,
//                            fromDate: unconfirmedViewModel
//                                .unConfirmedFilterModel.fromDate,
//                            toDate: unconfirmedViewModel
//                                .unConfirmedFilterModel.toDate,
//                          )));
//              unconfirmedViewModel.onChangeUnconfirmedFilter(result);
//              unconfirmedViewModel.onUserSelect(result
//                  //     UnConfirmedFilterModel(
//                  //   fromDate: unconfirmedViewModel.unConfirmedFilterModel.fromDate,
//                  //   toDate: unconfirmedViewModel.unConfirmedFilterModel.toDate,
//                  //   optionCode: widget.selectedOption,
//                  // )
//                  );
//            },
//            child: Icon(
//              Icons.filter_list,
//              color: themeData.primaryColorDark,
//            ),
//          ),
          body: unconfirmedViewModel.unConfirmedTransactionDetailListData !=
                      null &&
                  unconfirmedViewModel
                      .unConfirmedTransactionDetailListData.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: 15,),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: unconfirmedViewModel
                              .unConfirmedTransactionDetailListData.length,
                          itemBuilder: (context, int index) {
                            List<UnreadNotificationListModel>
                                unreadContainsList;
                            unreadContainsList = unconfirmedViewModel.unreadList
                                .where((element) =>
                                    element.transid ==
                                    unconfirmedViewModel
                                        .unConfirmedTransactionDetailListData[
                                            index]
                                        .unconfirmedid)
                                .toList();
                            unreadContainsList.forEach((element) {
                              if (element.transid ==
                                      unconfirmedViewModel
                                          .unConfirmedTransactionDetailListData[
                                              index]
                                          .unconfirmedid

                                  //
                                  // &&
                                  // element.readstatusyn == "N"

                                  ) {
                                unconfirmedViewModel
                                    .unConfirmedTransactionDetailListData[index]
                                    .readStatus = element.readstatusyn;
                                // color = colors.secondaryDark.withOpacity(0.8);
                                // unconfirmedViewModel
                                //     .unConfirmedTransactionDetailListData[index]
                                //     .color = color;
                                // ;
                              } else {
                                color = colors.primaryColor;
                                unconfirmedViewModel
                                    .unConfirmedTransactionDetailListData[index]
                                    .color = themeData.primaryColor;
                              }
                              return color;
                            });

                            return GestureDetector(
                              onTap: () {
                                unconfirmedViewModel.addedUnconfirmedItems.clear();
                                // unconfirmedViewModel.setNotificationAsReadFunction(
                                //     transId: unconfirmedViewModel
                                //         .unConfirmedTransactionDetailListData[
                                //             index]
                                //         .unconfirmedid,
                                //     transTableId: unconfirmedViewModel
                                //         .unConfirmedTransactionDetailListData[
                                //             index]
                                //         .unconfirmedtableid,
                                //     optionId: unconfirmedViewModel
                                //         .unConfirmedTransactionDetailListData[
                                //             index]
                                //         .refoptionid,
                                //     notificationId:
                                //         unconfirmedViewModel.optionId);
                                BaseNavigate(
                                    context,
                                    UnconfirmedInnerScreen(
                                      unConfirmedTransactionDetailList:
                                          unconfirmedViewModel
                                                  .unConfirmedTransactionDetailListData[
                                              index],
                                      selectedOption: widget.selectedOption,
                                      unconfirmedViewModel:
                                          unconfirmedViewModel,
                                      index: index,
                                    ));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 8, right: 8, left: 8),
                                    margin: EdgeInsets.only(right: 8, left: 8),
                                    decoration: BoxDecoration(
                                        color: unconfirmedViewModel
                                                    .unConfirmedTransactionDetailListData[
                                                        index]
                                                    .readStatus ==
                                                "N"
                                            ? themeData.primaryColorDark
                                                .withOpacity(.8)
                                            : themeData.primaryColor
                                        // themeData.primaryColor,
                                        // borderRadius: BorderRadius.only(
                                        //   topLeft: Radius.circular(12),
                                        //   topRight: Radius.circular(12),
                                        // ),
                                        ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text("Trans. No."),
                                          Text(
                                            unconfirmedViewModel
                                                .unConfirmedTransactionDetailListData[
                                                    index]
                                                .transno,
                                            style: theme.bodyBold
                                                .copyWith(letterSpacing: .2),
                                            textAlign: TextAlign.center,
                                          ),
                                          CheckBoxW(
                                            viewModel: unconfirmedViewModel,
                                            transaction: unconfirmedViewModel
                                                    .unConfirmedTransactionDetailListData[
                                                index],
                                          ),
                                        ]),
                                    //themeData.scaffoldBackgroundColor,
                                    height: height * .07,
                                    width: width,
                                  ),
                                  Container(
                                    height: widget?.selectedOption?.code ==
                                            "GENERAL_VOUCHER"
                                        ? height * .23
                                        : height * .3,
                                    margin: EdgeInsets.only(right: 8, left: 8),
                                    padding: EdgeInsets.only(
                                        bottom: 12, right: 8, left: 8),
                                    decoration: BoxDecoration(
                                      color: unconfirmedViewModel
                                                  .unConfirmedTransactionDetailListData[
                                                      index]
                                                  .readStatus ==
                                              "N"
                                          ? themeData.primaryColorDark
                                              .withOpacity(.8)
                                          : themeData.primaryColor,
                                      borderRadius: (widget
                                                      ?.selectedOption?.code ??
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
                                                unconfirmedViewModel
                                                        .unConfirmedTransactionDetailListData[
                                                            index]
                                                        ?.transdate ??
                                                    "",
                                                textAlign: TextAlign.end,
                                                style: theme.bodyBold.copyWith(
                                                    letterSpacing: .2),
                                              ),
                                            ],
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
                                                                .unConfirmedTransactionDetailListData[
                                                                    index]
                                                                .totalvalue)
                                                        .formatCurrency())
                                                    .toString(),
                                                style: theme.bodyBold.copyWith(
                                                    letterSpacing: .2),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (widget?.selectedOption?.code ==
                                            "GENERAL_VOUCHER")
                                          Visibility(
                                            visible:
                                                widget?.selectedOption?.code ==
                                                    "GENERAL_VOUCHER",
                                            child: Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  buildText("Reason"),
                                                  Text(
                                                    unconfirmedViewModel
                                                            .unConfirmedTransactionDetailListData[
                                                                index]
                                                            ?.reason ??
                                                        "",
                                                    textAlign: TextAlign.end,
                                                    style: theme.bodyBold
                                                        .copyWith(
                                                            letterSpacing: .2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (widget?.selectedOption?.code ==
                                            "PAYMENT_ENTRY")
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                if (widget?.selectedOption
                                                        ?.code ==
                                                    "PAYMENT_ENTRY")
                                                  Visibility(
                                                      visible:
                                                          widget?.selectedOption
                                                                      ?.code ==
                                                                  "PAYMENT_ENTRY"
                                                              ? true
                                                              : false,
                                                      child: buildText(
                                                          "Paid From")),
                                                Visibility(
                                                  visible: widget
                                                          ?.selectedOption
                                                          ?.code ==
                                                      "PAYMENT_ENTRY",
                                                  child: Text(
                                                    unconfirmedViewModel
                                                            .unConfirmedTransactionDetailListData[
                                                                index]
                                                            ?.paidfrom ??
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
                                        if (widget?.selectedOption?.code ==
                                            "PAYMENT_ENTRY")
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Visibility(
                                                    visible: widget
                                                            ?.selectedOption
                                                            ?.code ==
                                                        "PAYMENT_ENTRY",
                                                    child:
                                                        buildText("Paid To")),
                                                Visibility(
                                                  visible: widget
                                                          ?.selectedOption
                                                          ?.code ==
                                                      "PAYMENT_ENTRY",
                                                  child: Expanded(
                                                    child: Text(
                                                      unconfirmedViewModel
                                                              .unConfirmedTransactionDetailListData[
                                                                  index]
                                                              ?.paidto ??
                                                          "",
                                                      textAlign: TextAlign.end,
                                                      style: theme.bodyBold
                                                          .copyWith(
                                                              letterSpacing:
                                                                  .2),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if ((widget?.selectedOption?.code ??
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
                                                                ?.selectedOption
                                                                ?.code ??
                                                            "SALES_INVOICE") ==
                                                        "SALES_INVOICE",
                                                    child: buildText("Party")),
                                                Visibility(
                                                  visible: (widget
                                                              ?.selectedOption
                                                              ?.code ??
                                                          "SALES_INVOICE") ==
                                                      "SALES_INVOICE",
                                                  child: Text(
                                                    unconfirmedViewModel
                                                            .unConfirmedTransactionDetailListData[
                                                                index]
                                                            ?.partyname ??
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

                                        // Visibility(
                                        //   visible:
                                        //       widget?.selectedOption?.code ==
                                        //           "PAYMENT_ENTRY",
                                        //   child: Expanded(
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //       children: [
                                        //         buildText("Settlement Type"),
                                        //         Text(
                                        //           unconfirmedViewModel
                                        //                   .unConfirmedTransactionDetailListData[
                                        //                       index]
                                        //                   ?.settlementtype ??
                                        //               "",
                                        //           style: theme.bodyBold
                                        //               .copyWith(
                                        //                   letterSpacing: .2),
                                        //           textAlign: TextAlign.end,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Visibility(
                                        //   visible:
                                        //       (widget?.selectedOption?.code ??
                                        //               "SALES_INVOICE") ==
                                        //           "SALES_INVOICE",
                                        //   child: Expanded(
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //       children: [
                                        //         buildText("Reason"),
                                        //         Text(
                                        //           unconfirmedViewModel
                                        //                   .unConfirmedTransactionDetailListData[
                                        //                       index]
                                        //                   ?.reason ??
                                        //               "",
                                        //           textAlign: TextAlign.end,
                                        //           style: theme.bodyBold
                                        //               .copyWith(
                                        //                   letterSpacing: .2),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Expanded(
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       buildText("TotalAmount"),
                                        //       Text(
                                        //         (BaseNumberFormat(
                                        //                     number: unconfirmedViewModel
                                        //                         .unConfirmedTransactionDetailListData[
                                        //                             index]
                                        //                         .totalvalue)
                                        //                 .formatCurrency())
                                        //             .toString(),
                                        //         style: theme.bodyBold.copyWith(
                                        //             letterSpacing: .2),
                                        //         textAlign: TextAlign.end,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Visibility(
                                        //   visible:
                                        //       widget?.selectedOption?.code ==
                                        //           "PAYMENT_ENTRY",
                                        //   child: Expanded(
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //       children: [
                                        //         buildText("Settlement Date"),
                                        //         Text(
                                        //           unconfirmedViewModel
                                        //                   .unConfirmedTransactionDetailListData[
                                        //                       index]
                                        //                   ?.settlementdue ??
                                        //               "",
                                        //           style: theme.bodyBold
                                        //               .copyWith(
                                        //                   letterSpacing: .2),
                                        //           textAlign: TextAlign.end,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Visibility(
                                        //     visible:
                                        //         widget?.selectedOption?.code ==
                                        //             "PAYMENT_ENTRY",
                                        //     child: Expanded(
                                        //       child: Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceBetween,
                                        //         children: [
                                        //           buildText("Settlement Days"),
                                        //           Text(
                                        //             (unconfirmedViewModel
                                        //                         .unConfirmedTransactionDetailListData[
                                        //                             index]
                                        //                         ?.settlementduedays ??
                                        //                     0)
                                        //                 .toString(),
                                        //             style: theme.bodyBold
                                        //                 .copyWith(
                                        //                     letterSpacing: .2),
                                        //             textAlign: TextAlign.end,
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                  // Container(
                                  //   margin: EdgeInsets.only(
                                  //       right: 8, left: 8, bottom: 4),
                                  //   decoration: BoxDecoration(
                                  //     color: themeData.primaryColor
                                  //         .withOpacity(.7),
                                  //     borderRadius: BorderRadius.only(
                                  //         bottomLeft: Radius.circular(12),
                                  //         bottomRight: Radius.circular(12)),
                                  //   ),
                                  //   //  color: themeData.primaryColor,
                                  //   child: Visibility(
                                  //     visible: widget?.selectedOption?.code ==
                                  //         "PAYMENT_ENTRY",
                                  //     child: ExpansionTile(
                                  //         tilePadding: EdgeInsets.only(
                                  //             left: 8, right: 8),
                                  //         childrenPadding: EdgeInsets.only(
                                  //             right: 12, left: 12),
                                  //         title: Text(
                                  //           "Remarks",
                                  //           style: TextStyle(fontSize: 14),
                                  //         ),
                                  //         children: [
                                  //           BaseTextField(
                                  //             displayTitle: "",
                                  //             vector: AppVectors.remarks,
                                  //             initialValue: unconfirmedViewModel
                                  //                     ?.unConfirmedTransactionDetailListData[
                                  //                         index]
                                  //                     ?.paymentremarks ??
                                  //                 "",
                                  //             isEnabled: false,
                                  //           ),
                                  //         ]),
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          }),
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
                            children: unconfirmedViewModel.statusTypes.map((e) {
                              final bool reject = e.code == "REJECTED";

                              return Expanded(
                                  child: Container(
                                margin: EdgeInsets.all(6),
                                child: _ApprovalButton(
                                    color: reject
                                        ? Colors.white
                                        : ThemeProvider.of(context)
                                            .primaryColorDark,
                                    icon: reject
                                        ? Icons.delete_forever
                                        : Icons.check,
                                    title: reject
                                        ? Visibility(
                                            visible: true,
                                            // unconfirmedViewModel
                                            //         .unConfirmedFilterModel.optionCode !=
                                            //     "PAYMENT_ENTRY",
                                            child: Text(
                                              (e.description
                                                      .replaceAll("ed", ""))
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                      ThemeProvider.of(context)
                                                          .primaryColorDark),
                                            ),
                                          )
                                        : Visibility(
                                            visible: true,
                                            child: Text(
                                                (e.description
                                                        .replaceAll("d", ""))
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))),
                                    onPressed: () {
                                      if (unconfirmedViewModel
                                              .addedUnconfirmedItems.length >
                                          0) {
                                        unconfirmedViewModel
                                            .onSaveUnConfirmedTransaction(
                                                e.code == "APPROVED"
                                                    ? "A"
                                                    : "R",
                                                "SALES_INVOICE");
                                      } else {
                                        AppSnackBar.of(context).show(
                                            "Please select one transaction");
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
                              if (unconfirmedViewModel
                                      .addedUnconfirmedItems.length >
                                  0) {
                                unconfirmedViewModel
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
                              if (unconfirmedViewModel
                                      .addedUnconfirmedItems.length >
                                  0) {
                                unconfirmedViewModel
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
                )
              : (unconfirmedViewModel.statusCode == 1) &&
                      (unconfirmedViewModel
                              .unConfirmedTransactionDetailListData?.isEmpty ??
                          false)
                  ? Center(
                  child: EmptyResultView(
                    message: "No data found",
                  ),
                    )
                  : BaseLoadingView(
                      message: "Loading",
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
        //autovalidate: false,
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

            //return widget.viewModel.addedUnconfirmedItems;
          } else {
            widget.viewModel.onRemoveUnconfirmedData(widget.transaction);
          }
        });
        print("ylo${widget.viewModel.addedUnconfirmedItems.length}");
      },
    );
  }
}
