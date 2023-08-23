import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/res/drawbles/app_images.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_history_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_history_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_status.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/history_view.dart';
import 'package:redstars/utility.dart';

class DocumentApprovalRelation extends StatelessWidget
    with BaseStoreInitialMixin<AppState, DocumentApprHistoryViewModel> {
  final TransactionDetails transaction;

  const DocumentApprovalRelation({Key key, this.transaction}) : super(key: key);

  @override
  void init(Store store, BuildContext context) {
    super.init(store, context);
    store.dispatch(fetchTransactionStatusList(
        transaction: transaction, optionId: transaction.optionId));
    store.dispatch(fetchTransactionsApprovals(
        dataId: transaction.refTableDataId,
        tableId: transaction.refTableId,
        optionId: transaction.optionId));
    store.dispatch(fetchTransactionsHistory(
        dataId: transaction.refTableDataId, optionId: transaction.optionId));
  }

  @override
  Widget buildChild(
      BuildContext context, DocumentApprHistoryViewModel viewModel) {
    final _colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return Scaffold(
        appBar: BaseAppBar(
            title: Text('${transaction.transNo}'),
            elevation: 0,
            actions: [
              Builder(
                  builder: (context) {
                    return
                    InkWell(onTap: ()=> Scaffold.of(context).openEndDrawer(),child:Padding(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 12),
                      child: ImageIcon(AppImages.relationship,semanticLabel: "Relationship",),
                    ));
                   } )
            ]),
        endDrawer:  Theme(
    data: Theme.of(context).copyWith(
    canvasColor: themeData.primaryColor, //This will change the drawer background to blue.
    //other styles
    ),
       child: Drawer(
            child: ListView( children: <Widget>[
          DrawerHeader(margin: EdgeInsets.zero,

              decoration: BoxDecoration(color:themeData.primaryColor),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Relationship",
                      style: BaseTheme.of(context)
                          .title
                          .copyWith(color: _colors.white)))),
          AppTreeView(
              viewModel.tranactionStatus,
              onLeafItemClick: (data) {
                Navigator.pop(context);
                TransactionStatus transactionStatus =
                    TransactionStatus.fromJson(data);
                viewModel.onRelationItemSelect(
                    dataId: transactionStatus.hdrId,
                    tableId: transactionStatus.tableId,
                    optionId: transactionStatus.optionId);
              },

          )
        ]))),
        body: _DocumentApprovalUsers(
            transaction: transaction, viewModel: viewModel));
  }

//      DocumentApprovalRelationBody(
//          transaction: transaction, viewModel: viewModel);

  @override
  Widget buildErrorView(BuildContext context, String message) => Scaffold(
      appBar: BaseAppBar(
        title: Text('${transaction.transNo}'),
        elevation: 0,
      ),
      body: Center(child: ErrorResultView(message: message)));

  @override
  DocumentApprHistoryViewModel converter(Store store) =>
      DocumentApprHistoryViewModel.fromStore(store);

  @override
  Widget showLoading({String loadingMessage, TextStyle style}) {
    return Scaffold(
        appBar: BaseAppBar(
          title: Text('${transaction.transNo}'),
          elevation: 0,
        ),
        body: super.showLoading(loadingMessage: loadingMessage, style: style));
  }
}

class _DocumentApprovalUsers extends StatelessWidget {
  final TransactionDetails transaction;
  final DocumentApprHistoryViewModel viewModel;

  _DocumentApprovalUsers({this.transaction, this.viewModel});

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return BaseNestedTabBar(
          color: themeData.primaryColor,
          unselectedLabelColor: colors.white,
          labelColor: themeData.primaryColorDark,
          indicator:
          // ShapeDecoration(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     color: colors.white),
          BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.white),
          tabs: <BaseTabPage>[
            BaseTabPage(
              title: "Approval History",
              body: HistoryListView(
                  isApprovalHistory: true,
                  transactionData: viewModel.transactionApprovals),
            ),
            BaseTabPage(
              title: "Transaction History",
              body: HistoryListView(
                  isApprovalHistory: false,
                  transactionData: viewModel.transactionHistories),
            )
          ],
    );
  }
}
