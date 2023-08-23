import 'dart:developer';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/temp_transaction_approval_dtl.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/transaction_approval_filter_screen.dart';
import 'package:redstars/utility.dart';

class TransactionUnblockApprovalDetailScreen extends StatefulWidget {
  var optionId;
  var transTableId;
  var transId;
  var approveOptionId;
  var reportFormtId;
  var id;
  var start;
  final bool isBranchBlocked;
  int branchId;
  int flg;
  bool allBranchYN;
  final TransactionUnblockReqApprlViewModel viewModel;
  final String title;
  final int optionIdFromBranchBlock;
  final bool isUserRightToApprove;

  TransactionUnblockApprovalDetailScreen(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.approveOptionId,
      this.id,
        this.isBranchBlocked,
      this.branchId,
      this.allBranchYN,
      this.flg,
      this.reportFormtId,
      this.viewModel,
      this.title,
      this.optionIdFromBranchBlock,
      this.start,
      this.isUserRightToApprove});

  @override
  _TransactionUnblockApprovalDetailScreenState createState() =>
      _TransactionUnblockApprovalDetailScreenState(
          optionId: optionId,
          transTableId: transTableId,
          transId: transId,
          branchId: branchId,
          flg: flg,
          allBranchYN: allBranchYN,
          approveOptionId: approveOptionId);
}

class _TransactionUnblockApprovalDetailScreenState
    extends State<TransactionUnblockApprovalDetailScreen> {
  var transTableId;
  var transId;
  List transactionList;
  List documentList;
  List alertList;
  int lastApproval;
  int branchId;
  int flg;
  var optionId;
  var approveOptionId;
  String fTitle;
  bool allBranchYN = false;

  _TransactionUnblockApprovalDetailScreenState(
      {this.optionId,
      this.transTableId,
      this.transId,
      this.branchId,
      this.flg,
        this.allBranchYN,
      this.approveOptionId});
  int optionId3;
  int finalTransReqOptionId;
  int notificationOptionId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    // bool allBranchYN;
    // branchId == null ? allBranchYN = true : allBranchYN = false;
    BaseTheme style = BaseTheme.of(context);
    int notificationIdSave = widget.id;
    return BaseView<AppState, TransactionUnblockReqApprlViewModel>(
        init: (store, context) async {
          Future.delayed(Duration(seconds: 0)).then((value) async {
            if (await store.state.transactionUnblockReqApprlState
                    ?.transactionApprovalListview?.transactionUnblockListView !=
                null)
              await store.state.transactionUnblockReqApprlState
                  ?.transactionApprovalListview?.transactionUnblockListView
                  .clear();
            return true;
          }).then((value) async {
            // int branchid= await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);

          print(widget.id);
          print("List level branch is ${widget.branchId}");
          print("List level flag ${widget.viewModel.isAllBranchSelected}");
          widget.allBranchYN = widget.viewModel.isAllBranchSelected;
          final optionId = store.state.homeState.selectedOption.optionId;
           // notificationOptionId = store.state.homeState.selectedOption.id;
            final notificationOptionId =
                store.state.homeState.selectedOption.id;
          final optionId2 = store.state.homeState.menuItems.indexWhere(
              (element) =>
                  element.title == "Transaction Unblock Request Approval");
            finalTransReqOptionId = widget
                        .viewModel
                        ?.transactionApprovalListview
                        ?.transactionUnblockListView
                        ?.length ==
                  0
              ? null
              : widget.viewModel?.transactionApprovalListview
                  ?.transactionUnblockListView?.first?.requestoptionid;

          if (optionId2 != null && optionId2 > 0) {
            optionId3 =
              store.state.homeState.menuItems[optionId2].module.optionId;
          }
          await store.dispatch(fetchTransactionApprovalHeading(
              rptFormatId: widget.reportFormtId));
          await store.dispatch(fetchTransactionApprovalReqList(
            branchId: widget.allBranchYN == true?null:widget.branchId,
            transReqOptionId: finalTransReqOptionId,
            flg: flg,
            id: widget.id,
            allBranchYN: widget.allBranchYN,
            notificationOptionId: notificationOptionId,
            notificationId: notificationIdSave,
            optionId: optionId3 ?? widget.optionIdFromBranchBlock,
          ));
          });
        },
        converter: (store) =>
            TransactionUnblockReqApprlViewModel.fromStore(store),
        onDispose: (store) async {
          int branch= await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
          final optionId = store.state.homeState.selectedOption.optionId;
          // notificationOptionId = store.state.homeState.selectedOption.id;
          final notificationOptionId = store.state.homeState.selectedOption.id;
          final optionId2 = store.state.homeState.menuItems.indexWhere(
              (element) =>
                  element.title == "Transaction Unblock Request Approval");
          finalTransReqOptionId = widget.viewModel.transactionApprovalListview
              ?.transactionUnblockListView?.first?.requestoptionid;
          if (optionId2 != null && optionId2 > 0) {
            optionId3 =
                store.state.homeState.menuItems[optionId2].module.optionId;
          }
          store.dispatch(fetchTransactionApprovalHeading(
              rptFormatId: widget.reportFormtId));
          store.dispatch(fetchTransactionApprovalReqList(
            branchId: widget.allBranchYN==true?null:widget.branchId,
            transReqOptionId: finalTransReqOptionId,
            flg: flg,
            id: widget.id,
            allBranchYN: widget.allBranchYN,
            notificationOptionId: notificationOptionId,
            notificationId: notificationIdSave,
            optionId: optionId3 ?? widget.optionIdFromBranchBlock,
          ));
          store.dispatch(fetchUnreadCount(
              branchId2: store.state.transactionUnblockReqApprlState?.branch,
              allBranchYN: allBranchYN));
          store.dispatch(clearFilterAction());
          },
        builder: (context, viewModel) {
          if (viewModel.tranansctionScreenHeadingList
                  ?.transactionUnblockListHeading?.first?.dtl !=
              null) {
            viewModel.tranansctionScreenHeadingList
                ?.transactionUnblockListHeading?.first?.dtl
                ?.forEach((element) {
              if (element.dataindex == "transno") {
                fTitle = element.header;
                return fTitle;
              }
              return fTitle;
            });
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Date filter",
              child: Icon(
                Icons.filter_list,
                color: themeData.primaryColorDark,
              ),
              onPressed: () {
                showDialog(
                    context,
                    viewModel.model,
                    widget.id,
                    viewModel,
                    widget.isBranchBlocked,
                    branchId,
                    widget.optionIdFromBranchBlock);
              },
            ),
            appBar: BaseAppBar(
              title: Text(widget.title ?? ""),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 8,
                ),
                // Flexible(child: TransactionDtl1(reportHeader: viewModel?.tranansctionScreenHeadingList
                //     ?.transactionUnblockListHeading?.first,
                //   reportData: viewModel
                //       ?.transactionApprovalListview?.transactionUnblockListView,)),
                Flexible(
                    child: TransactionUnblockApprovalListViewScreen(
                        header: viewModel.tranansctionScreenHeadingList
                            ?.transactionUnblockListHeading?.first?.dtl,

                        isAllBranchSelected: widget.allBranchYN,
                  reportHeader: viewModel.tranansctionScreenHeadingList
                      ?.transactionUnblockListHeading?.first,
                        reportData: viewModel?.transactionApprovalListview
                            ?.transactionUnblockListView,
                  viewModel: viewModel,
                        notificationOptionId: notificationOptionId,
                        subOptionId : widget.id,
                        reportFormatId: widget.reportFormtId,
                        optionIdFromBranchBlock: widget.optionIdFromBranchBlock,
                        branchid: widget.branchId,
                        transReqOptionId: viewModel?.transactionApprovalListview
                                    ?.transactionUnblockListView?.length ==
                                0
                            ? 0
                            : viewModel
                                ?.transactionApprovalListview
                                ?.transactionUnblockListView
                                ?.first
                                ?.requestoptionid,
                        isFromBranchBlock: widget?.isBranchBlocked ?? false,
                        isUserRightToApprove:
                            widget?.isUserRightToApprove ?? false)),
              ],
            ),
          );
        });
  }

  showDialog(
    BuildContext context,
    PVFilterModel model,
    int id,
    TransactionUnblockReqApprlViewModel viewModel,
      bool isBranchBlocked,
    int branchId,
    int optionIdFromBranchBlock,
  ) async {
    PVFilterModel resultSet = await appShowChildDialog(
        context: context,
        child: TransactionReqApprovalFilter(
            viewModel: viewModel,
            model: viewModel.model,
            filterTitle1: fTitle,
            reportFormatId: widget.reportFormtId,
          id: widget.id,
        ));

    viewModel.listByFilter(
        resultSet,
        id,
        widget.reportFormtId,
        viewModel.optionId3 ?? widget.optionIdFromBranchBlock,
        isBranchBlocked,
        branchId);
  }
}
